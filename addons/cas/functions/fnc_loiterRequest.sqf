#include "script_component.hpp"

params ["_player","_entity","_request"];

if (_entity getVariable [QPVAR(task),""] == "LOITER") exitWith {call FUNC(loiterUpdate)};

_entity getVariable QPVAR(guiLimits) params ["_altitudeMin","_altitudeMax","_radiusMin","_radiusMax"];
private _class = _entity getVariable [QPVAR(class),""];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];
private _altitude = _request getOrDefault ["altitude",_altitudeMin max LOITER_ALTITUDE_DEFAULT min _altitudeMax];
private _radius = _request getOrDefault ["radius",_radiusMin max LOITER_RADIUS_DEFAULT min _radiusMax];
private _ingress = _request getOrDefault ["ingress",-1];
private _egress = _request getOrDefault ["egress",-1];
private _spawnDistance = _entity getVariable [QPVAR(spawnDistance),6000];
private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];
private _speed = (getNumber (configFile >> "CfgVehicles" >> _class >> "maxSpeed")) / 3.6;
private _ETADistance = [_virtualRunway distance2D _posASL,_spawnDistance] select (_virtualRunway isEqualTo [0,0,0]);
private _delay = (_entity getVariable QPVAR(spawnDelay)) call EFUNC(common,randomMinMax);
//DEBUG_1("Random delay: %1",_delay);

[_entity,true,"INGRESS",[LSTRING(statusLoiterIngress),RGBA_YELLOW]] call EFUNC(common,setStatus);

