#include "..\script_component.hpp"
#define ORDER "LAND"

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

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

if (isTouchingGround _vehicle) then {
	[_entity,_vehicle] call EFUNC(common,planeTakeoff);
};

_vehicle doMove _wpPos;

waitUntil {
	if (unitReady _vehicle) then {
		_vehicle doMove _wpPos;
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && unitReady _vehicle && _vehicle distance2D _wpPos < 200
};

_vehicle action ["Land",_vehicle];

waitUntil {
	sleep WAYPOINT_SLEEP;
	isTouchingGround _vehicle && speed _vehicle < 30
};

if (_timeout > 0) then {
	_vehicle call FUNC(landedStop);
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
