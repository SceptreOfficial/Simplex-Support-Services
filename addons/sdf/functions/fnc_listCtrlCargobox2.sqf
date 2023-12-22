#include "script_component.hpp"

/*

["text","data",weight,"icon",[children]]

[
	["0","data",0,"icon",[
		["0-0","",0,"",[
			["0-0-0","",0,"",[]],
			["0-0-1","",0,"",[]],
			["0-0-2","",0,"",[]]
		]]
	]],
	["1","",0,"",[
		["1-0","",0,"",[
			["1-0-0","",0,"",[]]
		]]
	]]
]
*/

_valueData params [["_tree",[],[[]]],["_height",4,[0]],["_countLimit",-1,[0]],["_weightLimit",-1,[0]],["_method",0,[0]],["_minInputLevel",0,[0]]];
_height = ITEM_H * ((round _height) max 1);

private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlDescription ctrlSetPosition [0,_posY,DESCRIPTION_W + SPACING_W + CONTROL_W,ITEM_H];
_ctrlDescription ctrlCommit 0;
_ctrlDescription ctrlSetText _descriptionText;
_ctrlDescription ctrlSetTooltip _descriptionTooltip;

//private _cargoItems = if (_forceDefault) then {[]} else {
//	GVAR(cache) getVariable [[_title,_description,_type,_items,_countLimit,_weightLimit] joinString "~",[]]
//};

private _ctrlBG = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
_ctrlBG ctrlSetPosition [CARGOBOX_W + SPACING_W + CARGOBOX_BUTTON_W + SPACING_W,_posY + ITEM_H + SPACING_H,CARGOBOX_W,_height];
_ctrlBG ctrlSetBackgroundColor [0,0,0,0.9];
_ctrlBG ctrlCommit 0;

private _ctrl = _display ctrlCreate [QGVAR(Tree),-1,_ctrlGroup];
_ctrl ctrlSetPosition [0,_posY + ITEM_H + SPACING_H,CARGOBOX_W,_height];
_ctrl ctrlCommit 0;

private _ctrlCargo = _display ctrlCreate [QGVAR(Listbox),-1,_ctrlGroup];
_ctrlCargo ctrlSetPosition [CARGOBOX_W + SPACING_W + CARGOBOX_BUTTON_W + SPACING_W,_posY + ITEM_H + SPACING_H,CARGOBOX_W,_height];
_ctrlCargo ctrlCommit 0;

private _ctrlAdd = _display ctrlCreate [QGVAR(ButtonSimple),-1,_ctrlGroup];
_ctrlAdd ctrlSetPosition [CARGOBOX_W + SPACING_W,_posY + ITEM_H + SPACING_H + (_height / 2 - CARGOBOX_BUTTON_H - (SPACING_H / 2)),CARGOBOX_BUTTON_W,CARGOBOX_BUTTON_H];
_ctrlAdd ctrlCommit 0;
_ctrlAdd ctrlSetText "+";

private _ctrlRemove = _display ctrlCreate [QGVAR(ButtonSimple),-1,_ctrlGroup];
_ctrlRemove ctrlSetPosition [CARGOBOX_W + SPACING_W,_posY + ITEM_H + SPACING_H + (_height / 2 + (SPACING_H / 2)),CARGOBOX_BUTTON_W,CARGOBOX_BUTTON_H];
_ctrlRemove ctrlCommit 0;
_ctrlRemove ctrlSetText "-";

private _fnc_recursive = {
	params ["_parentPath","_entry"];
	_entry params [["_item","",["",[]]],["_data","",[""]],["_weight",0,[0]],["_children",[],[[]]]];
	_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

	private _path = _parentPath + [_ctrl tvAdd [_parentPath,_text]];
	_ctrl tvSetData [_path,_data];
	_ctrl tvSetValue [_path,_weight];
	_ctrl tvSetPicture [_path,_icon];
	_ctrl tvSetTooltip [_path,_tooltip];
	_ctrl tvSetPictureColor [_path,_RGBA];

	{[_path,_x] call _fnc_recursive} forEach _children;
};

{[[],_x] call _fnc_recursive} forEach _tree;

_ctrl setVariable [QGVAR(parameters),[_type,_description,[_items,_height,_countLimit,_weightLimit,_method,_minInputLevel]]];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),[]];
_ctrl setVariable [QGVAR(count),0];
_ctrl setVariable [QGVAR(countLimit),_countLimit];
_ctrl setVariable [QGVAR(weight),0];
_ctrl setVariable [QGVAR(weightLimit),_weightLimit];
_ctrl setVariable [QGVAR(minInputLevel),_minInputLevel];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
_ctrl setVariable [QGVAR(ctrlBG),_ctrlBG];

