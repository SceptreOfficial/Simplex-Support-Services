#include "..\script_component.hpp"

disableSerialization;
params [["_ctrl",0,[0,controlNull]],["_valueData",[]],["_forceDefault",true,[true]]];

if (_ctrl isEqualType 0) then {
	_ctrl = (uiNamespace getVariable QGVAR(controls)) # _ctrl;
};

private _title = uiNamespace getVariable [QGVAR(title),""];
private _params = _ctrl getVariable [QGVAR(parameters),[]];
_params params ["_type","_description"];

switch _type do {
	case "CHECKBOX" : {
		_valueData params [["_bool",true,[true]]];

		if (!_forceDefault) then {
			_bool = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_bool];
		};

		_params set [2,_bool];
		_ctrl setVariable [QGVAR(parameters),_params];
		
		_ctrl cbSetChecked _bool;
		_ctrl setVariable [QGVAR(value),_bool];
	};

	case "EDITBOX" : {
		_valueData params [["_string",""],["_tooltip","",[""]]];

		if !(_string isEqualType "") then {
			_string = str _string;
		};

		if (!_forceDefault) then {
			_string = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_string];
		};

		_params set [2,_string];
		_ctrl setVariable [QGVAR(parameters),_params];

		_ctrl ctrlSetText _string;
		_ctrl ctrlSetTooltip _tooltip;
		_ctrl setVariable [QGVAR(value),_string];
	};

	case "SLIDER" : {
		_valueData params [["_sliderData",[0,1,1],[[]]],["_sliderPos",0,[0]]];
		_sliderData params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];

		if (!_forceDefault) then {
			_sliderPos = GVAR(cache) getVariable [[_title,_description,_type,_sliderData] joinString "~",_sliderPos];
		};

		_params set [2,[[_min,_max,_decimals],_sliderPos]];
		_ctrl setVariable [QGVAR(parameters),_params];

		private _sliderPosStr = _sliderPos toFixed _decimals;
		_ctrl sliderSetRange [_min,_max];
		_ctrl sliderSetPosition parseNumber _sliderPosStr;

		private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
		_ctrlEdit ctrlSetText _sliderPosStr;

		_ctrl setVariable [QGVAR(value),sliderPosition _ctrl];
	};

	case "COMBOBOX" : {
		_valueData params [["_items",[],[[]]],["_selection",0],["_returnData",[],[[]]]];

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[_title,_description,_type,_items] joinString "~",_selection];
		};

		if !(_selection isEqualType 0) then {
			if (_returnData isEqualTo []) then {
				_selection = (_items find _selection) max 0;
			} else {
				_selection = (_returnData find _selection) max 0;
			};
		};

		_params set [2,[_items,_selection]];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(returnData),_returnData];

		lbClear _ctrl;

		{
			_x params [["_text",""],["_tooltip","",[""]],["_icon",["",[1,1,1,1]],["",[]],2],["_RGBA",[1,1,1,1],[[]],4]];

			if !(_text isEqualType "") then {_text = str _text};
			if (_icon isEqualType "") then {_icon = [_icon,[1,1,1,1]]};

			private _index = _ctrl lbAdd _text;
			_ctrl lbSetTooltip [_index,_tooltip];
			_ctrl lbSetPicture [_index,_icon # 0];
			_ctrl lbSetPictureColor [_index,_icon # 1];
			_ctrl lbSetColor [_index,_RGBA];
		} forEach _items;

		_ctrl lbSetCurSel _selection;
	};

	case "LISTNBOX" : {
		private _paramsArray = if (GVAR(cache) == GVAR(gridCache)) then {
			[["_rows",[],[[]]],["_selection",0,[0]],["_returnData",[],[[]]],["_doubleClick",{},[{}]]]
		} else {
			[["_rows",[],[[]]],["_selection",0,[0]],["_height",1,[0]],["_returnData",[],[[]]],["_doubleClick",{},[{}]]]
		};

		_valueData params _paramsArray;

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[_title,_description,_type,_rows] joinString "~",_selection];
		};

		_params set [2,[_rows,_selection,_height]];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(returnData),_returnData];
		_ctrl setVariable [QGVAR(doubleClick),_doubleClick];

		lnbClear _ctrl;

		private _columnsCount = 3;

		{
			if !(_x isEqualType []) then {_x = [_x]};

			private _columns = _x apply {
				_x params [["_text",""],["_tooltip","",[""]],["_icon",["",[1,1,1,1]],["",[]],2],["_RGBA",[1,1,1,1],[[]],4]];
				if !(_text isEqualType "") then {_text = str _text};
				if (_icon isEqualType "") then {_icon = [_icon,[1,1,1,1]]};
				[_text,_tooltip,_icon,_RGBA]
			};

			if (count _columns > _columnsCount) then {
				_columnsCount = _columnsCount max (count _columns);
				private _columnsPos = [];
				_columnsPos resize _columnsCount;
				{_columnsPos set [_forEachIndex,1/_columnsCount*_forEachIndex]} forEach +_columnsPos;
				_ctrl lnbSetColumnsPos _columnsPos;
			};

			private _index = _ctrl lnbAddRow (_columns apply {_x # 0});

			{
				_ctrl lnbSetTooltip [[_index,_forEachIndex],_x # 1];
				_ctrl lnbSetPicture [[_index,_forEachIndex],_x # 2 # 0];
				_ctrl lnbSetPictureColor [[_index,_forEachIndex],_x # 2 # 1];
				_ctrl lnbSetColor [[_index,_forEachIndex],_x # 3];
			} forEach _columns;
		} forEach _rows;

		_ctrl lnbSetCurSelRow _selection;
	};

	case "LISTNBOXCB" : {
		private _paramsArray = if (GVAR(cache) == GVAR(gridCache)) then {
			[["_rows",[],[[]]],["_selection",[],[[],false]],["_returnData",[],[[]]]]
		} else {
			[["_rows",[],[[]]],["_selection",[],[[],false]],["_height",1,[0]],["_returnData",[],[[]]]]
		};

		_valueData params _paramsArray;

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[_title,_description,_type,_rows] joinString "~",_selection];
		};

		_params set [2,[_rows,_selection,_height]];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(returnData),_returnData];

		lnbClear _ctrl;

		private _columnsCount = 3;

		{
			if !(_x isEqualType []) then {_x = [_x]};

			private _columns = _x apply {
				_x params [["_text",""],["_tooltip","",[""]],["_icon",["",[1,1,1,1]],["",[]],2],["_RGBA",[1,1,1,1],[[]],4]];
				if !(_text isEqualType "") then {_text = str _text};
				if (_icon isEqualType "") then {_icon = [_icon,[1,1,1,1]]};
				[_text,_tooltip,_icon,_RGBA]
			};

			if (count _columns > _columnsCount) then {
				_columnsCount = _columnsCount max (count _columns);
				private _columnsPos = [];
				_columnsPos resize _columnsCount;
				{_columnsPos set [_forEachIndex,1/_columnsCount*_forEachIndex]} forEach +_columnsPos;
				_ctrl lnbSetColumnsPos _columnsPos;
			};

			private _index = _ctrl lnbAddRow (_columns apply {_x # 0});

			{
				_ctrl lnbSetTooltip [[_index,_forEachIndex],_x # 1];
				_ctrl lnbSetPicture [[_index,_forEachIndex],_x # 2 # 0];
				_ctrl lnbSetPictureColor [[_index,_forEachIndex],_x # 2 # 1];
				_ctrl lnbSetColor [[_index,_forEachIndex],_x # 3];
			} forEach _columns;
		} forEach _rows;
		
		if (_selection isEqualType []) then {
			_selection = _selection apply {
				if !(_selection isEqualType 0) then {_returnData find _x} else {_x}
			};
		} else {
			if (_selection) then {
				_selection = [];
				{_selection pushBack _forEachIndex} forEach _rows;
			} else {
				_selection = [];
			};
		};

		_ctrl setVariable [QGVAR(selection),_selection];

		{
			if (_forEachIndex in _selection) then {
				_ctrl lnbSetPictureRight [[_forEachIndex,0],"A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa"];
			} else {
				_ctrl lnbSetPictureRight [[_forEachIndex,0],"A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa"];
			};
		} forEach _rows;

		_ctrl setVariable [QGVAR(selection),_selection];

		if (_returnData isEqualTo []) then {
			_ctrl setVariable [QGVAR(value),_selection];
		} else {
			_ctrl setVariable [QGVAR(value),_selection apply {_returnData # _x}];
		};
	};

	case "LISTNBOXMULTI" : {
		private _paramsArray = if (GVAR(cache) == GVAR(gridCache)) then {
			[["_rows",[],[[]]],["_selection",[],[[]]],["_returnData",[],[[]]]]
		} else {
			[["_rows",[],[[]]],["_selection",[],[[]]],["_height",1,[0]],["_returnData",[],[[]]]]
		};

		_valueData params _paramsArray;

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[_title,_description,_type,_rows] joinString "~",_selection];
		};

		_params set [2,[_rows,_selection,_height]];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(returnData),_returnData];
		_ctrl setVariable [QGVAR(rowCount),count _rows];

		lnbClear _ctrl;

		private _columnsCount = 3;

		{
			if !(_x isEqualType []) then {_x = [_x]};

			private _columns = _x apply {
				_x params [["_text",""],["_tooltip","",[""]],["_icon",["",[1,1,1,1]],["",[]],2],["_RGBA",[1,1,1,1],[[]],4]];
				if !(_text isEqualType "") then {_text = str _text};
				if (_icon isEqualType "") then {_icon = [_icon,[1,1,1,1]]};
				[_text,_tooltip,_icon,_RGBA]
			};

			if (count _columns > _columnsCount) then {
				_columnsCount = _columnsCount max (count _columns);
				private _columnsPos = [];
				_columnsPos resize _columnsCount;
				{_columnsPos set [_forEachIndex,1/_columnsCount*_forEachIndex]} forEach +_columnsPos;
				_ctrl lnbSetColumnsPos _columnsPos;
			};

			private _index = _ctrl lnbAddRow (_columns apply {_x # 0});

			{
				_ctrl lnbSetTooltip [[_index,_forEachIndex],_x # 1];
				_ctrl lnbSetPicture [[_index,_forEachIndex],_x # 2 # 0];
				_ctrl lnbSetPictureColor [[_index,_forEachIndex],_x # 2 # 1];
				_ctrl lnbSetColor [[_index,_forEachIndex],_x # 3];
			} forEach _columns;
		} forEach _rows;

		_selection = _selection apply {
			if !(_selection isEqualType 0) then {_returnData find _x} else {_x}
		};

		_ctrl setVariable [QGVAR(selection),_selection];

		if (_returnData isEqualTo []) then {
			_ctrl setVariable [QGVAR(value),_selection];
		} else {
			_ctrl setVariable [QGVAR(value),_selection apply {_returnData # _x}];
		};

		{_ctrl lbSetSelected [_x,true]} forEach _selection;
	};

	case "CARGOBOX" : {
		_valueData params [["_items",[],[[]]],["_height",4,[0]],["_countLimit",-1,[0]],["_weightLimit",-1,[0]],["_method",0,[0]]];

		_params set [2,[_items,_height,_countLimit,_weightLimit,_method]];
		_ctrl setVariable [QGVAR(parameters),_params];

		lbClear _ctrl;
		
		if (_method isEqualTo 0) then {
			lbClear (_ctrl getVariable QGVAR(ctrlCargo));
		};

		{
			_x params [["_item","",["",[]]],["_data","",[""]],["_weight",0,[0]]];
			_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

			private _index = _ctrl lbAdd _text;
			_ctrl lbSetTooltip [_index,_tooltip];
			_ctrl lbSetPicture [_index,_icon];
			_ctrl lbSetColor [_index,_RGBA];
			_ctrl lbSetData [_index,_data];
			_ctrl lbSetValue [_index,_weight];
		} forEach _items;

		_ctrl lbSetCurSel 0;

		if (_method isEqualTo 0) then {
			_ctrl setVariable [QGVAR(value),[]];
		};
	};

	case "CARGOBOX2" : {
		_valueData params [["_tree",[],[[]]],["_height",4,[0]],["_countLimit",-1,[0]],["_weightLimit",-1,[0]],["_method",0,[0]],["_minInputLevel",0,[0]]];

		_params set [2,[_items,_height,_countLimit,_weightLimit,_method,_minInputLevel]];
		_ctrl setVariable [QGVAR(parameters),_params];

		tvClear _ctrl;
		
		if (_method isEqualTo 0) then {
			lbClear (_ctrl getVariable QGVAR(ctrlCargo));
		};

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

		if (_method isEqualTo 0) then {
			_ctrl setVariable [QGVAR(value),[]];
		};
	};

	case "TREE" : {
		private _paramsArray = if (GVAR(cache) == GVAR(gridCache)) then {
			[["_tree",[],[[]]],["_returnPath",false,[false]],["_doubleClick",{},[{}]]]
		} else {
			[["_tree",[],[[]]],["_height",4,[0]],["_returnPath",false,[false]],["_doubleClick",{},[{}]]]
		};

		_valueData params _paramsArray;

		_params set [2,[_tree,_height,_returnPath]];
		_ctrl setVariable [QGVAR(parameters),_params];

		tvClear _ctrl;

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

		_ctrl setVariable [QGVAR(value),[_ctrl tvData tvCurSel _ctrl,tvCurSel _ctrl] select _returnPath];
	};

	case "ARRAY" : {
		_valueData params [["_labels",[],[[]]],["_strings",[],[[]]]];

		if (!_forceDefault) then {
			_strings = GVAR(cache) getVariable [[_title,_description,_type,_labels] joinString "~",_strings];
		};

		_params set [2,[_labels,_strings]];
		_ctrl setVariable [QGVAR(parameters),_params];

		{
			(_labels # _forEachIndex) params [["_text",""],["_tooltip","",[""]],["_RGBA",GVAR(profileRGBA),[[]],4]];
			
			_x ctrlSetBackgroundColor _RGBA;
			_x ctrlCommit 0;
			_x ctrlSetText _text;
			_x ctrlSetTooltip _tooltip;
		} forEach (_ctrl getVariable QGVAR(labelCtrls));
		
		private _parsed = [];

		{
			private _string = _strings # _forEachIndex;
			
			if (_string isEqualType "") then {
				_parsed pushBack parseNumber _x;
			} else {
				_parsed pushBack _x;
				_string = str _x;
			};

			_x ctrlSetText _string;
		} forEach (_ctrl getVariable QGVAR(stringCtrls));
		
		_ctrl setVariable [QGVAR(value),_parsed];
	};

	case "TOOLBOX" : {
		_valueData params [["_items",[],[[]]],["_selection",0,[0]],["_returnData",[],[[]]]];

		if (!_forceDefault) then {
			_selection = GVAR(cache) getVariable [[_title,_description,_type,_items] joinString "~",_selection];
		};

		_params set [2,[_items,_selection]];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(returnData),_returnData];

		lbClear _ctrl;

		{
			_x params [["_text",""],["_tooltip","",[""]],["_icon",["",[1,1,1,1]],["",[]],2],["_RGBA",GVAR(profileRGBA),[[]],4]];

			if !(_text isEqualType "") then {_text = str _text};
			if (_icon isEqualType "") then {_icon = [_icon,[1,1,1,1]]};

			private _index = _ctrl lbAdd _text;
			_ctrl lbSetTooltip [_index,_tooltip];
			_ctrl lbSetPicture [_index,_icon # 0];
			_ctrl lbSetPictureColor [_index,_icon # 1];
			_ctrl lbSetColor [_index,_RGBA];
		} forEach _items;

		_ctrl lbSetCurSel _selection;
	};

	case "MAP" : {
		_valueData params [["_pointData",[],[[]]],["_areaData",[],[[]]],["_lineData",[],[[]]],["_mode",0,[0]]];

		_pointData params [["_points",[[0,0,0]],[[]]]];
		_areaData params [["_area",[[0,0,0],0,0,0,true],[[]]]];
		_lineData params [["_path",[]]];

		private _value = [_points,_area,_path] # _mode;
		private _modeCache = _ctrl getVariable QGVAR(modeCache);
		_modeCache set [_mode,_value];

		_params set [2,_valueData];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(value),+_value];
		_ctrl setVariable [QGVAR(modeCache),_modeCache];
		_ctrl setVariable [QGVAR(mode),_mode];

		[_ctrl,_mode] call FUNC(mapMode);
	};

	case "BUTTON" : {
		_valueData params [["_code",{},[{},""]]];

		_params set [2,_code];
		_ctrl setVariable [QGVAR(parameters),_params];
		_ctrl setVariable [QGVAR(value),_code];
	};

	case "BUTTON2" : {
		if (GVAR(cache) == GVAR(gridCache)) then {
			_valueData params [["_code",{},[{},""]]];

			_params set [2,_code];
			_ctrl setVariable [QGVAR(parameters),_params];
			_ctrl setVariable [QGVAR(value),_code];
		} else {
			_valueData params ["",["_code1",{},[{},""]],"",["_code2",{},[{},""]]];

			if (_code1 isEqualType "") then {_code1 = compile _code1};
			if (_code2 isEqualType "") then {_code2 = compile _code2};

			_ctrl setVariable [QGVAR(value),_code1];
			(_ctrl getVariable QGVAR(button2)) setVariable [QGVAR(value),_code2];
		};
	};
};
