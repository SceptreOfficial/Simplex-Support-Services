/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Gets or sets a cached value.

Parameters:
-

Returns:
Cached value or nothing
//-----------------------------------------------------------------------------------------------*/
#include "..\defines.hpp"

disableSerialization;
params ["_type","_description","_values","_setCachedValue"];

private _titleText = uiNamespace getVariable "SSS_CDS_titleText";

if (isNil "SSS_CDS_valueCache") then {
	SSS_CDS_valueCache = [] call CBA_fnc_createNamespace;
};

private _ID = switch (_type) do {
	case "SLIDER";
	case "COMBOBOX" : {str [_titleText,_description,_type,_values # 0]};
	default {str [_titleText,_description,_type,_values]};
};

if (!_setCachedValue) exitWith {SSS_CDS_valueCache getVariable [_ID,_values]};

SSS_CDS_valueCache setVariable [_ID,_values];
