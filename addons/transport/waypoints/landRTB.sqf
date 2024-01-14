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
private _posASL = _entity getVariable QPVAR(base);
private _posAGL = ASLToAGL _posASL;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;
		_vehicle doMove _posAGL;
	};

	sleep WAYPOINT_SLEEP;

	unitReady _vehicle
};

if (getPosASL _vehicle distance _posASL < 20) then {
	[_entity,_vehicle,GVAR(RTBReset),GVAR(RTBRestoreCrew)] call EFUNC(common,reset);
};

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
