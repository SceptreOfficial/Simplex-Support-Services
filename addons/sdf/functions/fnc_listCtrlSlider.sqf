#include "script_component.hpp"

_valueData params [["_sliderData",[0,1,1],[[]]],["_sliderPos",0,[0]]];
_sliderData params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];

CREATE_DESCRIPTION;

if (!_forceDefault) then {
	_sliderPos = GVAR(cache) getVariable [[_title,_description,_type,_sliderData] joinString "~",_sliderPos];
};

private _sliderPosStr = _sliderPos toFixed _decimals;
private _ctrl = _display ctrlCreate [QGVAR(Slider),-1,_ctrlGroup];
_ctrl ctrlSetPosition [CONTROL_X,_posY];
_ctrl ctrlCommit 0;
_ctrl sliderSetRange [_min,_max];
_ctrl sliderSetPosition parseNumber _sliderPosStr;

private _ctrlEdit = _display ctrlCreate [QGVAR(SliderEdit),-1,_ctrlGroup];
_ctrlEdit ctrlSetPosition [CONTROL_X + SLIDER_W + SPACING_W,_posY];
_ctrlEdit ctrlCommit 0;
_ctrlEdit ctrlSetText _sliderPosStr;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[[_min,_max,_decimals],_sliderPos]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),sliderPosition _ctrl];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];

_ctrl setVariable [QGVAR(ctrlEdit),_ctrlEdit];
_ctrlEdit setVariable [QGVAR(slider),_ctrl];

_controls pushBack _ctrl;

[_ctrl,"SliderPosChanged",{
	params ["_ctrl","_sliderPos"];

	((_ctrl getVariable QGVAR(parameters)) # 2 # 0) params ["_min","_max","_decimals"];

	private _sliderPosStr = _sliderPos toFixed _decimals;
	_sliderPos = parseNumber _sliderPosStr;

	private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
	_ctrlEdit ctrlSetText _sliderPosStr;

	_ctrl setVariable [QGVAR(value),_sliderPos];

	if (GVAR(skipOnValueChanged)) exitWith {};

	[_sliderPos,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

[_ctrlEdit,"KeyUp",{
	params ["_ctrlEdit"];

	private _ctrl = _ctrlEdit getVariable QGVAR(slider);

	((_ctrl getVariable QGVAR(parameters)) # 2 # 0) params ["_min","_max","_decimals"];

	private _value = parseNumber ctrlText _ctrlEdit;
	_ctrl sliderSetPosition _value;
	_value = sliderPosition _ctrl;

	_ctrl setVariable [QGVAR(value),_value];

	if (GVAR(skipOnValueChanged)) exitWith {};
		
	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

[_ctrlEdit,"KillFocus",{
	params ["_ctrlEdit"];

	private _ctrl = _ctrlEdit getVariable QGVAR(slider);

	((_ctrl getVariable QGVAR(parameters)) # 2 # 0) params ["_min","_max","_decimals"];

	_ctrlEdit ctrlSetText (sliderPosition _ctrl toFixed _decimals);
}] call CBA_fnc_addBISEventHandler;

[_ctrlEdit,"SetFocus",{
	params ["_ctrl"];
	uiNamespace setVariable [QGVAR(editFocus),_ctrl];
}] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_H + SPACING_H;

