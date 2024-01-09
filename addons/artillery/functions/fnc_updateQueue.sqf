#include "script_component.hpp"

params ["_entity"];

private _queue = _entity getVariable [QPVAR(queue),[]];

diag_log str ["SSS: updateQueue",CBA_missionTime,_entity,_queue];

(_entity getVariable QPVAR(request)) params ["_plan","_loops","_loopDelay","_coordinated"];

if (_queue isEqualTo []) exitWith {
	private _activeLoops = _entity getVariable QPVAR(loops);

	if (_activeLoops == 0) then {
		[_entity,false] call EFUNC(common,cooldown);

		{
			{_x setVariable [QPVAR(host),nil,true]} forEach (_x getVariable [QPVAR(vehicles),[_x]]);

			if (!isNil {_x getVariable QPVAR(busy)}) then {
				[_x,false] call EFUNC(common,cooldown);
			};
		} forEach _coordinated;

		[QPVAR(requestCompleted),[_entity getVariable [QPVAR(requester),objNull],_entity,["FIRE MISSION",[_plan,_loops,_loopDelay,_coordinated]]]] call CBA_fnc_globalEvent;

		NOTIFY(_entity,LSTRING(RequestCompleted));
	} else {
		if (_activeLoops > 0) then {
			NOTIFY_1(_entity,LSTRING(LoopsLeft),_activeLoops);
			_activeLoops = _activeLoops - 1;
			_entity setVariable [QPVAR(loops),_activeLoops,true];
		} else {
			NOTIFY(_entity,LSTRING(EndlessLoops));
		};

		_entity setVariable [QPVAR(queue),+_plan];

		[FUNC(updateQueue),_entity,_loopDelay] call CBA_fnc_waitAndExecute;
	};
};

(_queue deleteAt 0) params ["_area","_sheaf","_magazines","_rounds","_execDelay","_firingDelay"];
_entity setVariable [QPVAR(queue),_queue];

_entity getVariable QPVAR(firingDelay) params ["_firingMin","_firingMax"];
private _fullFiringDelay = [_firingMin max _firingDelay,_firingMax max _firingDelay];
//DEBUG_1("Combined firing delays: %1",_fullFiringDelay);
//DEBUG_1("Forced execution delay: %1",_execDelay);

if (_execDelay > 0) then {
	NOTIFY_1(_entity,LSTRING(notifyPreparingForStrike),_execDelay call EFUNC(common,formatTime));
};

