#include "script_component.hpp"

params [["_vehicle",objNull,[objNull]]];

if (isNull _vehicle) exitWith {};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(decommission),_vehicle];
};

_vehicle setVariable ["SSS_parentEntity",objNull,true];
_vehicle lockTurret [[0],false];
_vehicle lockCargo false;
_vehicle lockDriver false;

{
	_x enableAI "SUPPRESSION";
	_x enableAI "COVER";
	_x enableAI "AUTOCOMBAT";
	_x enableAI "MOVE";
	_x enableAI "LIGHTS";
} forEach PRIMARY_CREW(_vehicle);

private _group = group _vehicle;
_group setCombatMode "YELLOW";
_group enableAttack true;

[_vehicle,1,["ACE_SelfActions","SSS_transport"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",0];
[_vehicle,0,["ACE_MainActions","SSS_transport"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",0];
