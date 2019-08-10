#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Returns ammo usage flags from an ammo (or supplied magazine) type.
NOTE: Relies on aiAmmoUsageFlags, can be unreliable

Parameters:
0: Ammo or magazine classname <STRING>

(https://community.bistudio.com/wiki/CfgAmmo_Config_Reference#aiAmmoUsageFlags):
Value 	| Type 				| Description
--------|-------------------|-------------------------------
0 		| None 				| ???
1 		| Light 			| used for illumination
2 		| Marking 			| ???
4 		| Concealment 		| used for smokes
8 		| CounterMeasures 	| ???
16 		| Mine 				| ???
32 		| Underwater 		| used in underwater environment
64 		| OffensiveInf 		| against infantry
128 	| OffensiveVeh 		| against vehicles
256 	| OffensiveAir 		| against air
512 	| OffensiveArmour 	| against armored vehicles

Returns:
Array of usage flags as strings
//-----------------------------------------------------------------------------------------------*/
params [["_class","",[""]]];

private _allUsageFlags = ["0","1","2","4","8","16","32","64","128","256","512"];
private _usageFlags = [];
private _cfgAmmoClass = switch true do {
	case (isClass (configFile >> "CfgAmmo" >> _class)) : {configFile >> "CfgAmmo" >> _class};
	case (isClass (configFile >> "CfgMagazines" >> _class)) : {
		private _ammo = getText (configFile >> "CfgMagazines" >> _class >> "ammo");
		configFile >> "CfgAmmo" >> _ammo
	};
	default {nil};
};
if (isNil "_cfgAmmoClass") exitWith {[]};

private _flags = _cfgAmmoClass >> "aiAmmoUsageFlags";
if (!isNull _flags) then {
	private _values = switch true do {
		case (isText _flags) : {(getText _flags) splitString "+ "};
		case (isNumber _flags) : {(str (getNumber _flags)) splitString "+ "};
		default {[]};
	};

	if !(_values isEqualTo []) then {
		_usageFlags = _values;
	};
};

if (_usageFlags isEqualTo []) then {
	private _submunitionAmmo = _cfgAmmoClass >> "submunitionAmmo";
	if (!isNull _submunitionAmmo && {isText _submunitionAmmo}) then {
		private _subAmmoClass = getText _submunitionAmmo;
		if !(_subAmmoClass isEqualTo "") then {
			private _flags = (configFile >> "CfgAmmo" >> _subAmmoClass >> "aiAmmoUsageFlags");
			if (!isNull _flags) then {
				private _values = switch true do {
					case (isText _flags) : {(getText _flags) splitString "+ "};
					case (isNumber _flags) : {(str (getNumber _flags)) splitString "+ "};
					default {[]};
				};

				if !(_values isEqualTo []) then {
					_usageFlags = _values;
				};
			};
		};
	};
};

_usageFlags
