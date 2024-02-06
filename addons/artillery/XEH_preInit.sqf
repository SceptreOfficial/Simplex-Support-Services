#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

GVAR(sheafNames) = createHashMapFromArray [
	["CONVERGED",LLSTRING(Converged)],
	["PARALLEL",LLSTRING(Parallel)],
	["BOX",LLSTRING(Box)],
	["CREEPING",LLSTRING(Creeping)]
];

[QGVAR(firing),{
	params ["_artillery","_area","_magazine","_rounds","_ETA"];

	if (!local _artillery) exitWith {};

	// Mod compat: 
	// - BROKEN: 3CB Hilux Rocket Artillery: will not aim on Y axis for 1st spawned vehicle???
	// - HANDLED: RHS M119: spawns a shell casing on reload that breaks the aiming for some reason.
	// - HANDLED: RHS D30: same as ^^^
	switch true do {
		case (_artillery isKindOf "RHS_M119_base") : {
			[{	
				{deleteVehicle _x} forEach (_this nearEntities ["rhs_casing_105mm_m14b1",2]);
				!(alive _this && _this getVariable [QPVAR(firing),false])
			},{},_artillery] call CBA_fnc_waitUntilAndExecute;
		};
		case (_artillery isKindOf "rhs_D30_base") : {
			[{	
				{deleteVehicle _x} forEach (_this nearEntities ["rhs_casing_122mm",2]);
				!(alive _this && _this getVariable [QPVAR(firing),false])
			},{},_artillery] call CBA_fnc_waitUntilAndExecute;
		};
	};
}] call CBA_fnc_addEventHandler;

