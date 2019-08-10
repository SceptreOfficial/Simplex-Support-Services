#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};
deleteVehicle _logic;

["CAS Gunship Parameters",[
	["EDITBOX","Callsign","Blackfish"],
	["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
	["EDITBOX","Cooldown",str SSS_setting_CASGunshipsCooldownDefault],
	["EDITBOX","Loiter time",str SSS_setting_CASGunshipsLoiterTime]
],{
	params ["_values"];
	_values params ["_callsign","_sideSelection","_cooldown","_loiterTime"];

	private _side = [west,east,independent] # _sideSelection;

	[_callsign,_side,parseNumber _cooldown,parseNumber _loiterTime] call SSS_fnc_addCASGunship;

	ZEUS_MESSAGE("CAS gunship added")
}] call SSS_CDS_fnc_dialog;
