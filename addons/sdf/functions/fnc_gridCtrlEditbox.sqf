#include "script_component.hpp"

params [["_multiline",false,[false]]];
_valueData params [["_string",""],["_tooltip","",[""]]];

if !(_string isEqualType "") then {
	_string = str _string;
};

if (!_forceDefault) then {
	_string = GVAR(cache) getVariable [["",_description,_type] joinString "~",_string];
};

private _ctrl = if (_multiline) then {
	_display ctrlCreate [QGVAR(EditboxMulti),-1,_ctrlGroup];
} else {
	_display ctrlCreate [QGVAR(Editbox),-1,_ctrlGroup];
};

_ctrl ctrlSetPosition _position;
_ctrl ctrlSetText _string;
_ctrl ctrlSetTooltip _tooltip;
_ctrl ctrlCommit 0;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_string]];
_ctrl setVariable [QGVAR(position),_position];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_string];

_controls pushBack _ctrl;

[_ctrl,"KeyUp",{
	params ["_ctrl","_key"];

	private _string = ctrlText _ctrl;
	
	_ctrl setVariable [QGVAR(value),_string];

	if (GVAR(skipOnValueChanged)) exitWith {};
		
	[_string,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"SetFocus",{
	params ["_ctrl"];
	uiNamespace setVariable [QGVAR(editFocus),_ctrl];
}] call CBA_fnc_addBISEventHandler;
