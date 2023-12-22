#include "script_component.hpp"

_valueData params [["_string",""]];

if !(_string isEqualType "") then {
	_string = str _string;
};

CREATE_DESCRIPTION;

if (!_forceDefault) then {
	_string = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_string];
};

private _ctrl = _display ctrlCreate [QGVAR(Editbox),-1,_ctrlGroup];
_ctrl ctrlSetPosition [CONTROL_X,_posY];
_ctrl ctrlCommit 0;
_ctrl ctrlSetText _string;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_string]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_string];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];

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

_posY = _posY + ITEM_H + SPACING_H;
