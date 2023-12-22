#include "script_component.hpp"

_valueData params [["_items",[],[[]]],["_selection",0,[0]],["_returnData",[],[[]]],["_size",[0,0],[[]],2]];

CREATE_DESCRIPTION;

if (!_forceDefault) then {
	_selection = GVAR(cache) getVariable [[_title,_description,_type,_items] joinString "~",_selection];
};

if (_returnData isNotEqualTo [] && count _items isNotEqualTo count _returnData) exitWith {
	systemChat "SDF ERROR: Toolbox item count != return data count";
};

private _columns = count _items max 1;
private _rows = 1;

if (_size isNotEqualTo [0,0]) then {
	_rows = round ((_size # 0) max 1);
	_columns = round ((_size # 1) max 1);
};

parsingNamespace setVariable [QGVAR(toolboxRows),_rows];
parsingNamespace setVariable [QGVAR(toolboxColumns),_columns];
parsingNamespace setVariable [QGVAR(toolboxSelectedBG_R),GVAR(profileRGBA) # 0];
parsingNamespace setVariable [QGVAR(toolboxSelectedBG_G),GVAR(profileRGBA) # 1];
parsingNamespace setVariable [QGVAR(toolboxSelectedBG_B),GVAR(profileRGBA) # 2];

private _height = ITEM_H * _rows;
private _ctrl = _display ctrlCreate [QGVAR(Toolbox),-1,_ctrlGroup];
_ctrl ctrlSetPosition [CONTROL_X,_posY,CONTROL_W,_height];
_ctrl ctrlCommit 0;

{
	_x params [["_text",""],["_tooltip","",[""]]];

	if !(_text isEqualType "") then {_text = str _text};

	private _index = _ctrl lbAdd _text;
	_ctrl lbSetTooltip [_index,_tooltip];
} forEach _items;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_items,_selection,_height]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(returnData),_returnData];
_ctrl setVariable [QGVAR(selection),_selection];

if (_returnData isEqualTo []) then {
	_ctrl setVariable [QGVAR(value),_selection];
} else {
	_ctrl setVariable [QGVAR(value),_returnData # _selection];
};

_ctrl lbSetCurSel _selection;
_controls pushBack _ctrl;

[_ctrl,"ToolBoxSelChanged",{
	params ["_ctrl","_selection"];

	private _returnData = _ctrl getVariable QGVAR(returnData);
	private _value = if (_returnData isEqualTo []) then {_selection} else {_returnData # _selection};

	_ctrl setVariable [QGVAR(selection),_selection];
	_ctrl setVariable [QGVAR(value),_value];

	if (GVAR(skipOnValueChanged)) exitWith {};
		
	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

_posY = _posY + _height + SPACING_H;
