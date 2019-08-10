#include "script_component.hpp"

params [["_entity",objNull,[objNull]]];

if (isNull _entity) exitWith {};

private _serviceString = format ["SSS_%1_%2",_entity getVariable "SSS_service",_entity getVariable "SSS_side"];
private _serviceArray = missionNamespace getVariable [_serviceString,[]];
_serviceArray deleteAt (_serviceArray find _entity);
missionNamespace setVariable [_serviceString,_serviceArray,true];

private _base = _entity getVariable "SSS_base";

if (isNil "_base") then {
	// Virtual
	deleteVehicle _entity;
} else {
	// Physical
	private _vehicle = _entity;

	if (_base isEqualType objNull) then {deleteVehicle _base;};
	[_vehicle getVariable "SSS_addedJIPID"] call CBA_fnc_removeGlobalEventJIP;
	deleteMarker (_vehicle getVariable "SSS_marker");

	{_vehicle setVariable [_x,nil,true]} forEach ((allVariables _vehicle) select {(_x select [0,4]) == "sss_"});

	["SSS_supportVehicleRemoved",_vehicle] call CBA_fnc_globalEvent;

	private _groupUnits = units group _vehicle;
	if (_groupUnits isEqualTo []) exitWith {};

	{
		_x enableAI "SUPPRESSION";
		_x enableAI "COVER";
		_x enableAI "AUTOCOMBAT";
		_x enableAI "MOVE";
	} forEach _groupUnits;
	group _vehicle enableAttack true;
	_vehicle lockTurret [[0],false];
	_vehicle lockCargo false;
	_vehicle lockDriver false;
};
