#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	private _object = attachedTo _logic;
	["","","[]"] params ["_classname","_callsign","_weaponSet"];

	if (alive _object || _object isKindOf "AllVehicles") then {
		_classname = typeOf _object;
		_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
		_weaponSet = format ["%1",(weapons _object) select {
			(toLower ((_x call BIS_fnc_itemType) # 1)) in ["machinegun","rocketlauncher","missilelauncher","bomblauncher"]
		}];
	};

	["Add CAS Plane",[
		["EDITBOX","Classname",_classname],
		["EDITBOX","Callsign",_callsign],
		["EDITBOX",["Weapon set","Array of weapon classnames or array of weapon:magazine arrays"],_weaponSet],
		["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
		["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_PLANES]
	],{
		params ["_values"];
		_values params ["_classname","_callsign","_weaponSet","_sideSelection","_cooldown"];

		[_classname,_callsign, parseSimpleArray _weaponSet,[west,east,independent] # _sideSelection,parseNumber _cooldown] call SSS_fnc_addCASPlane;

		ZEUS_MESSAGE("CAS plane added")
	}] call SSS_CDS_fnc_dialog;
} else {
	[
		_logic getVariable ["Classname",""],
		_logic getVariable ["Callsign",""],
		parseSimpleArray (_logic getVariable ["WeaponSet","[]"]),
		[west,east,independent] # (_logic getVariable ["Side",0]),
		parseNumber (_logic getVariable ["Cooldown","90"])
	] call SSS_fnc_addCASPlane;
};

deleteVehicle _logic;
