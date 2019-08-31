/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Sets the new selected/default value and the available values of a control.

Parameters:
0: Control index <SCALAR>
1: New value(s) <BOOL | STRING | ARRAY>
2: True: Force default. False: Use cached value <BOOL>

Returns:
Nothing
//-----------------------------------------------------------------------------------------------*/
#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_newValues",[],[true,"",[]]],["_forceDefault",true,[true]]];

private _ctrl = findDisplay DISPLAY_IDD displayCtrl ((uiNamespace getVariable "SSS_CDS_controls") # _index);
private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
private _type = _ctrlInfo # 0;
private _description = _ctrlInfo # 1;

if (!_forceDefault) then {
	_newValues = [toUpper _type,_description,_newValues,false] call FUNC(cacheValue);
};

switch (_type) do {
	case "CHECKBOX" : {
		_newValues params [["_bool",true,[true]]];
		_ctrlInfo set [2,_bool];
		_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];

		_ctrl cbSetChecked _bool;
	};
	case "EDITBOX" : {
		_newValues params [["_string","",[""]]];
		_ctrlInfo set [2,_string];
		_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];

		_ctrl ctrlSetText _string;
	};
	case "SLIDER" : {
		_newValues params [["_sliderValues",[0,1,1],[[]],3],["_sliderPos",0.5,[0]]];
		_sliderValues params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];
		_ctrlInfo set [2,[[_min,_max,_decimals],_sliderPos]];
		_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];

		private _fixedValue = _sliderPos toFixed _decimals;
		private _aux = findDisplay DISPLAY_IDD displayCtrl (_ctrl getVariable "SSS_CDS_auxIDC");
		_aux ctrlSetText _fixedValue;
		_ctrl sliderSetRange [_min,_max];
		_ctrl sliderSetPosition parseNumber _fixedValue;
		_ctrl ctrlSetTooltip _fixedValue;
	};
	case "COMBOBOX" : {
		_newValues params [["_listItems",[],[[]]],["_selection",0,[0]]];
		_ctrlInfo set [2,[_listItems,_selection]];
		_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];

		lbClear _ctrl;
		{
			if (_x isEqualType []) then {
				_x params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];
				private _index = _ctrl lbAdd _text;
				_ctrl lbSetTooltip [_index,_tooltip];
				_ctrl lbSetPicture [_index,_icon];
				_ctrl lbSetColor [_index,_RGBA];
			};
			if (_x isEqualType "") then {
				_ctrl lbAdd _x;
			};
		} forEach _listItems;
		_ctrl lbSetCurSel _selection;
	};
	default {};
};
