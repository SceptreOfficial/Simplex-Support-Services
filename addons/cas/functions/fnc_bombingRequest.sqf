#include "..\script_component.hpp"

params ["_player","_entity","_request"];

private _class = _entity getVariable [QPVAR(class),""];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];

[_entity,true,"INGRESS",[LSTRING(statusBombingIngress),RGBA_YELLOW]] call EFUNC(common,setStatus);


private _spawnDistance = _entity getVariable [QPVAR(spawnDistance),8000];
private _speed = (700 / 3.6) min (getNumber (configFile >> "CfgVehicles" >> _class >> "maxSpeed") / 3.6);
private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];
private _ETADistance = [_virtualRunway distance2D _posASL,_spawnDistance] select (_virtualRunway isEqualTo [0,0,0]);
private _delay = (_entity getVariable QPVAR(spawnDelay)) call EFUNC(common,randomMinMax);
//DEBUG_1("Random delay: %1",_delay);

private _ETA = [_delay + _ETADistance / _speed,10] call EFUNC(common,formatTime);
private _msg = {format [LLSTRING(notifyBombingInbound),_this # 0 call EFUNC(common,formatGrid),_this # 1]};
NOTIFY_2(_entity,_msg,_posASL,_ETA);

_entity setVariable [QPVAR(cooldownTimer),_entity getVariable [QPVAR(cooldown),0],true];

[{
	params ["_player","_entity","_request","_class","_spawnDistance","_speed"];

	private _posASL = _request getOrDefault ["posASL",[0,0,0]];
	private _altitude = _request getOrDefault ["altitude",2000];
	private _ingress = _request getOrDefault ["ingress",0];
	private _egress = _request getOrDefault ["egress",0];
	private _spread = _request getOrDefault ["spread",250 min (_entity getVariable QPVAR(maxSpread))];
	private _spacing = _request getOrDefault ["spacing",50];
	private _aircraft = _request getOrDefault ["aircraft",3 min (_entity getVariable QPVAR(maxAircraft))];
	private _weapon = _request getOrDefault ["weapon",[]];
	private _interval = _request getOrDefault ["interval",0.5];

	private _size = _class call EFUNC(common,sizeOf);

	_spacing = _spacing + _size / 2;

	private _altitudeASL = getTerrainHeightASL _posASL + _altitude;
	private _group = createGroup [_entity getVariable QPVAR(side),true];
	private _laneCenter = _posASL getPos [_spacing * (_aircraft - 1) / 2,_ingress - 90];
	private _vehicles = [];
	private _tof = sqrt (2 * GRAVITY * _altitude) / GRAVITY;
	private _dropDistance = _speed * _tof;

	//private _endPos = _posASL getPos [_spread + _dropDistance,_ingress - 180];
	//_endPos set [2,_altitudeASL];
	private _egressPos = _posASL getPos [_spawnDistance,_egress];
	_egressPos set [2,_altitudeASL];

	systemChat str [_tof,_dropDistance];

	for "_i" from 1 to _aircraft do {
		private _startPos = _laneCenter getPos [_spawnDistance + random 200,_ingress];
		_startPos set [2,_altitudeASL + random 60];

		private _a = _laneCenter getPos [_spread,_ingress];
		private _b = _laneCenter getPos [-_spread,_ingress];
		private _c = _laneCenter getPos [_spread + _dropDistance,_ingress];
		private _d = _c getPos [-_spread * 2,_ingress];

		(createMarker [GEN_STR(_a),_a]) setMarkerType "hd_dot";
		(createMarker [GEN_STR(_b),_b]) setMarkerType "hd_dot";
		(createMarker [GEN_STR(_c),_c]) setMarkerType "hd_dot";
		(createMarker [GEN_STR(_d),_d]) setMarkerType "hd_dot";

		private _endPos = (_laneCenter getPos [_spread + _dropDistance,_ingress]) getPos [-_spread * 2,_ingress];
		_endPos set [2,_startPos # 2];

		_laneCenter = _laneCenter getPos [_spacing,_ingress + 90];

		private _vehicle = createVehicle [_class,_startPos,[],0,"FLY"];
		_vehicle setDir (_ingress - 180);
		_vehicle setPosASL _startPos;
		_vehicle setVectorUp [0,0,1];
		_vehicle setVelocityModelSpace [0,_speed,0];
		_vehicle lockDriver true;
		_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];
    	_group createVehicleCrew _vehicle;

		[_vehicle,_entity getVariable [QPVAR(pylons),[]]] call EFUNC(common,setPylons);

		[_vehicle,_entity,false] call EFUNC(common,commission);
		[_vehicle,"Deleted",{
			params ["_vehicle"];

			private _entity = _thisArgs;
			private _vehicles = _entity getVariable [QPVAR(vehicles),[]];

			if !(_vehicle in _vehicles) exitWith {};

			_vehicles = _vehicles - [_vehicle,objNull];
			_entity setVariable [QPVAR(vehicles),_vehicles,true];

			if (_vehicles isEqualTo []) then {
				[_entity,false] call EFUNC(common,cooldown);
			};
		},_entity] call CBA_fnc_addBISEventHandler;

		_vehicle setVariable [QGVAR(bombingData),[_player,_entity,_request,_startPos,_egressPos],true];
		_vehicles pushBack _vehicle;

		[
			_vehicle,
			_endPos,
			_spread * 2,
			_weapon,
			_entity getVariable [QPVAR(infiniteAmmo),false],
			_interval
		] call EFUNC(common,carpetBombing);
	};

	_group allowFleeing 0;
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";

	{
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
		_x disableAI "AUTOCOMBAT";
	} forEach units _group;

	private _wp1 = _group addWaypoint [ASLToAGL _posASL,0];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointDescription QGVAR(bombingIngress);

	private _wp2 = _group addWaypoint [ASLtoAGL _egressPos,0];
	_wp2 setWaypointType "MOVE";
	_wp2 setWaypointDescription QGVAR(bombingEgress);

	_group setVariable [QGVAR(bombingVehicles),_vehicles,true];
	_group addEventHandler ["WaypointComplete",{
		params ["_group","_waypointIndex"];

		if (waypointDescription _this != QGVAR(bombingEgress)) exitWith {};

		private _vehicles = _group getVariable [QGVAR(bombingVehicles),[]];
		
		{
			if (!alive _x) then {continue};

			[{
				deleteVehicleCrew _this;
				deleteVehicle _this;
			},_x,3] call CBA_fnc_waitAndExecute;
		} forEach _vehicles;
	}];
},[_player,_entity,_request,_class,_spawnDistance,_speed],_delay] call CBA_fnc_waitAndExecute;
