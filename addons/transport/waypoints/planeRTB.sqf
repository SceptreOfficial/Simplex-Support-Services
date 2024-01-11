#include "script_component.hpp"
#define ORDER "RTB"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER]] call CBA_fnc_directCall;

private _moveTick = 0;
private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];
private _posASL = _entity getVariable QPVAR(base);
private _posAGL = ASLToAGL _posASL;
(_entity getVariable [QPVAR(baseNormal),[[0,1,0],[0,0,1]]]) params ["_vDir","_vUp"];

if (_virtualRunway isNotEqualTo [0,0,0]) then {
	_posAGL = ASLToAGL _virtualRunway;
};

if (_vehicle distance2D _posASL > 30 && isTouchingGround _vehicle) then {
	[_entity,_vehicle] call EFUNC(common,planeTakeoff);
};

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;
		_vehicle doMove _posAGL;
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && unitReady _vehicle
};

if (_virtualRunway isEqualTo [0,0,0]) then {
	_vehicle action ["Land",_vehicle];

	waitUntil {
		sleep WAYPOINT_SLEEP;
		isTouchingGround _vehicle && speed _vehicle < 30
	};
} else {
	_vehicle action ["LandGear",_vehicle];

	if (isDamageAllowed _vehicle) then {
		_vehicle allowDamage false;
		[{_this allowDamage true},_vehicle,2] call CBA_fnc_waitAndExecute;
	};
};

if (alive _vehicle) then {
	DEBUG_1("""%1"" landed - moving to base",_entity getVariable QPVAR(callsign));

	[_vehicle,_posASL] call EFUNC(common,placementSearch) params ["_safePos","_safeUp"];

	if (!isNil "_safePos") then {
		_vehicle setPosASL _safePos;
		_vehicle setVectorDirAndUp [_vDir,_safeUp];
	} else {
		_vehicle setPosASL _posASL;
		_vehicle setVectorDirAndUp [_vDir,_vUp];
	};

	[{_this setVelocity [0,0,0]; false},{},_vehicle,2] call CBA_fnc_waitUntilAndExecute;

	[QEGVAR(common,setFuel),[_vehicle,0],_vehicle] call CBA_fnc_targetEvent;

	[_entity,_vehicle,GVAR(RTBReset),GVAR(RTBRestoreCrew)] call EFUNC(common,reset);
};

if (_timeout > 0) then {
	_vehicle call FUNC(landedStop);
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
