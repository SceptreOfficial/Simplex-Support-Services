#include "..\script_component.hpp"

params ["_player","_entity"];

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (isNull _vehicle) exitWith {
	//[_entity,false] call EFUNC(common,cooldown);
};

//[_entity,true,"ABORT",[LSTRING(statusStrafeAbort),RGBA_YELLOW]] call EFUNC(common,setStatus);
//NOTIFY(_entity,LSTRING(notifyStrafeAbort));

_vehicle getVariable [QGVAR(strafeData),[]] params ["_player","_entity","_request","_startPosASL","_endPos"];
_vehicle setVariable [QGVAR(strafeData),nil,true];

[_vehicle,objNull] call EFUNC(common,strafe);

private _group = group _vehicle;

[_group,true] call EFUNC(common,clearWaypoints);

private _pos = if (_entity getVariable [QPVAR(task),""] == "STRAFE") then {
	_endPos
} else {
	ASLToAGL _startPosASL
};

private _wp1 = _group addWaypoint [_pos,0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointDescription QGVAR(strafeEgress);