_ctrl setVariable [QGVAR(ctrlCargo),_ctrlCargo];
_ctrl setVariable [QGVAR(ctrlAdd),_ctrlAdd];
_ctrl setVariable [QGVAR(ctrlRemove),_ctrlRemove];
_ctrlCargo setVariable [QGVAR(ctrlAdd),_ctrlAdd];
_ctrlCargo setVariable [QGVAR(ctrlRemove),_ctrlRemove];
_ctrlAdd setVariable [QGVAR(lists),[_ctrl,_ctrlCargo]];
_ctrlRemove setVariable [QGVAR(lists),[_ctrl,_ctrlCargo]];

_controls pushBack _ctrl;

private _fnc_add = {
	params ["_ctrlAdd"];
	(_ctrlAdd getVariable QGVAR(lists)) params ["_ctrl","_ctrlCargo"];

	private _selectionPath = tvCurSel _ctrl;

	// Input level check
	if (_ctrl getVariable QGVAR(minInputLevel) > count _selectionPath - 1) exitWith {};

	// Count check
	private _count = (_ctrl getVariable QGVAR(count)) + 1;
	private _countLimit = _ctrl getVariable QGVAR(countLimit);

	if (_countLimit != -1 && _count > _countLimit) exitWith {
		systemChat "Unable to add item: Limit reached";
	};

	// Weight check
	private _weight = (_ctrl getVariable QGVAR(weight)) + (_ctrl tvValue _selectionPath);
	private _weightLimit = _ctrl getVariable QGVAR(weightLimit);

	if (_weightLimit != -1 && _weight > _weightLimit) exitWith {
		systemChat "Unable to add item: Overweight";
	};

	_ctrl setVariable [QGVAR(count),_count];
	_ctrl setVariable [QGVAR(weight),_weight];

	// Add
	private _index = _ctrlCargo lbAdd (_ctrl tvText _selectionPath);

	_ctrlCargo lbSetPicture [_index,_ctrl tvPicture _selectionPath];
	_ctrlCargo lbSetValue [_index,_ctrl tvValue _selectionPath];

	private _value = +(_ctrl getVariable QGVAR(value));
	_value pushBack (_ctrl tvData _selectionPath);
	_ctrl setVariable [QGVAR(value),_value];

	_ctrlCargo lbSetCurSel _index;

	if (GVAR(skipOnValueChanged)) exitWith {};

	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
};

private _fnc_remove = {
	params ["_ctrlRemove"];
	(_ctrlRemove getVariable QGVAR(lists)) params ["_ctrl","_ctrlCargo"];

	private _selection = lbCurSel _ctrlCargo;

	if (_selection == -1) exitWith {};

	// Count
	_ctrl setVariable [QGVAR(count),(_ctrl getVariable QGVAR(count)) - 1];

	// Weight
	_ctrl setVariable [QGVAR(weight),(_ctrl getVariable QGVAR(weight)) - (_ctrlCargo lbValue _selection)];

	// Remove
	private _value = +(_ctrl getVariable QGVAR(value));
	_value deleteAt _selection;
	_ctrl setVariable [QGVAR(value),_value];

	_ctrlCargo lbDelete _selection;

	if (GVAR(skipOnValueChanged)) exitWith {};
		
	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
};

private _fnc_mouseMoving = {
	(_this # 0) setVariable [QGVAR(mouseOver),_this # 3];
};

private _fnc_doubleClick = {
	if ((_this # 0) getVariable QGVAR(mouseOver)) then {
		(_thisArgs # 0) call (_thisArgs # 1);
	};
};

[_ctrlAdd,"ButtonClick",_fnc_add] call CBA_fnc_addBISEventHandler;
[_ctrlRemove,"ButtonClick",_fnc_remove] call CBA_fnc_addBISEventHandler;
[_ctrl,"MouseMoving",_fnc_mouseMoving] call CBA_fnc_addBISEventHandler;
[_ctrlCargo,"MouseMoving",_fnc_mouseMoving] call CBA_fnc_addBISEventHandler;
[_ctrl,"MouseButtonDblClick",_fnc_doubleClick,[_ctrlAdd,_fnc_add]] call CBA_fnc_addBISEventHandler;
[_ctrlCargo,"MouseButtonDblClick",_fnc_doubleClick,[_ctrlRemove,_fnc_remove]] call CBA_fnc_addBISEventHandler;

_posY = _posY + ITEM_H + SPACING_H + _height + SPACING_H;
