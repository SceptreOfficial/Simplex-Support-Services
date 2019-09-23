#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Gets or sets a cached value.

Parameters:
-

Returns:
Cached value or nothing
//-----------------------------------------------------------------------------------------------*/
disableSerialization;
params ["_type","_description","_values","_setCachedValue"];

private _titleText = uiNamespace getVariable QGVAR(titleText);

if (isNil QGVAR(valueCache)) then {
	GVAR(valueCache) = [] call CBA_fnc_createNamespace;
};

private _ID = switch (_type) do {
	case "SLIDER";
	case "COMBOBOX" : {str [_titleText,_description,_type,_values # 0]};
	default {str [_titleText,_description,_type]};
};

if (!_setCachedValue) exitWith {GVAR(valueCache) getVariable [_ID,_values]};

GVAR(valueCache) setVariable [_ID,_values];
