#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};
private _object = attachedTo _logic;
deleteVehicle _logic;

if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

["Artillery Parameters",[
	["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
	["EDITBOX","Respawn time",str SSS_setting_respawnTimeDefault],
	["EDITBOX","Cooldown",str (SSS_setting_artilleryCooldownDefault # 0)],
	["EDITBOX","Extra cooldown time per round",str (SSS_setting_artilleryCooldownDefault # 1)]
],{
	params ["_values","_object"];
	_values params ["_callsign","_respawnTime","_masterCooldown","_roundCooldown"];

	[_object,_callsign,parseNumber _respawnTime,[parseNumber _masterCooldown,parseNumber _roundCooldown]] call SSS_fnc_addArtillery;

	ZEUS_MESSAGE("Artillery added")
},{},_object] call SSS_CDS_fnc_dialog;
