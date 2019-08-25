#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	private _object = attachedTo _logic;

	if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

	["Add Artillery",[
		["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
		["EDITBOX","Respawn time",SSS_DEFAULT_RESPAWN_TIME],
		["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN],
		["EDITBOX","Extra cooldown time per round",SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND]
	],{
		params ["_values","_object"];
		_values params ["_callsign","_respawnTime","_cooldown","_roundCooldown"];

		[_object,_callsign,parseNumber _respawnTime,[parseNumber _cooldown,parseNumber _roundCooldown]] call SSS_fnc_addArtillery;

		ZEUS_MESSAGE("Artillery added")
	},{},_object] call SSS_CDS_fnc_dialog;
} else {
	if (_synced isEqualTo []) exitWith {};

	private _object = _synced # 0;
	if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

	[
		_object,
		_logic getVariable ["Callsign",""],
		parseNumber (_logic getVariable ["RespawnTime","60"]),
		[parseNumber (_logic getVariable ["Cooldown","90"]),parseNumber (_logic getVariable ["RoundCooldown","8"])]
	] call SSS_fnc_addArtillery;
};

deleteVehicle _logic;
