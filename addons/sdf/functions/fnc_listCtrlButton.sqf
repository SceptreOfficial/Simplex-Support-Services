#include "script_component.hpp"

_valueData params [["_code",{},[{},""]]];

if (_code isEqualType "") then {
	_code = compile _code;
};

//if (!_forceDefault) then {
//	_code = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_code];
//};

private _ctrl = _display ctrlCreate [QGVAR(ButtonSimple),-1,_ctrlGroup];
_ctrl ctrlSetPosition [0,_posY];
_ctrl ctrlCommit 0;
_ctrl ctrlSetText _descriptionText;
_ctrl ctrlSetTooltip _descriptionTooltip;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_code]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_code];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrl];

_controls pushBack _ctrl;

[_ctrl,"ButtonClick",{
	params ["_ctrl"];
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments)] call CBA_fnc_directCall;
}] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_H + SPACING_H;
