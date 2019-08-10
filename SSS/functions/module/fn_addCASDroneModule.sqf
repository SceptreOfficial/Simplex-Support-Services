#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};
private _object = attachedTo _logic;
deleteVehicle _logic;

["",""] params ["_classname","_callsign"];

if (alive _object || _object isKindOf "AllVehicles") then {
	_classname = typeOf _object;
	_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
};

["CAS Plane Parameters",[
	["EDITBOX","Classname",_classname],
	["EDITBOX","Callsign",_callsign],
	["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
	["EDITBOX","Cooldown",str SSS_setting_CASDronesCooldownDefault],
	["EDITBOX","Loiter time",str SSS_setting_CASDronesLoiterTime]
],{
	params ["_values"];
	_values params ["_classname","_callsign","_sideSelection","_cooldown","_loiterTime"];

	private _side = [west,east,independent] # _sideSelection;

	[_classname,_callsign,_side,parseNumber _cooldown,parseNumber _loiterTime] call SSS_fnc_addCASDrone;

	ZEUS_MESSAGE("CAS drone added")
}] call SSS_CDS_fnc_dialog;

