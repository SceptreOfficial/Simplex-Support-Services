#include "script_component.hpp"

params ["_player","_entity","_request"];

_entity getVariable QPVAR(guiLimits) params ["_altitudeMin","_altitudeMax","_radiusMin","_radiusMax"];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];
private _altitude = _request getOrDefault ["altitude",_altitudeMin max LOITER_ALTITUDE_DEFAULT min _altitudeMax];
private _radius = _request getOrDefault ["radius",_radiusMin max LOITER_RADIUS_DEFAULT min _radiusMax];
private _direction = _request getOrDefault ["direction","CIRCLE_L"];

[_entity,true,"LOITER",[LSTRING(statusLoiterIngress),RGBA_YELLOW]] call EFUNC(common,setStatus);

NOTIFY_1(_entity,LSTRING(notifyLoiterUpdate),_posASL call EFUNC(common,formatGrid));

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];
private _group = group _vehicle;
private _wp = [_group,currentWaypoint _group];

private _type = ["LOITER","MOVE"] select (_radius < 300);

if (waypointDescription _wp != QGVAR(loiter) || waypointType _wp != _type || waypointPosition _wp distance2D _posASL > 5) then {
	[_group,false] call EFUNC(common,clearWaypoints);

	_wp = _group addWaypoint [ASLToAGL _posASL,0];
	_wp setWaypointType _type;
	_wp setWaypointDescription QGVAR(loiter);
};

private _altitudeASL = _posASL # 2 + _altitude;
_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];

_vehicle setVariable [QGVAR(loiterTargetTick),CBA_missionTime + 8,true];

if (_type == "MOVE") exitWith {};

_wp setWaypointLoiterType _direction;
_wp setWaypointLoiterRadius _radius;
_wp setWaypointLoiterAltitude _altitude;
//_wp setWaypointSpeed "LIMITED";
