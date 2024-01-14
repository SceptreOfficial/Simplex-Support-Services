#include "script_component.hpp"
#define ORDER "STRAFE"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_pylonConfig",[]],
	["_spread",0],
	["_search",""],
	["_aimRange",-1]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

private _moveTick = 0;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 30;

		if (isTouchingGround _vehicle) then {
			_vehicle doMove (_vehicle getRelPos [200,0]);
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle
};

[
	_vehicle,
	[_attachedObject,ATLtoASL waypointPosition [_group,currentWaypoint _group]] select (isNull _attachedObject),
	_pylonConfig,
	_entity getVariable [QPVAR(infiniteStrafeAmmo),false],
	_spread,
	-1,
	_search,
	800 max (_entity getVariable [QPVAR(altitudeATL),500]),
	_aimRange
] call EFUNC(common,strafe);

waitUntil {
	sleep 1;
	!(_vehicle getVariable [QEGVAR(common,strafe),false])
};

_vehicle doMove (_vehicle getPos [600,getDir _vehicle]);

sleep 6;

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
