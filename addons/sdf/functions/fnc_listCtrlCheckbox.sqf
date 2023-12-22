#include "script_component.hpp"

_valueData params [["_bool",true,[true]]];

CREATE_DESCRIPTION;

if (!_forceDefault) then {
	_bool = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_bool];
};

private _ctrl = _display ctrlCreate [QGVAR(Checkbox),-1,_ctrlGroup];
_ctrl ctrlSetPosition [CONTROL_X + SPACING_W,_posY];
_ctrl ctrlCommit 0;
_ctrl cbSetChecked _bool;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_bool]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_bool];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];

_controls pushBack _ctrl;

[_ctrl,"CheckedChanged",{
	params ["_ctrl","_bool"];
	
	_bool = _bool isEqualTo 1;

	_ctrl setVariable [QGVAR(value),_bool];

	if (GVAR(skipOnValueChanged)) exitWith {};
		
	[_bool,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_H + SPACING_H;
