#include "..\script_component.hpp"
#define ORDER "SAD"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",30],
	["_radius",500]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

_vehicle doMove _wpPos;

waitUntil {
	if (unitReady _vehicle) then {
		_vehicle doMove _wpPos;
	};

	sleep WAYPOINT_SLEEP;

	unitReady _vehicle || _vehicle distance2D _wpPos < _radius + SAD_BUFFER
};

{_group reveal _x} forEach (_wpPos nearEntities _radius);

private _wp = _group addWaypoint [_wpPos,0,currentWaypoint _group + 1];
_wp setWaypointType "SAD";
_wp setWaypointDescription "SAD";

if (_timeout > 0) then {
	private _uid = GEN_STR(_wpPos);
	[_group,currentWaypoint _group] setWaypointDescription _uid;
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
	},[_group,_uid],_timeout] call CBA_fnc_waitAndExecute;
};

true
