#include "script_component.hpp"

/*
["text","data",[children]]

[
	["0","data",[
		["0-0","",[
			["0-0-0","",[]],
			["0-0-1","",[]],
			["0-0-2","",[]]
		]]
	]],
	["1","",[
		["1-0","",[
			["1-0-0","",[]]
		]]
	]]
]
*/

_valueData params [["_tree",[],[[]]],["_height",4,[0]],["_returnPath",false,[false]],["_doubleClick",{},[{}]]];
_height = ITEM_H * ((round _height) max 1);

private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlDescription ctrlSetPosition [0,_posY,DESCRIPTION_W + SPACING_W + CONTROL_W,ITEM_H];
_ctrlDescription ctrlCommit 0;
_ctrlDescription ctrlSetText _descriptionText;
_ctrlDescription ctrlSetTooltip _descriptionTooltip;

private _ctrl = _display ctrlCreate [QGVAR(Tree),-1,_ctrlGroup];
_ctrl ctrlSetPosition [0,_posY + ITEM_H + SPACING_H,TREE_W,_height];
_ctrl ctrlCommit 0;

private _fnc_recursive = {
	params ["_parentPath","_entry"];
	_entry params [["_item","",["",[]]],["_data","",[""]],["_children",[],[[]]]];
	_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

	private _path = _parentPath + [_ctrl tvAdd [_parentPath,_text]];
	_ctrl tvSetData [_path,_data];
	_ctrl tvSetPicture [_path,_icon];
	_ctrl tvSetTooltip [_path,_tooltip];
	_ctrl tvSetPictureColor [_path,_RGBA];

	{[_path,_x] call _fnc_recursive} forEach _children;
};

{[[],_x] call _fnc_recursive} forEach _tree;

_ctrl tvSetCurSel [0];

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_tree,_height,_returnPath]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),[_ctrl tvData tvCurSel _ctrl,tvCurSel _ctrl] select _returnPath];
_ctrl setVariable [QGVAR(returnPath),_returnPath];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];

_controls pushBack _ctrl;

[_ctrl,"TreeSelChanged",{
	params ["_ctrl","_selectionPath"];

	private _value = [_ctrl tvData _selectionPath,_selectionPath] select (_ctrl getVariable QGVAR(returnPath));
	_ctrl setVariable [QGVAR(value),_value];	

	if (GVAR(skipOnValueChanged)) exitWith {};
		
	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"TreeDblClick",{
	params ["_ctrl"];
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments),_ctrl] call _thisArgs;
},_doubleClick] call CBA_fnc_addBISEventHandler;

[_ctrl,"KeyDown",{
	params ["_ctrl","_key"];
	if !(_key in [DIK_RETURN,DIK_NUMPADENTER]) exitWith {};
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments),_ctrl] call _thisArgs;
},_doubleClick] call CBA_fnc_addBISEventHandler;


_posY = _posY + ITEM_H + SPACING_H + _height + SPACING_H;