private _ETA = [_delay + _ETADistance / _speed,10] call EFUNC(common,formatTime);
private _msg = {format [LLSTRING(notifyLoiterInbound),_this # 0 call EFUNC(common,formatGrid),_this # 1]};
NOTIFY_2(_entity,_msg,_posASL,_ETA);

_entity setVariable [QPVAR(cooldownTimer),_entity getVariable [QPVAR(cooldown),0],true];

_ingress = [random 360,_ingress] select (_ingress >= 0);
private _startPos = _virtualRunway;
if (_startPos isEqualTo [0,0,0]) then {
	_startPos = _posASL getPos [_spawnDistance,_ingress];
	_startPos set [2,_altitude];
};

if (_egress < 0) then {_egress = _posASL getDir _startPos};
private _endPos = _posASL getPos [_spawnDistance,_egress];
_endPos set [2,_altitude];

[{
	params ["_player","_entity","_request","_class","_posASL","_altitude","_radius","_ingress","_speed","_startPos","_endPos"];

	private _type = _request getOrDefault ["type","CIRCLE_L"];

	private _vehicle = createVehicle [_class,_startPos,[],0,"FLY"];
	_vehicle setDir (_ingress - 180);
	_vehicle setPos _startPos;
	_vehicle setVectorUp [0,0,1];
	_vehicle setVelocityModelSpace [0,_speed * 0.8,0];

	[_vehicle,_entity getVariable [QPVAR(pylons),[]]] call EFUNC(common,setPylons);

	// Some init scripts override loadouts.
	[EFUNC(common,setPylons),[_vehicle,_entity getVariable [QPVAR(pylons),[]]],3] call CBA_fnc_waitAndExecute;

	private _side = _entity getVariable [QPVAR(side),sideEmpty];
	private _group = _side createVehicleCrew _vehicle;
	_group deleteGroupWhenEmpty true;

	[
		[QEGVAR(common,disableUAVConnectability),_vehicle] call CBA_fnc_globalEventJIP,
		_vehicle
	] call CBA_fnc_removeGlobalEventJIP;

	_vehicle lockDriver true;
	_group allowFleeing 0;
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";

	{
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
		_x disableAI "AUTOCOMBAT";
	} forEach units _group;

	[_vehicle,_entity,false] call EFUNC(common,commission);

	if (_entity getVariable [QPVAR(infiniteAmmo),false]) then {
		_vehicle addEventHandler ["Fired",{(_this # 0) setVehicleAmmo 1}];
	};

	private _altitudeASL = _posASL # 2 + _altitude;
	_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];

	if (_type == "HOVER") then {
		private _wp1 = _group addWaypoint [_posASL getPos [_radius - 100,_ingress],0];
		_wp1 setWaypointType "MOVE";
		_wp1 setWaypointDescription QGVAR(loiterIngress);

		private _wp2 = _group addWaypoint [_posASL getPos [_radius - 200,_ingress],0];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointDescription QGVAR(loiter);
	} else {
		private _dirOffset = [10,-10] param [["CIRCLE","CIRCLE_L"] find _type,1];
		
		private _wp1 = _group addWaypoint [_posASL getPos [_radius + 500,_ingress + _dirOffset],0];
		_wp1 setWaypointType "MOVE";
		_wp1 setWaypointDescription QGVAR(loiterIngress);

		private _wp2 = _group addWaypoint [ASLToAGL _posASL,0];
		_wp2 setWaypointType "LOITER";
		_wp2 setWaypointLoiterType _type;
		_wp2 setWaypointLoiterRadius _radius;
		_wp2 setWaypointLoiterAltitude _altitude;
		_wp2 setWaypointSpeed (_request getOrDefault ["speedMode","NORMAL"]);
		_wp2 setWaypointDescription QGVAR(loiter);
	};

	_group setVariable [QGVAR(loiterVehicle),_vehicle,true];
	_group setVariable [QGVAR(loiterType),_type,true];
	_group addEventHandler ["WaypointComplete",{
		params ["_group","_waypointIndex"];

		private _vehicle = _group getVariable [QGVAR(loiterVehicle),objNull];

		if (!alive _vehicle) exitWith {};

		if (waypointDescription _this == QGVAR(loiterIngress)) then {
			if (_group getVariable [QGVAR(loiterType),""] == "HOVER") then {
				NOTIFY(_vehicle,LSTRING(notifyLoiterHover));
			} else {
				NOTIFY(_vehicle,LSTRING(notifyLoiter));
			};

			[_vehicle,true,"LOITER",[LSTRING(statusLoiter),RGBA_YELLOW]] call EFUNC(common,setStatus);
			_vehicle setVariable [QGVAR(loiterTargetTick),CBA_missionTime + 10,true];
		};

		if (waypointDescription _this == QGVAR(loiterEgress)) then {
			[{
				params ["_vehicle","_group"];
				deleteVehicleCrew _vehicle;
				deleteVehicle _vehicle;
				deleteGroup _group;
			},[_vehicle,_group],3] call CBA_fnc_waitAndExecute;
		};
	}];

	_vehicle setVariable [QGVAR(loiterData),[_player,_entity,_request,AGLtoASL _startPos,_endPos],true];
	_vehicle setVariable [QGVAR(loiterTargetTick),nil,true];

	// Loiter targeting
	if (isNil {_vehicle getVariable QGVAR(loiterTargetPFHID)}) then {
		private _PFHID = [FUNC(loiterTarget),1,[_vehicle,_entity]] call CBA_fnc_addPerFrameHandler;
		_vehicle setVariable [QGVAR(loiterTargetPFHID),_PFHID,true];
	};

	// Duration
	private _duration = _entity getVariable [QPVAR(duration),600];

	[{
		params ["_vehicle","_group","_entity","_endPos"];
		if (!alive _vehicle || _vehicle != (_entity getVariable [QPVAR(vehicle),objNull])) exitWith {};
		NOTIFY(_entity,LSTRING(notifyLoiterTimeoutWarning));
	},[_vehicle,_group,_entity,_endPos],_duration - 60] call CBA_fnc_waitAndExecute;

	[{
		params ["_vehicle","_group","_entity","_endPos"];

		if (!alive _vehicle || _vehicle != (_entity getVariable [QPVAR(vehicle),objNull])) exitWith {};

		NOTIFY(_entity,LSTRING(notifyLoiterTimeout));

		[_group,true] call EFUNC(common,clearWaypoints);

		private _wp1 = _group addWaypoint [_endPos,0];
		_wp1 setWaypointType "MOVE";
		_wp1 setWaypointDescription QGVAR(loiterEgress);
	},[_vehicle,_group,_entity,_endPos],_duration] call CBA_fnc_waitAndExecute;	
},[_player,_entity,_request,_class,_posASL,_altitude,_radius,_ingress,_speed,_startPos,_endPos],_delay] call CBA_fnc_waitAndExecute;
