#include "script_component.hpp"
#define ORDER "LAND"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_engine",true],
	["_endDir",-1],
	["_approach",150]
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

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < HELO_PILOT_DISTANCE
};

if (driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

[
	_vehicle,
	[_vehicle,ATLtoASL waypointPosition [_group,currentWaypoint _group],"LAND"] call EFUNC(common,surfacePosASL),
	[_endDir],
	(getPos _vehicle # 2) max 50,
	_approach,
	nil,
	[EFUNC(common,pilotHelicopterLand),[[60,-1] select _engine,_engine]]
] call EFUNC(common,pilotHelicopter);

waitUntil {
	sleep WAYPOINT_SLEEP;
	isTouchingGround _vehicle ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

if (_timeout > 0) then {
	_vehicle call FUNC(landedStop);
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
