#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};
private _object = attachedTo _logic;
deleteVehicle _logic;

["","","[]"] params ["_classname","_callsign","_weaponSet"];

if (alive _object || _object isKindOf "AllVehicles") then {
	_classname = typeOf _object;
	_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
	_weaponSet = format ["%1",(weapons _object) select {
		(toLower ((_x call BIS_fnc_itemType) # 1)) in ["machinegun","rocketlauncher","missilelauncher","bomblauncher"]
	}];
};

["CAS Plane Parameters",[
	["EDITBOX","Classname",_classname],
	["EDITBOX","Callsign",_callsign],
	["EDITBOX",["Weapon set","Array of weapon classnames or array of weapon:magazine arrays"],_weaponSet],
	["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
	["EDITBOX","Cooldown",str SSS_setting_CASPlanesCooldownDefault]
],{
	params ["_values"];
	_values params ["_classname","_callsign","_weaponSet","_sideSelection","_cooldown"];

	_weaponSet = parseSimpleArray _weaponSet;
	private _side = [west,east,independent] # _sideSelection;

	[_classname,_callsign,_weaponSet,_side,parseNumber _cooldown] call SSS_fnc_addCASPlane;

	ZEUS_MESSAGE("CAS plane added")
}] call SSS_CDS_fnc_dialog;

