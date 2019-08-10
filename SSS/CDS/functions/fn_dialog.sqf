/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Creates a dialog with defined control types.

Parameters:
0: Dialog title <STRING>
1: Array of control arrays <ARRAY>
	Control array parameters:
	0: Control type <STRING>
	1: Control text/description <STRING,ARRAY>
	2: Control values <ARRAY>
	3: Use default value <BOOL>
	4: Value changed function <CODE>
		Arguments:
		0: _currentValue <BOOL,SCALAR,STRING>
		1: _customArguments <ANY>
		2: _ctrl <CONTROL>
	5: Show/Enable condition <CODE>
		Arguments:
		0: _currentValue <BOOL,SCALAR,STRING>
		1: _customArguments <ANY>
		2: _ctrl <CONTROL>
2: OK exit code
	Available arguments in code:
	1: _controlValues <ARRAY>
	2: _customArguments <ANY>
3: Cancel exit code
	Available arguments in code:
	1: _controlValues <ARRAY>
	2: _customArguments <ANY>
4: Custom arguments that are passed to conditions, mod functions, and exit codes.

Returns:
Nothing
//-----------------------------------------------------------------------------------------------*/
#include "..\defines.hpp"

if (!isNull (findDisplay DISPLAY_IDD)) exitWith {};

disableSerialization;
params [["_titleText","",[""]],["_controls",[],[[]]],["_onOK",{},[{}]],["_onCancel",{},[{}]],["_customArguments",[]]];

uiNamespace setVariable ["SSS_CDS_titleText",_titleText];
uiNamespace setVariable ["SSS_CDS_onOK",_onOK];
uiNamespace setVariable ["SSS_CDS_onCancel",_onCancel];
uiNamespace setVariable ["SSS_CDS_customArguments",_customArguments];
createDialog "SSS_CDS_Dialog";
private _display = findDisplay DISPLAY_IDD;
private _neededHeight = count _controls * ROW_H + BUFFER_H;

// Background
private _BG = _display displayCtrl BG_IDC;
_BG ctrlSetPosition [DEFAULT_X,CENTER_Y - _neededHeight / 2,TOTAL_WIDTH,_neededHeight];
_BG ctrlCommit 0;

// Title
private _title = _display displayCtrl TITLE_IDC;
_title ctrlSetPosition [DEFAULT_X,CENTER_Y - _neededHeight / 2 - TITLE_H - BUTTON_SEPARATION];
_title ctrlSetText _titleText;
_title ctrlCommit 0;

// OK button
private _OK = _display displayCtrl OK_IDC;
_OK ctrlSetPosition [DEFAULT_X + TOTAL_WIDTH - BUTTON_W,CENTER_Y + _neededHeight / 2 + BUTTON_SEPARATION];
_OK ctrlCommit 0;

// Cancel button
private _cancel = _display displayCtrl CANCEL_IDC;
_cancel ctrlSetPosition [DEFAULT_X,CENTER_Y + _neededHeight / 2 + BUTTON_SEPARATION];
_cancel ctrlCommit 0;

