#include "..\script_component.hpp"
#define ORDER "MOVE"

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

_vehicle doMove _wpPos;

waitUntil {
	if (unitReady _vehicle) then {
		if (isTouchingGround _vehicle && {_vehicle distance2D _wpPos < 200}) then {
			_vehicle doMove (_vehicle getPos [200,_vehicle getDir _wpPos]);
		} else {
			_vehicle doMove _wpPos;
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && unitReady _vehicle && _vehicle distance2D _wpPos < 200
};

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
