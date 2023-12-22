#include "script_component.hpp"

_valueData params [["_description1","",["",[]]],["_code1",{},[{},""]],["_description2","",["",[]]],["_code2",{},[{},""]]];

_description1 params [["_descriptionText1","",[""]],["_descriptionTooltip1","",[""]]];
_description1 = [_descriptionText1,_descriptionTooltip1];

_description2 params [["_descriptionText2","",[""]],["_descriptionTooltip2","",[""]]];
_description2 = [_descriptionText2,_descriptionTooltip2];

if (_code1 isEqualType "") then {
	_code1 = compile _code1;
};

if (_code2 isEqualType "") then {
	_code2 = compile _code2;
};

//if (!_forceDefault) then {
//	_code = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_code];
//};

private _ctrl = _display ctrlCreate [QGVAR(ButtonSimple),-1,_ctrlGroup];
_ctrl ctrlSetPosition [0,_posY,BUTTON2_W,BUTTON_H];
_ctrl ctrlCommit 0;
_ctrl ctrlSetText _descriptionText1;
_ctrl ctrlSetTooltip _descriptionTooltip1;

private _ctrl2 = _display ctrlCreate [QGVAR(ButtonSimple),-1,_ctrlGroup];
_ctrl2 ctrlSetPosition [BUTTON2_W + (SPACING_W / 2),_posY,BUTTON2_W,BUTTON_H];
_ctrl2 ctrlCommit 0;
_ctrl2 ctrlSetText _descriptionText2;
_ctrl2 ctrlSetTooltip _descriptionTooltip2;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_code1];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrl];

_ctrl setVariable [QGVAR(button2),_ctrl2];
_ctrl2 setVariable [QGVAR(parent),_ctrl];
_ctrl2 setVariable [QGVAR(value),_code2];

_controls pushBack _ctrl;

[_ctrl,"ButtonClick",{
	params ["_ctrl"];
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments)] call CBA_fnc_directCall;
}] call CBA_fnc_addBISEventHandler;

[_ctrl2,"ButtonClick",{
	params ["_ctrl"];
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments)] call CBA_fnc_directCall;
}] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_H + SPACING_H;
