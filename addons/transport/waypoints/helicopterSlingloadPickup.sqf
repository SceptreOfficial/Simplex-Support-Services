#include "script_component.hpp"
#define ORDER "SLINGLOADPICKUP"

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

private _moveTick = 0;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;

		if (isTouchingGround _vehicle && _vehicle distance2D _wpPos < 200) then {
			_vehicle doMove (_vehicle getPos [200,getDir _vehicle]);
		} else {
			_vehicle doMove _wpPos;
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && unitReady _vehicle
};

if (driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

_vehicle setVariable [QGVAR(slingloadPos),waypointPosition [_group,currentWaypoint _group],true];
_vehicle setVariable [QGVAR(slingloadTarget),nil,true];

NOTIFY(_entity,LSTRING(notifySlingloadTarget));

waitUntil {
	sleep WAYPOINT_SLEEP;
	!isNil {_vehicle getVariable QGVAR(slingloadTarget)}
};

_vehicle setVariable [QGVAR(slingloadPos),nil,true];
private _object = _vehicle getVariable [QGVAR(slingloadTarget),objNull];

if (isNull _object) exitWith {
	NOTIFY(_entity,LSTRING(notifySlingloadCancelledNoObject));
	true
};

private _msg = {
	params ["_object"];
	format [LLSTRING(slingloading),getText (configOf _object >> "displayName")]
};

NOTIFY_1(_entity,_msg,_object);

[_vehicle,_object,GVAR(slingloadMassOverride)] call EFUNC(common,slingloadPickup);

waitUntil {
	sleep WAYPOINT_SLEEP;
	!isNull (_vehicle getVariable [QEGVAR(common,slingloadCargo),objNull]) ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
