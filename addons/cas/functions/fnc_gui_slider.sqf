#include "script_component.hpp"

params [
	"_ctrlSlider",
	"_ctrlEdit",
	"_options",
	"_valueKey",
	"_value",
	["_symbol",""],
	["_textHash",[]],
	["_onValueChanged",{
		params ["_ctrlSlider","_value"];
		GVAR(request) set [_ctrlSlider getVariable QGVAR(valueKey),_value];
		call FUNC(gui_verify);
	}]
];

_value = GVAR(request) getOrDefault [_valueKey,_value];

_ctrlSlider setVariable [QGVAR(valueKey),_valueKey];

[_ctrlSlider,_ctrlEdit,_options,_value,_onValueChanged,_symbol,_textHash] call EFUNC(sdf,manageSlider);
