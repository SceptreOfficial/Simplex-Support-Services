#include "script_component.hpp"
#define ORDER "LOITER"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",30],
	["_loiterType","CIRCLE"],
	["_loiterRadius",350]
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

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < _loiterRadius + 300
};

private _wp = _group addWaypoint [_wpPos,0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType _loiterType;
_wp setWaypointLoiterRadius _loiterRadius;
_wp setWaypointLoiterAltitude (_entity getVariable [QPVAR(altitudeASL),100]);
_wp setWaypointDescription "LOITER";

_entity call FUNC(addPostponedTasks);

if (_timeout > 0) then {
	private _msg = {format [LLSTRING(notifyLoiterTime),_this call EFUNC(common,properTime)]};
	NOTIFY_1(_entity,_msg,_timeout);

	private _uid = GEN_STR(_wpPos);
	_wp setWaypointDescription _uid;

	[{
		params ["_group","_uid"];
		
		if (_uid != waypointDescription [_group,currentWaypoint _group]) exitWith {
			DEBUG_2("WP UID Mismatch: %1: %2",_group,ORDER);
		};

		if (currentWaypoint _group >= count waypoints _group - 1) then {
			[_group,true] call EFUNC(common,clearWaypoints);
		} else {
			_group setCurrentWaypoint [_group,currentWaypoint _group + 1];
		};
	},[_group,_uid],_timeout + 5] call CBA_fnc_waitAndExecute;
} else {
	NOTIFY(_entity,LSTRING(notifyLoiterIndefinite));
};

true
