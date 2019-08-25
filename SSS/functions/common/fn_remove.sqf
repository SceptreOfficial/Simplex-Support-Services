#include "script_component.hpp"

params [["_entity",objNull,[objNull]]];

if (isNull _entity) exitWith {};
if (!local _entity) exitWith {_entity remoteExecCall ["SSS_fnc_remove",_entity];};

private _service = _entity getVariable ["SSS_service",""];
if (_service isEqualTo "") exitWith {};
_entity setVariable ["SSS_service",nil,true];

[false,format ["SSS_%1_%2",_entity getVariable "SSS_service",_entity getVariable "SSS_side"],_entity] remoteExecCall ["SSS_fnc_editServiceArray",2];

private _base = _entity getVariable "SSS_base";

if (isNil "_base") then {
	// Virtual
	deleteVehicle _entity;
} else {
	// Physical
	if (_base isEqualType objNull) then {deleteVehicle _base;};
	[_entity getVariable "SSS_addedJIPID"] call CBA_fnc_removeGlobalEventJIP;
	deleteMarker (_entity getVariable "SSS_marker");

	["SSS_supportVehicleRemoved",_entity] call CBA_fnc_globalEvent;

	{
		_x enableAI "SUPPRESSION";
		_x enableAI "COVER";
		_x enableAI "AUTOCOMBAT";
		_x enableAI "MOVE";
	} forEach PRIMARY_CREW(_entity);
	group _entity enableAttack true;
	_entity lockTurret [[0],false];
	_entity lockCargo false;
	_entity lockDriver false;
};
