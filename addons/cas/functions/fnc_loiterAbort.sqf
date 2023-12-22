#include "script_component.hpp"

params ["_player","_entity"];

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (isNull _vehicle) exitWith {
	//[_entity,false] call EFUNC(common,cooldown);
};

[_entity,true,"ABORT",[LSTRING(statusLoiterAbort),RGBA_YELLOW]] call EFUNC(common,setStatus);
NOTIFY(_entity,LSTRING(notifyLoiterAbort));

_vehicle getVariable [QGVAR(loiterData),[]] params ["_player","_entity","_request","_startPosASL","_endPos"];
_vehicle setVariable [QGVAR(loiterData),nil,true];

private _group = group _vehicle;

[_group,true] call EFUNC(common,clearWaypoints);

private _pos = if (_entity getVariable [QPVAR(task),""] == "LOITER") then {
	_endPos
} else {
	ASLToAGL _startPosASL
};

private _wp1 = _group addWaypoint [_pos,0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointDescription QGVAR(loiterEgress);

_vehicle flyInHeight (getPos _vehicle # 2);
