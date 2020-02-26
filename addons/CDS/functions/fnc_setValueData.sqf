#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_valueData",[],[true,"",[]]],["_forceDefault",true,[true]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _data = _ctrl getVariable QGVAR(data);
_data params ["_type","_description"];

switch (_type) do {
	case "CHECKBOX" : {
		_valueData params [["_bool",true,[true]]];

		if (!_forceDefault) then {
			_bool = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type] joinString "~",_bool];
		};

		_data set [2,_bool];
		_ctrl setVariable [QGVAR(data),_data];
		
		_ctrl cbSetChecked _bool;
	};

	case "EDITBOX" : {
		_valueData params [["_string","",[""]]];

		if (!_forceDefault) then {
			_string = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type] joinString "~",_string];
		};

		_data set [2,_string];
		_ctrl setVariable [QGVAR(data),_data];

		_ctrl ctrlSetText _string;
	};

	case "SLIDER" : {
		_valueData params [["_sliderData",[0,1,1],[[]]],["_sliderPos",0,[0]]];
		_sliderData params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];

		if (!_forceDefault) then {
			_sliderPos = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type,_sliderData] joinString "~",_sliderPos];
		};

		_data set [2,[[_min,_max,_decimals],_sliderPos]];
		_ctrl setVariable [QGVAR(data),_data];

		private _sliderPosStr = _sliderPos toFixed _decimals;
		_ctrl sliderSetRange [_min,_max];
		_ctrl sliderSetPosition parseNumber _sliderPosStr;

		private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
		_ctrlEdit ctrlSetText _sliderPosStr;
	};

	case "COMBOBOX" : {
		_valueData params [["_items",[],[[]]],["_selection",0,[0]]];

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type,_items] joinString "~",_selection];
		};

		_data set [2,[_items,_selection]];
		_ctrl setVariable [QGVAR(data),_data];

		lbClear _ctrl;

		{
			_x params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

			private _index = _ctrl lbAdd _text;
			_ctrl lbSetTooltip [_index,_tooltip];
			_ctrl lbSetPicture [_index,_icon];
			_ctrl lbSetColor [_index,_RGBA];
		} forEach _items;

		_ctrl lbSetCurSel _selection;
	};

	case "LISTNBOX" : {
		_valueData params [["_rows",[],[[]]],["_selection",0,[0]],["_height",1,[0]]];
		// To-do: dynamic height adjustment

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type,_rows] joinString "~",_selection];
		};

		_data set [2,[_rows,_selection,_height]];
		_ctrl setVariable [QGVAR(data),_data];

		lnbClear _ctrl;

		{
			private _columns = _x apply {
				_x params [["_text","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];
				[_text,_icon,_RGBA]
			};

			private _index = _ctrl lnbAddRow (_columns apply {_x # 0});

			{
				_ctrl lnbSetPicture [[_index,_forEachIndex],_x # 1];
				_ctrl lnbSetColor [[_index,_forEachIndex],_x # 2];
			} forEach _columns;
		} forEach _rows;

		_ctrl lnbSetCurSelRow _selection;
	};

	case "BUTTON" : {
		_valueData params [["_code",{},[{},""]]];

		if (!_forceDefault) then {
			_code = GVAR(cache) getVariable [[uiNamespace getVariable QGVAR(title),_description,_type] joinString "~",_code];
		};

		_data set [2,_code];
		_ctrl setVariable [QGVAR(data),_data];
	};
};
