#include "script_component.hpp"
#define ORDER "FASTROPE"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_hoverHeight",15],
	["_endDir",-1],
	["_approach",150],
	["_ejectTypes",[true,true]],
	["_ejectionsID",""]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

private _moveTick = 0;
private _liftoff = false;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 10;

		if (isTouchingGround _vehicle) then {
			if (_liftoff) exitWith {};
			_liftoff = true;
			_vehicle doMove (_vehicle getRelPos [200,0]);
		} else {
			_vehicle doMove _wpPos;
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < VTOL_PILOT_DISTANCE
};

_ejectTypes params [["_allPlayers",true,[true]],["_allAI",true,[true]]];

private _ejections = _group getVariable [_ejectionsID,[]];
_ejections append (SECONDARY_CREW(_vehicle) select {(_allPlayers && isPlayer _x) || (_allAI && !isPlayer _x)});

if (_ejections isEqualTo []) exitWith {
	_group setVariable [_ejectionsID,nil,true];
	true
};

[
	_vehicle,
	[_vehicle,ATLtoASL waypointPosition [_group,currentWaypoint _group],"FASTROPE",_hoverHeight] call EFUNC(common,surfacePosASL),
	[_endDir],
	(getPos _vehicle # 2) max 150,
	_approach,
	nil,
	[EFUNC(common,pilotHelicopterHover),[true,_ejections]]
] call EFUNC(common,pilotHelicopter);

_vehicle setVariable [QPVAR(fastropeDone),false,true];

waitUntil {
	sleep WAYPOINT_SLEEP;
	_vehicle getVariable [QPVAR(fastropeDone),false] ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

_group setVariable [_ejectionsID,nil,true];

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