[{
	params ["_entity","_coordinated","_area","_sheaf","_magazines","_rounds","_firingDelay"];

	_entity setVariable [QPVAR(activeTarget),_area # 0,true];

	private _active = [];
	private _fnc_processMags = {
		params ["_entity"];

		private _ammunition = _entity getVariable QPVAR(ammunition);

		if (isNil "_ammunition") exitWith {[_magazines,_rounds]};
		if (_ammunition isEqualTo []) exitWith {[[],0]};

		private _magTypes = _ammunition apply {_x # 0};
		private _validRounds = _rounds;

		{
			private _roundLimit = _ammunition # (_magTypes find _x) # 1;
			if (_roundLimit > 0) then {_validRounds = _validRounds min _roundLimit};
		} forEach (_magazines arrayIntersect _magTypes);

		private _validMags = _magazines select {
			private _roundLimit = _ammunition # (_magTypes find _x) # 1;
			_roundLimit < 0 || _roundLimit - _validRounds >= 0
		};

		//{
		//	private _index = _magTypes find _x;
		//	private _roundLimit = _ammunition # _index # 1;
		//
		//	if (_roundLimit >= 0) then {
		//		_ammunition set [_index,[_x,(_roundLimit - _validRounds) max 0]];
		//	};
		//} forEach _validMags;
		//
		//_entity setVariable [QPVAR(ammunition),_ammunition,true];

		private _cooldownTimer = _entity getVariable [QPVAR(cooldownTimer),0];
		_entity setVariable [QPVAR(cooldownTimer),_cooldownTimer + (_validRounds * (_entity getVariable [QPVAR(roundCooldown),0])),true];

		[_validMags,_validRounds]
	};
	private _fnc_shareRounds = {
		params ["_vehicles","_totalRounds"];

		private _vehiclesRounds = _vehicles apply {[_x,0]};
		private _max = count _vehicles - 1;
		private _index = 0;

		for "_i" from 1 to _totalRounds do {
			_vehiclesRounds # _index set [1,_vehiclesRounds # _index # 1 + 1];
			_index = _index + 1;
			if (_index > _max) then {_index = 0};
		};

		_vehiclesRounds
	};

	switch _sheaf do {
		case "PARALLEL" : {
			private _center = (_entity getVariable QPVAR(vehicles)) call EFUNC(common,positionAvg);
			private _distDir = [_center distance2D (_area # 0),_center getDir (_area # 0)];

			{
				private _vehicles = _x getVariable [QPVAR(vehicles),[_x]];

				(_x call _fnc_processMags) params ["_validMags","_validRounds"];

				{
					_x params ["_vehicle","_rounds"];

					if ([_vehicle,[AGLtoASL (_vehicle getPos _distDir),_area # 1,_area # 2,0,false],_validMags,_rounds,_firingDelay] call FUNC(fire)) then {
						_active pushBack _vehicle;
					} else {
						LOG_WARNING("vehicle cannot fire");
					};
				} forEach ([_vehicles,_validRounds] call _fnc_shareRounds);
			} forEach ([_entity] + _coordinated);
		};
		case "CONVERGED";
		case "BOX" : {
			{
				private _vehicles = _x getVariable [QPVAR(vehicles),[_x]];

				(_x call _fnc_processMags) params ["_validMags","_validRounds"];

				{
					_x params ["_vehicle","_rounds"];

					if ([_vehicle,_area,_validMags,_rounds,_firingDelay] call FUNC(fire)) then {
						_active pushBack _vehicle;
					} else {
						LOG_WARNING("vehicle cannot fire");
					};
				} forEach ([_vehicles,_validRounds] call _fnc_shareRounds);
			} forEach ([_entity] + _coordinated);
		};
		case "CREEPING" : {
			_area params ["_center","_width","_height","_angle","_isRect"];

			private _totalVehicles = 0;
			
			{
				private _vehicles = _x getVariable QPVAR(vehicles);
				
				if (isNil "_vehicles") then {
					_totalVehicles = _totalVehicles + 1
				} else {
					_totalVehicles = _totalVehicles + count _vehicles;
				};
			} forEach ([_entity] + _coordinated);

			private _laneWidth = _width * 2 / _totalVehicles;
			private _laneCenter = AGLtoASL (_center getPos [_width - (_laneWidth * 0.5),_angle - 90]);

			{
				private _vehicles = _x getVariable [QPVAR(vehicles),[_x]];

				(_x call _fnc_processMags) params ["_validMags","_validRounds"];

				{
					_x params ["_vehicle","_rounds"];

					//if ([_vehicle,[[_laneCenter,_laneWidth / _totalVehicles,_height,_angle,_isRect],true,false],_validMags,_rounds,_firingDelay] call FUNC(fire)) then {
					if ([_vehicle,[[_laneCenter,_width / _totalVehicles,_height,_angle,_isRect],true,true],_validMags,_rounds,_firingDelay] call FUNC(fire)) then {
						_active pushBack _vehicle;
					} else {
						LOG_WARNING("vehicle cannot fire");
					};

					_laneCenter = AGLtoASL (_laneCenter getPos [_laneWidth,_angle + 90]);
				} forEach ([_vehicles,_validRounds] call _fnc_shareRounds);
			} forEach ([_entity] + _coordinated);
		};
	};

	_entity setVariable [QPVAR(active),_active];
},[_entity,_coordinated,_area,_sheaf,_magazines,_rounds,_fullFiringDelay],_execDelay] call CBA_fnc_waitAndExecute;