if (isServer) then {
	[QGVAR(fireMission),{
		params ["_player","_entity","_plan","_loops","_loopDelay","_coordinated"];

		_coordinated = _coordinated select {
			!(_x getVariable [QPVAR(busy),false]) &&
			(_x getVariable [QPVAR(vehicles),[_x]]) findIf {!isNull (_x getVariable [QPVAR(host),objNull])} == -1
		};

		_entity setVariable [QPVAR(requester),_player,true];
		_entity setVariable [QPVAR(queue),+_plan];
		_entity setVariable [QPVAR(request),+[_plan,_loops,_loopDelay,_coordinated],true];
		_entity setVariable [QPVAR(loops),_loops,true];
		_entity setVariable [QPVAR(loopDelay),_loopDelay,true];

		{
			private _vehicles = _x getVariable [QPVAR(vehicles),[_x]];

			{_x setVariable [QPVAR(host),_entity,true]} forEach _vehicles;

			if (!isNil {_x getVariable QPVAR(busy)}) then {
				[_entity,true,"FIRE MISSION",[LSTRING(statusFireMission),RGBA_YELLOW]] call EFUNC(common,setStatus);
				_x setVariable [QPVAR(cooldownTimer),_x getVariable [QPVAR(cooldown),0],true];
			};
		} forEach ([_entity] + _coordinated);

		private _delay = (_entity getVariable QPVAR(executionDelay)) call EFUNC(common,randomMinMax);
		//DEBUG_1("Random delay: %1",_delay);

		[FUNC(updateQueue),_entity,_delay] call CBA_fnc_waitAndExecute;

		[QPVAR(requestSubmitted),[_player,_entity,["FIRE MISSION",[_plan,_loops,_loopDelay,_coordinated]]]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(abortFireMission),{
		params ["_player","_entity"];
		(_entity getVariable QPVAR(request)) params ["_plan","_loops","_loopDelay","_coordinated"];

		{
			private _vehicles = _x getVariable [QPVAR(vehicles),[_x]];

			{
				_x setVariable [QPVAR(host),nil,true];
				_x setVariable [QGVAR(abort),true,true];
			} forEach _vehicles;

			if (!isNil {_x getVariable QPVAR(busy)}) then {
				[_x,false] call EFUNC(common,cooldown);
			};
		} forEach ([_entity] + _coordinated);

		_entity setVariable [QPVAR(queue),[]];
		_entity setVariable [QPVAR(notifiedFiring),nil];
		_entity setVariable [QPVAR(notifiedSplash),nil];

		NOTIFY(_entity,LSTRING(notifyAbort));

		[QPVAR(requestAborted),[_player,_entity,["FIRE MISSION",[_plan,_loops,_loopDelay,_coordinated]]]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(relocate),{
		params ["_player","_entity","_posASL"];

		_entity setVariable [QPVAR(requester),_player,true];
		_entity setVariable [QPVAR(request),[_posASL],true];
		[_entity,true,"RELOCATE",[LSTRING(statusRelocate),RGBA_YELLOW]] call EFUNC(common,setStatus);

		if (missionNamespace getVariable [QGVAR(relocationTeleport),true]) then {
			(_entity getVariable [QPVAR(relocation),[false,60,60]]) params ["","_relocationDelay","_relocationSpeed"];
			private _formCenter = _entity getVariable QPVAR(formCenter);
			private _distance = _formCenter distance2D _posASL;
			
			[{
				params ["_entity","_posASL","_relocationTick"];
				CBA_missionTime >= _relocationTick && {_entity call FUNC(vehiclesReady)}
			},{
				params ["_entity","_posASL"];

				if (isNull _entity) exitWith {};

				private _formCenter = _entity getVariable QPVAR(formCenter);
				private _diff = _posASL vectorDiff _formCenter;

				{
					private _base = _x getVariable [QPVAR(base),getPosASL _x];
					private _baseNormal = _x getVariable [QPVAR(baseNormal),[vectorDir _x,vectorUp _x]];
					private _newBase = _base vectorAdd _diff;

					[_x,_newBase] call FUNC(placementSearch) params ["_safePos","_safeUp"];

					if (!isNil "_safePos") then {
						_x setPosASL _safePos;
						_x setVectorDirAndUp [_baseNormal # 0,_safeUp];
					} else {
						_newBase set [2,getTerrainHeightASL _newBase];
						_x setPosASL _newBase;
						_x setVectorDirAndUp [_baseNormal # 0,surfaceNormal _newBase];
					};					

					_x setVariable [QPVAR(base),getPosASL _x,true];
					_x setVariable [QPVAR(baseNormal),[vectorDir _x,vectorUp _x],true];
				} forEach (_entity getVariable QPVAR(vehicles));

				_entity setVariable [QPVAR(formCenter),(_entity getVariable QPVAR(vehicles)) call EFUNC(common,positionAvg),true];

				if (GVAR(relocateCooldown)) then {
					[_entity,true] call EFUNC(common,cooldown);
				} else {
					_entity call EFUNC(common,setStatus);
				};

				[QPVAR(requestCompleted),[_entity getVariable [QPVAR(requester),objNull],_entity,["RELOCATE",[_posASL]]]] call CBA_fnc_globalEvent;

				NOTIFY(_entity,LSTRING(notifyRelocateComplete));
			},[_entity,_posASL,CBA_missionTime + (_relocationDelay + (_distance / (_relocationSpeed / 3.6)))]] call CBA_fnc_waitUntilAndExecute;
		} else {
			{[QEGVAR(common,enableAIFeature),[_x,["PATH",true]],_x] call CBA_fnc_targetEvent} forEach (_entity getVariable QPVAR(vehicles));

			private _group = _entity getVariable [QPVAR(group),grpNull];

			private _waypoint1 = _group addWaypoint [ASLtoAGL _posASL,0];
			_waypoint1 setWaypointType "MOVE";
			_waypoint1 setWaypointPosition [_posASL,-1];
			_waypoint1 setWaypointFormation "COLUMN";
			private _waypoint2 = _group addWaypoint [ASLtoAGL _posASL,0];
			_waypoint2 setWaypointType "SCRIPTED";
			_waypoint2 setWaypointScript format ["%1 %2",QPATHTOF(functions\fnc_wpRelocate.sqf),[_posASL]];
			_waypoint2 setWaypointPosition [_posASL,-1];

			_group setCurrentWaypoint _waypoint1;
		};

		[QPVAR(requestSubmitted),[_player,_entity,["RELOCATE",[_posASL]]]] call CBA_fnc_globalEvent;

		private _grid = [_posASL] call EFUNC(common,getMapGridFromPos);

		NOTIFY_2(_entity,LSTRING(notifyRelocate),_grid # 0,_grid # 1);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(abortRelocate),{
		params ["_player","_entity"];

		[_entity,true] call EFUNC(common,clearWaypoints);

		if (GVAR(relocateCooldown)) then {
			[_entity,true] call EFUNC(common,cooldown);
		} else {
			_entity call EFUNC(common,setStatus);
		};

		[{
			_this call FUNC(vehiclesReady)
		},{
			{[QEGVAR(common,enableAIFeature),[_x,["PATH",false]],_x] call CBA_fnc_targetEvent} forEach (_this getVariable QPVAR(vehicles))
		},_entity] call CBA_fnc_waitUntilAndExecute;

		[QPVAR(requestAborted),[_player,_entity,["RELOCATE",_entity getVariable QPVAR(request)]]] call CBA_fnc_globalEvent;

		NOTIFY(_entity,LSTRING(notifyRelocateAbort));
	}] call CBA_fnc_addEventHandler;

	[QGVAR(firing),{
		params ["_vehicle","_area","","_rounds","","_ETA"];

		private _entity = _vehicle getVariable [QPVAR(host),objNull];
		
		if (isNull _entity || _entity getVariable [QPVAR(notifiedFiring),false]) exitWith {};

		private _target = _entity getVariable [QPVAR(activeTarget),_area # 0];

		if (GVAR(taskMarkers)) then {
			[_entity,_target,"mil_warning_noShadow","ColorOrange",LSTRING(StrikeInbound),_rounds * 3 + _ETA] call EFUNC(common,tempMarker);
		};

		_entity setVariable [QPVAR(notifiedFiring),true];

		// LOCALIZE THIS
		private _grid = [_target] call EFUNC(common,getMapGridFromPos);
		_grid = format ["%1 E %2 N",_grid # 0,_grid # 1];

		NOTIFY_2(_entity,LSTRING(InitStrike),_grid,_ETA);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(splash),{
		params ["_vehicle","_area"];

		private _entity = _vehicle getVariable [QPVAR(host),objNull];
		
		if (isNull _entity || _entity getVariable [QPVAR(notifiedSplash),false]) exitWith {};
		
		_entity setVariable [QPVAR(notifiedSplash),true];

		// LOCALIZE THIS
		private _grid = [_area # 0] call EFUNC(common,getMapGridFromPos);
		_grid = format ["%1 E %2 N",_grid # 0,_grid # 1];

		NOTIFY_2(_entity,LSTRING(Splash),_grid,_ETA);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(complete),{
		params ["_vehicle"];

		private _entity = _vehicle getVariable [QPVAR(host),objNull];
		if (isNull _entity) exitWith {};

		private _active = (_entity getVariable [QPVAR(active),[]]) select {alive _x && _vehicle != _x};

		if (_active isEqualTo []) then {
			_entity setVariable [QPVAR(notifiedFiring),nil];
			_entity setVariable [QPVAR(notifiedSplash),nil];
			_entity call FUNC(updateQueue);
		} else {
			_entity setVariable [QPVAR(active),_active];
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(fired),{
		params ["_entity","_vehicle","_magazine"];

		if (isNull _entity || isNull _vehicle) exitWith {};
		
		private _ammunition = _entity getVariable [QPVAR(ammunition),[]];
		private _magIndex = _ammunition findIf {_magazine == _x # 0};

		if (_magIndex == -1) exitWith {};

		private _roundLimit = _ammunition # _magIndex # 1;

		if (_roundLimit >= 0) then {
			_roundLimit = (_roundLimit - 1) max 0;
			_ammunition # _magIndex set [1,_roundLimit];
			_entity setVariable [QPVAR(ammunition),_ammunition,true];
			{[QEGVAR(common,setAmmo),[_x,["",_roundLimit]],_x] call CBA_fnc_targetEvent} forEach (_entity getVariable QPVAR(vehicles));
		} else {
			[QEGVAR(common,setAmmo),[_vehicle,["",9999]],_vehicle] call CBA_fnc_targetEvent;
		};
	}] call CBA_fnc_addEventHandler;
};

[QPVAR(guiConfirm),FUNC(gui_confirm)] call CBA_fnc_addEventHandler;

[QPVAR(guiAbort),FUNC(gui_abort)] call CBA_fnc_addEventHandler;

[QPVAR(guiUnload),{
	params ["_service","_entity"];
	if (_service != QSERVICE) exitWith {};
	_entity setVariable [QGVAR(cache),+GVAR(plan)];
}] call CBA_fnc_addEventHandler;

[QPVAR(entityChanged),{
	params ["_entity","_oldEntity"];
	if (_oldEntity getVariable QPVAR(service) != QSERVICE) exitWith {};
	_oldEntity setVariable [QGVAR(cache),+GVAR(plan)];
}] call CBA_fnc_addEventHandler;

ADDON = true;
