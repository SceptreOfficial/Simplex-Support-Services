#include "script_component.hpp"
#define ORDER "FIRE"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_weapon",[]],
	["_duration",10],
	["_burst",[3,2]],
	["_spread",0]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

private _target = [_attachedObject,ATLtoASL waypointPosition [_group,currentWaypoint _group]] select (isNull _attachedObject);

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_target]] call CBA_fnc_directCall;

[
	_vehicle,
	_target,
	_weapon,
	[_duration,true],
	0,
	_burst,
	_spread
] call EFUNC(common,fireAtTarget);

sleep 2;

waitUntil {
	sleep WAYPOINT_SLEEP;
	!(_vehicle getVariable [QEGVAR(common,firing),false])
};

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
