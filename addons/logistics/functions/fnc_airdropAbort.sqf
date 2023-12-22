#include "script_component.hpp"

params ["_player","_entity"];

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (isNull _vehicle) exitWith {
	if (GVAR(cooldownTrigger) == "END") then {
		[_entity,false] call EFUNC(common,cooldown);
	};
};

[_entity,true,"ABORT",[LSTRING(statusAirdropAbort),RGBA_YELLOW]] call EFUNC(common,setStatus);
NOTIFY(_entity,LSTRING(notifyAirdropAbort));

_vehicle getVariable QGVAR(flybyData) params ["_player","_entity","_request","_startPosASL"];
_vehicle setVariable [QGVAR(flybyData),nil,true];

private _group = group _vehicle;
private _wpIndex = currentWaypoint _group;
private _pos = ASLtoAGL _startPosASL;

[_group,_wpIndex] setWaypointPosition [_pos,0];
[_group,_wpIndex + 1] setWaypointPosition [_pos,0];

_vehicle doMove _pos;
