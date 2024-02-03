#include "..\script_component.hpp"
#define ORDER "HOLD"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

_vehicle setVariable [QGVAR(endHold),nil,true];
_vehicle setVariable [QGVAR(hold),nil,true];

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

	if (unitReady _vehicle && isNil {_vehicle getVariable QGVAR(hold)}) then {
		_vehicle setVariable [QGVAR(hold),LSTRING(stopHolding),true];
		NOTIFY(_entity,LSTRING(notifyHolding));
	};

	_vehicle getVariable [QGVAR(endHold),false]
};

_vehicle setVariable [QGVAR(endHold),nil,true];
_vehicle setVariable [QGVAR(hold),nil,true];

true
