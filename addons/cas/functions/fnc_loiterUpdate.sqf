#include "script_component.hpp"

params ["_player","_entity","_request"];

_entity getVariable QPVAR(guiLimits) params ["_altitudeMin","_altitudeMax","_radiusMin","_radiusMax"];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];
private _altitude = _request getOrDefault ["altitude",_altitudeMin max LOITER_ALTITUDE_DEFAULT min _altitudeMax];
private _radius = _request getOrDefault ["radius",_radiusMin max LOITER_RADIUS_DEFAULT min _radiusMax];
private _type = _request getOrDefault ["type","CIRCLE_L"];

//[_entity,true,"LOITER",[LSTRING(statusLoiter),RGBA_YELLOW]] call EFUNC(common,setStatus);
NOTIFY_1(_entity,LSTRING(notifyLoiterUpdate),_posASL call EFUNC(common,formatGrid));

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];
private _group = group _vehicle;

[_group,false] call EFUNC(common,clearWaypoints);

private _altitudeASL = _posASL # 2 + _altitude;
_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];

if (_type == "HOVER") then {
	private _wp = [_group,currentWaypoint _group];
	private _ingress = _posASL getDir _vehicle;

	if (_vehicle distance2D (_posASL getPos [_radius,_ingress]) < 300 && 
		{_vehicle getRelDir _posASL < 45 || _vehicle getRelDir _posASL > 315}
	) exitWith {};

	private _wp1 = _group addWaypoint [_posASL getPos [_radius + 1200,_ingress],0];
	_wp1 setWaypointType "MOVE";

	private _wp2 = _group addWaypoint [_posASL getPos [_radius - 200,_ingress],0];
	_wp2 setWaypointType "MOVE";
	_wp2 setWaypointDescription QGVAR(loiter);
} else {
	private _wp = _group addWaypoint [ASLToAGL _posASL,0];
	_wp setWaypointType "LOITER";
	_wp setWaypointDescription QGVAR(loiter);
	_wp setWaypointLoiterType _type;
	_wp setWaypointLoiterRadius _radius;
	_wp setWaypointLoiterAltitude _altitude;
	_wp setWaypointSpeed (_request getOrDefault ["speedMode","NORMAL"]);
};

_vehicle setVariable [QGVAR(loiterTargetTick),CBA_missionTime + 8,true];
