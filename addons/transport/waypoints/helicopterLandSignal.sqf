#include "script_component.hpp"
#define ORDER "LANDSIGNAL"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_engine",true],
	["_signalType","ANY"],
	["_searchRadius",350],
	["_searchTimeout",300]
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

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < _searchRadius + 400
};

if (driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

private _wp = _group addWaypoint [_wpPos,0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType selectRandom ["CIRCLE","CIRCLE_L"];
_wp setWaypointLoiterRadius _searchRadius;
_wp setWaypointDescription "LOITER";

private _uid = GEN_STR(_wpPos);
[_group,currentWaypoint _group] setWaypointDescription _uid;
_wp setWaypointDescription _uid;

NOTIFY(_entity,LSTRING(notifyLandSignalConfirm));

[_entity,_vehicle,_group,_uid,format ["%1 %2",QPATHTOF(waypoints\helicopterLand.sqf),[_behaviors,_timeout,_engine]],_signalType,_searchRadius,_searchTimeout] call FUNC(landSignal);

true