// Controls
private _IDCs = [];
private _posY = CENTER_Y - _neededHeight / 2 + BUFFER_H / 1.5;
{
	(_controls # _forEachIndex) params [
		["_type","",[""]],
		["_description","",["",[]]],
		["_values",[],[true,"",[]]],
		["_forceDefault",true,[true]],
		["_onValueChanged",{},[{}]],
		["_enableCondition",{true},[{}]]
	];

	// Create Description
	private _text = _display ctrlCreate ["SSS_CDS_Text",TEXT_IDC_START + _forEachIndex];
	_text ctrlSetPosition [TEXT_X,_posY];
	if (_description isEqualType []) then {
		_text ctrlSetText (_description # 0 + ":");
		_text ctrlSetTooltip (_description # 1);
	} else {
		_text ctrlSetText (_description + ":");
	};
	_text ctrlCommit 0;

	if (!_forceDefault) then {
		_values = [toUpper _type,_description,_values,false] call SSS_CDS_fnc_cacheValue;
	};

	// Create control
	switch (toUpper _type) do {
		case "CHECKBOX" : {
			_values params [["_bool",true,[true]]];

			private _ctrl = _display ctrlCreate ["SSS_CDS_Checkbox",CTRL_IDC_START + _forEachIndex];
			_ctrl ctrlSetPosition [CTRL_X,_posY + CHECKBOX_Y];
			_ctrl ctrlCommit 0;
			_ctrl cbSetChecked _bool;
			_ctrl setVariable ["SSS_CDS_ctrlInfo",[_type,_description,_bool,_onValueChanged,_enableCondition]];
			_ctrl setVariable ["SSS_CDS_descriptionIDC",TEXT_IDC_START + _forEachIndex];

			_ctrl ctrlAddEventHandler ["CheckedChanged",{
				params ["_ctrl","_currentValue"];
				_currentValue = _currentValue isEqualTo 1;
				private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
				_ctrlInfo set [2,_currentValue];
				_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];
				[_currentValue,uiNamespace getVariable "SSS_CDS_customArguments",_ctrl] call (_ctrlInfo # 3);
			}];
		};
		case "EDITBOX" : {
			_values params [["_string","",[""]]];

			private _ctrl = _display ctrlCreate ["SSS_CDS_Editbox",CTRL_IDC_START + _forEachIndex];
			_ctrl ctrlSetPosition [CTRL_X,_posY + EDITBOX_Y];
			_ctrl ctrlCommit 0;
			_ctrl ctrlSetText _string;
			_ctrl setVariable ["SSS_CDS_ctrlInfo",[_type,_description,_string,_onValueChanged,_enableCondition]];
			_ctrl setVariable ["SSS_CDS_descriptionIDC",TEXT_IDC_START + _forEachIndex];

			_ctrl ctrlAddEventHandler ["KeyUp",{
				params ["_ctrl"];
				private _currentValue = ctrlText _ctrl;
				private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
				_ctrlInfo set [2,_currentValue];
				_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];
				[_currentValue,uiNamespace getVariable "SSS_CDS_customArguments",_ctrl] call (_ctrlInfo # 3);
			}];
		};
		case "SLIDER" : {
			_values params [["_sliderValues",[0,1,1],[[]],3],["_sliderPos",0,[0]]];
			_sliderValues params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];

			private _fixedValue = _sliderPos toFixed _decimals;
			private _ctrl = _display ctrlCreate ["SSS_CDS_Slider",CTRL_IDC_START + _forEachIndex];
			_ctrl ctrlSetPosition [CTRL_X,_posY + SLIDER_Y];
			_ctrl ctrlCommit 0;
			_ctrl sliderSetRange [_min,_max];
			_ctrl sliderSetPosition parseNumber _fixedValue;
			_ctrl ctrlSetTooltip _fixedValue;
			_ctrl setVariable ["SSS_CDS_ctrlInfo",[_type,_description,_values,_onValueChanged,_enableCondition]];
			_ctrl setVariable ["SSS_CDS_descriptionIDC",TEXT_IDC_START + _forEachIndex];

			private _aux = _display ctrlCreate ["SSS_CDS_SliderAux",CTRL_AUX_IDC_START + _forEachIndex];
			_aux ctrlSetPosition [SLIDER_AUX_X,_posY + SLIDER_AUX_Y];
			_aux ctrlCommit 0;
			_aux ctrlSetText _fixedValue;
			_aux setVariable ["SSS_CDS_parentIDC",CTRL_IDC_START + _forEachIndex];
			_ctrl setVariable ["SSS_CDS_auxIDC",CTRL_AUX_IDC_START + _forEachIndex];

			_ctrl ctrlAddEventHandler ["SliderPosChanged",{
				params ["_ctrl","_sliderPos"];
				private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
				((_ctrlInfo # 2) # 0) params ["_min","_max","_decimals"];
				private _currentValue = _sliderPos toFixed _decimals;
				private _aux = findDisplay DISPLAY_IDD displayCtrl (_ctrl getVariable "SSS_CDS_auxIDC");
				_aux ctrlSetText _currentValue;
				_ctrl ctrlSetTooltip _currentValue;
				_currentValue = parseNumber _currentValue;

				(_ctrlInfo select 2) set [1,_currentValue];
				_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];
				[_currentValue,uiNamespace getVariable "SSS_CDS_customArguments",_ctrl] call (_ctrlInfo # 3);
			}];

			_aux ctrlAddEventHandler ["KeyUp",{
				params ["_aux"];
				private _ctrl = findDisplay DISPLAY_IDD displayCtrl (_aux getVariable "SSS_CDS_parentIDC");
				private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
				((_ctrlInfo # 2) # 0) params ["_min","_max","_decimals"];
				private _currentValue = (_min max (parseNumber ctrlText _aux) min _max) toFixed _decimals;
				_aux ctrlSetText _currentValue;
				_ctrl ctrlSetTooltip _currentValue;
				_currentValue = parseNumber _currentValue;
				_ctrl sliderSetPosition _currentValue;

				(_ctrlInfo select 2) set [1,_currentValue];
				_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];
				[_currentValue,uiNamespace getVariable "SSS_CDS_customArguments",_ctrl] call (_ctrlInfo # 3);
			}];
		};
		case "COMBOBOX" : {
			_values params [["_listItems",[],[[]]],["_selection",0,[0]]];

			private _ctrl = _display ctrlCreate ["SSS_CDS_Combobox",CTRL_IDC_START + _forEachIndex];
			_ctrl ctrlSetPosition [CTRL_X,_posY + COMBOBOX_Y];
			_ctrl ctrlCommit 0;
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
			_ctrl setVariable ["SSS_CDS_ctrlInfo",[_type,_description,_values,_onValueChanged,_enableCondition]];
			_ctrl setVariable ["SSS_CDS_descriptionIDC",TEXT_IDC_START + _forEachIndex];

			_ctrl ctrlAddEventHandler ["LBSelChanged",{
				params ["_ctrl","_currentValue"];
				private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
				(_ctrlInfo select 2) set [1,_currentValue];
				_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];
				[_currentValue,uiNamespace getVariable "SSS_CDS_customArguments",_ctrl] call (_ctrlInfo # 3);
			}];
		};
		default {systemChat format ["Control %1 : Unsupported control type",_forEachIndex];};
	};

	_posY = _posY + ROW_H;
	_IDCs pushBack (CTRL_IDC_START + _forEachIndex);
} forEach _controls;

uiNamespace setVariable ["SSS_CDS_controls",_IDCs];
ctrlSetFocus _OK;

// Init all onValueChanged functions
{
	private _ctrl = _display displayCtrl _x;
	private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
	private _currentValue = switch (_ctrlInfo # 0) do {
		case "CHECKBOX";
		case "EDITBOX" : {
			_ctrlInfo # 2
		};
		case "SLIDER";
		case "COMBOBOX" : {
			(_ctrlInfo # 2) # 1
		};
	};
	[_currentValue,_customArguments,_ctrl] call (_ctrlInfo # 3);
	false
} count _IDCs;

// Handle enableConditions
SSS_CDS_EFID = addMissionEventHandler ["EachFrame",{
	disableSerialization;
	private _display = findDisplay DISPLAY_IDD;

	{
		private _ctrl = _display displayCtrl _x;
		private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";
		private _currentValue = switch (_ctrlInfo # 0) do {
			case "CHECKBOX";
			case "EDITBOX" : {
				_ctrlInfo # 2
			};
			case "SLIDER";
			case "COMBOBOX" : {
				(_ctrlInfo # 2) # 1
			};
		};
		private _enableCtrl = [_currentValue,uiNamespace getVariable "SSS_CDS_customArguments",_ctrl] call (_ctrlInfo # 4);

		if (!_enableCtrl && ctrlEnabled _ctrl) then {
			_ctrl ctrlEnable false;
			_display displayCtrl (_ctrl getVariable "SSS_CDS_descriptionIDC") ctrlSetTextColor [COLOR_DISABLED];
			if (_ctrlInfo # 0 == "SLIDER") then {ctrlEnable [_ctrl getVariable "SSS_CDS_auxIDC",false];};
		};
		if (_enableCtrl && !ctrlEnabled _ctrl) then {
			_ctrl ctrlEnable true;
			_display displayCtrl (_ctrl getVariable "SSS_CDS_descriptionIDC") ctrlSetTextColor [1,1,1,1];
			if (_ctrlInfo # 0 == "SLIDER") then {ctrlEnable [_ctrl getVariable "SSS_CDS_auxIDC",true];};
		};

		false
	} count (uiNamespace getVariable "SSS_CDS_controls");
}];

// Handle ESC key
_display displayAddEventHandler ["KeyDown",{
	if (_this # 1 == DIK_ESCAPE) then {call SSS_CDS_fnc_cancel;};
	false
}];
