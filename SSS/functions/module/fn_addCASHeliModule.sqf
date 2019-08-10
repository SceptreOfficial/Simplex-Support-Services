#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};
private _object = attachedTo _logic;
deleteVehicle _logic;

if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

["CAS Helicopter Parameters",[
	["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
	["EDITBOX","Respawn Time",str SSS_setting_respawnTimeDefault]
],{
	params ["_values","_object"];
	_values params ["_callsign","_respawnTime"];

	[_object,_callsign,parseNumber _respawnTime] call SSS_fnc_addCASHeli;

	ZEUS_MESSAGE("CAS helicopter added")
},{},_object] call SSS_CDS_fnc_dialog;

