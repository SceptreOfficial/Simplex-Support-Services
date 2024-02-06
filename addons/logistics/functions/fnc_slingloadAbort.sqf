#include "..\script_component.hpp"

params ["_player","_entity"];

private _vehicles = _entity getVariable [QPVAR(vehicles),[]];

if (_vehicles isEqualTo []) exitWith {
	if (GVAR(cooldownTrigger) == "END") then {
		[_entity,false] call EFUNC(common,cooldown);
	};
};

[_entity,true,"ABORT",[LSTRING(statusAirdropAbort),RGBA_YELLOW]] call EFUNC(common,setStatus);
NOTIFY(_entity,LSTRING(notifyAirdropAbort));

{
	private _vehicle = _x;

	_vehicle getVariable QGVAR(flybyData) params ["_player","_entity","_request","_startPosASL"];
	_vehicle setVariable [QGVAR(flybyData),nil,true];
	[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);
	_vehicle setVariable [QPVAR(fastropeCancel),true,true];

	private _group = group _vehicle;
	private _wpIndex = currentWaypoint _group;
	private _pos = ASLtoAGL _startPosASL;
	
	[_group,_wpIndex] setWaypointPosition [_pos,0];
	[_group,_wpIndex + 1] setWaypointPosition [_pos,0];

	_vehicle doMove _pos;
} forEach _vehicles;
