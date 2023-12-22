#include "script_component.hpp"

params [["_vehicle",objNull,[objNull]]];

if (isNull _vehicle) exitWith {};

if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(decommission)],_vehicle] call CBA_fnc_targetEvent;
};

_vehicle setVariable [QPVAR(entity),nil,true];
_vehicle lockTurret [[0],false];
_vehicle lockCargo false;
_vehicle lockDriver false;

{
	_x enableAI "SUPPRESSION";
	_x enableAI "FSM";
	_x enableAI "COVER";
	_x enableAI "LIGHTS";
	_x enableAI "MOVE";
	_x enableAI "AUTOCOMBAT";
	_x enableAI "TARGET";
	_x enableAI "AUTOTARGET";
} forEach PRIMARY_CREW(_vehicle);

private _group = group _vehicle;
_group setCombatMode "YELLOW";
_group enableAttack true;

[QPVAR(vehicleDecommissioned),[_vehicle]] call CBA_fnc_globalEvent;
