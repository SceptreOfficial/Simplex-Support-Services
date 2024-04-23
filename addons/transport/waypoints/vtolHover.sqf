#include "..\script_component.hpp"
#define ORDER "HOVER"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",30],
	["_hoverHeight",15],
	["_endDir",-1],
	["_approach",150]
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

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < VTOL_PILOT_DISTANCE
};

[
	_vehicle,
	[_vehicle,ATLtoASL waypointPosition [_group,currentWaypoint _group],"HOVER",_hoverHeight] call EFUNC(common,surfacePosASL),
	[_endDir],
	nil,
	_approach,
	nil,
	EFUNC(common,pilotHelicopterHover)
] call EFUNC(common,pilotHelicopter);

waitUntil {
	sleep WAYPOINT_SLEEP;
	_vehicle getVariable [QEGVAR(common,pilotHelicopterReached),false] ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
