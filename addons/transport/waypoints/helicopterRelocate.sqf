#include "script_component.hpp"
#define ORDER "RELOCATE"

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

if !((_entity getVariable [QPVAR(relocation),[false,60]]) # 0) exitWith {true};

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

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < HELO_PILOT_DISTANCE
};

if (driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

[
	_vehicle,
	[_vehicle,ATLtoASL waypointPosition [_group,currentWaypoint _group]] call EFUNC(common,surfacePosASL),
	[],
	(getPos _vehicle # 2) max 50,
	50,
	nil,
	[EFUNC(common,pilotHelicopterLand),[60,false]]
] call EFUNC(common,pilotHelicopter);

waitUntil {
	sleep WAYPOINT_SLEEP;
	isTouchingGround _vehicle ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

// Begin relocation
private _relocationTick = (_entity getVariable [QPVAR(relocation),[false,60]]) # 1 + CBA_missionTime;

waitUntil {
	sleep WAYPOINT_SLEEP;
	!alive _vehicle || !isTouchingGround _vehicle || CBA_missionTime >= _relocationTick
};

if (!alive _vehicle || !isTouchingGround _vehicle || !((_entity getVariable [QPVAR(relocation),[false,60]]) # 0)) exitWith {
	NOTIFY(_entity,LSTRING(notifyRelocateFailed));
	true
};

_entity setVariable [QPVAR(base),getPosASL _vehicle,true];
_entity setVariable [QPVAR(baseNormal),[vectorDir _vehicle,vectorUp _vehicle],true];
NOTIFY(_entity,LSTRING(notifyRelocateComplete));

if (_timeout > 0) then {
	_vehicle call FUNC(landedStop);
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
