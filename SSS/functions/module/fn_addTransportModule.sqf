#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	private _object = attachedTo _logic;

	if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

	["Add Transport Heli",[
		["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
		["EDITBOX","Respawn time",SSS_DEFAULT_RESPAWN_TIME]
	],{
		params ["_values","_object"];
		_values params ["_callsign","_respawnTime"];

		[_object,_callsign,parseNumber _respawnTime] call SSS_fnc_addTransport;

		ZEUS_MESSAGE("Transport heli added")
	},{},_object] call SSS_CDS_fnc_dialog;
} else {
	if (_synced isEqualTo []) exitWith {};

	private _object = _synced # 0;
	if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

	[
		_object,
		_logic getVariable ["Callsign",""],
		parseNumber (_logic getVariable ["RespawnTime","60"])
	] call SSS_fnc_addTransport;
};

deleteVehicle _logic;
