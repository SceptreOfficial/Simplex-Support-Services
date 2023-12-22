#include "script_component.hpp"

CREATE_DESCRIPTION;

_valueData params [["_labels",[],[[]]],["_strings",[],[[]]]];

if (!_forceDefault) then {
	_strings = GVAR(cache) getVariable [[_title,_description,_type,_labels] joinString "~",_strings];
};

private _count = count _labels;

if (_count > 4 || _count != count _strings) exitWith {
	systemChat "SDF ERROR: Array control count too high or mismatch";
};

private _labelWidth = CONTROL_W / _count / 3;
private _itemX = CONTROL_X;
private _parsed = [];
private _parent = controlNull;
private _labelCtrls = [];
private _stringCtrls = [];

{
	(_labels # _forEachIndex) params [["_text",""],["_tooltip","",[""]],["_RGBA",GVAR(profileRGBA),[[]],4]];

	private _label = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
	_label ctrlSetPosition [_itemX,_posY,_labelWidth,ITEM_H];
	_label ctrlSetBackgroundColor _RGBA;
	_label ctrlCommit 0;
	_label ctrlSetText _text;
	_label ctrlSetTooltip _tooltip;

	_labelCtrls pushBack _label;

	private _string = if (_x isEqualType "") then {
		_parsed pushBack parseNumber _x;
		_x
	} else {
		_parsed pushBack _x;
		str _x
	};

	private _ctrl = _display ctrlCreate [QGVAR(Editbox),-1,_ctrlGroup];
	_ctrl ctrlSetPosition [_itemX + _labelWidth,_posY,_labelWidth * 2,ITEM_H];
	_ctrl ctrlCommit 0;
	_ctrl ctrlSetText _string;

	if (_forEachIndex == 0) then {_parent = _ctrl};

	_itemX = _labelWidth * 3 + _itemX;

	[_ctrl,"KeyUp",{
		params ["_ctrl","_key"];

		private _parent = _thisArgs;
		private _stringCtrls = _parent getVariable QGVAR(stringCtrls);
		private _parsed = _stringCtrls apply {parseNumber ctrlText _x};
		
		_parent setVariable [QGVAR(value),_parsed];

		if (GVAR(skipOnValueChanged)) exitWith {};
			
		[_parsed,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
	},_parent] call CBA_fnc_addBISEventHandler;

	[_ctrl,"SetFocus",{
		params ["_ctrl"];
		uiNamespace setVariable [QGVAR(editFocus),_ctrl];
	}] call CBA_fnc_addBISEventHandler;

	_stringCtrls pushBack _ctrl;
} forEach _strings;

private _ctrl = _parent;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_labels,_strings]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_parsed];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
_ctrl setVariable [QGVAR(labelCtrls),_labelCtrls];
_ctrl setVariable [QGVAR(stringCtrls),_stringCtrls];

_controls pushBack _ctrl;

_posY = _posY + ITEM_H + SPACING_H;
