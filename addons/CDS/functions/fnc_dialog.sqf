#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre + ideas from Zeus Enhanced by mharis001
Creates a dialog with defined control types.

Parameters:
0: Title <STRING>
1: Content <ARRAY>
	[
		0: Control type <STRING>
		1: Description <STRING,ARRAY>
		2: Value data <ARRAY>
		3: Force default value <BOOL>
		4: 'onValueChanged' <CODE>
			0: _currentValue <BOOL,SCALAR,STRING>
			1: _customArguments <ANY>
			2: _ctrl <CONTROL>
		5: 'enableCondition' <CODE>
			0: _currentValue <BOOL,SCALAR,STRING>
			1: _customArguments <ANY>
			2: _ctrl <CONTROL>
	]
2: 'onConfirm' <CODE>
	1: _controlValues <ARRAY>
	2: _customArguments <ANY>
3: 'onCancel' <CODE>
	1: _controlValues <ARRAY>
	2: _customArguments <ANY>
4: Custom arguments <ANY>

Returns:
Dialog created <BOOL> 
//-----------------------------------------------------------------------------------------------*/
#define CREATE_DESCRIPTION \
	private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup]; \
	_ctrlDescription ctrlSetPosition [0,_posY,DESCRIPTION_WIDTH,ITEM_HEIGHT]; \
	_ctrlDescription ctrlCommit 0; \
	_ctrlDescription ctrlSetText _descriptionText; \
	_ctrlDescription ctrlSetTooltip _descriptionTooltip

disableSerialization;
params [
	["_title","",[""]],
	["_content",[],[[]]],
	["_onConfirm",{},[{}]],
	["_onCancel",{},[{}]],
	["_arguments",[]]
];

if (!isNull (uiNamespace getVariable QGVAR(display))) exitWith {false};

if (isNil QGVAR(cache)) then {
	GVAR(cache) = [] call CBA_fnc_createNamespace;
};

createDialog QGVAR(Dialog);

private _display = uiNamespace getVariable QGVAR(display);
uiNamespace setVariable [QGVAR(title),_title];
uiNamespace setVariable [QGVAR(onConfirm),_onConfirm];
uiNamespace setVariable [QGVAR(onCancel),_onCancel];
uiNamespace setVariable [QGVAR(arguments),_arguments];

private _ctrlBG = _display displayCtrl 1;
private _ctrlTitle = _display displayCtrl 2;
private _ctrlGroup = _display displayCtrl 3;
private _ctrlCancel = _display displayCtrl 4;
private _ctrlConfirm = _display displayCtrl 5;
private _controls = [];
private _posY = 0;

// because listNbox makes first control disappear for some reason
private _dummy = _display ctrlCreate ["RscText",-1,_ctrlGroup];
_dummy ctrlSetPosition [0,0,0,0];
_dummy ctrlCommit 0;

{
	_x params [
		["_type","",[""]],
		["_description","",["",[]]],
		["_valueData",[],[true,"",[],{}]],
		["_forceDefault",true,[true]],
		["_onValueChanged",{},[{}]],
		["_enableCondition",{true},[{},true]]
	];

	if (_enableCondition isEqualType true) then {
		_enableCondition = [{false},{true}] select _enableCondition;
	};

	_description params [["_descriptionText","",[""]],["_descriptionTooltip","",[""]]];
	_description = [_descriptionText,_descriptionTooltip];

	switch (toUpper _type) do {
		case "CHECKBOX" : {
			_valueData params [["_bool",true,[true]]];

			CREATE_DESCRIPTION;

			if (!_forceDefault) then {
				_bool = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_bool];
			};

			private _ctrl = _display ctrlCreate [QGVAR(Checkbox),-1,_ctrlGroup];
			_ctrl ctrlSetPosition [CONTROL_X + SPACING,_posY];
			_ctrl ctrlCommit 0;
			_ctrl cbSetChecked _bool;
			
			_ctrl setVariable [QGVAR(data),[_type,_description,_bool,_onValueChanged,_enableCondition]];
			_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
			_controls pushBack _ctrl;

			[_ctrl,"CheckedChanged",{
				params ["_ctrl","_bool"];
				_bool = _bool isEqualTo 1;

				private _data = _ctrl getVariable QGVAR(data);
				_data set [2,_bool];
				_ctrl setVariable [QGVAR(data),_data];
				[_bool,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_data # 3);
			}] call CBA_fnc_addBISEventHandler;

			_posY = _posY + ITEM_HEIGHT + SPACING;
		};

		case "EDITBOX" : {
			_valueData params [["_string","",[""]]];

			CREATE_DESCRIPTION;

			if (!_forceDefault) then {
				_string = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_string];
			};

			private _ctrl = _display ctrlCreate [QGVAR(Editbox),-1,_ctrlGroup];
			_ctrl ctrlSetPosition [CONTROL_X,_posY];
			_ctrl ctrlCommit 0;
			_ctrl ctrlSetText _string;
			
			_ctrl setVariable [QGVAR(data),[_type,_description,_string,_onValueChanged,_enableCondition]];
			_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
			_controls pushBack _ctrl;

			[_ctrl,"KeyUp",{
				params ["_ctrl","_key"];

				private _string = ctrlText _ctrl;
				private _data = _ctrl getVariable QGVAR(data);
				_data set [2,_string];
				_ctrl setVariable [QGVAR(data),_data];
				[_string,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_data # 3);
			}] call CBA_fnc_addBISEventHandler;

			_posY = _posY + ITEM_HEIGHT + SPACING;
		};

		case "SLIDER" : {
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
			_ctrlEdit ctrlSetPosition [CONTROL_X + SLIDER_WIDTH + SPACING,_posY];
			_ctrlEdit ctrlCommit 0;
			_ctrlEdit ctrlSetText _sliderPosStr;

			_ctrl setVariable [QGVAR(data),[_type,_description,[[_min,_max,_decimals],sliderPosition _ctrl],_onValueChanged,_enableCondition]];
			_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
			_controls pushBack _ctrl;

			_ctrl setVariable [QGVAR(ctrlEdit),_ctrlEdit];
			_ctrlEdit setVariable [QGVAR(slider),_ctrl];

			[_ctrl,"SliderPosChanged",{
				params ["_ctrl","_sliderPos"];

				private _data = _ctrl getVariable QGVAR(data);
				((_data # 2) # 0) params ["_min","_max","_decimals"];

				private _sliderPosStr = _sliderPos toFixed _decimals;
				_sliderPos = parseNumber _sliderPosStr;

				private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
				_ctrlEdit ctrlSetText _sliderPosStr;

				(_data select 2) set [1,_sliderPos];
				_ctrl setVariable [QGVAR(data),_data];
				[_sliderPos,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_data # 3);
			}] call CBA_fnc_addBISEventHandler;

			[_ctrlEdit,"KeyUp",{
				params ["_ctrlEdit"];

				private _ctrl = _ctrlEdit getVariable QGVAR(slider);
				private _data = _ctrl getVariable QGVAR(data);
				((_data # 2) # 0) params ["_min","_max","_decimals"];

				private _value = parseNumber ctrlText _ctrlEdit;
				_ctrl sliderSetPosition _value;
				_value = sliderPosition _ctrl;

				(_data select 2) set [1,_value];
				_ctrl setVariable [QGVAR(data),_data];
				[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_data # 3);
			}] call CBA_fnc_addBISEventHandler;

			[_ctrlEdit,"KillFocus",{
				params ["_ctrlEdit"];

				private _ctrl = _ctrlEdit getVariable QGVAR(slider);
				private _data = _ctrl getVariable QGVAR(data);
				((_data # 2) # 0) params ["_min","_max","_decimals"];

				_ctrlEdit ctrlSetText (sliderPosition _ctrl toFixed _decimals);
			}] call CBA_fnc_addBISEventHandler;

			_posY = _posY + ITEM_HEIGHT + SPACING;
		};

		case "COMBOBOX" : {
			_valueData params [["_items",[],[[]]],["_selection",0,[0]]];

			CREATE_DESCRIPTION;

			if (!_forceDefault) then {
				_selection = GVAR(cache) getVariable [[_title,_description,_type,_items] joinString "~",_selection];
			};

			private _ctrl = _display ctrlCreate [QGVAR(Combobox),-1,_ctrlGroup];
			_ctrl ctrlSetPosition [CONTROL_X,_posY];
			_ctrl ctrlCommit 0;

			{
				_x params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

				private _index = _ctrl lbAdd _text;
				_ctrl lbSetTooltip [_index,_tooltip];
				_ctrl lbSetPicture [_index,_icon];
				_ctrl lbSetColor [_index,_RGBA];
			} forEach _items;

			_ctrl lbSetCurSel _selection;
			_ctrl setVariable [QGVAR(data),[_type,_description,[_items,lbCurSel _ctrl],_onValueChanged,_enableCondition]];
			_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
			_controls pushBack _ctrl;

			[_ctrl,"LBSelChanged",{
				params ["_ctrl","_selection"];

				private _data = _ctrl getVariable QGVAR(data);
				(_data select 2) set [1,_selection];
				_ctrl setVariable [QGVAR(data),_data];
				[_selection,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_data # 3);
			}] call CBA_fnc_addBISEventHandler;

			_posY = _posY + ITEM_HEIGHT + SPACING;
		};

		case "LISTNBOX" : {
			_valueData params [["_rows",[],[[]]],["_selection",0,[0]],["_height",1,[0]]];
			_height = ITEM_HEIGHT * ((round _height) max 1);

			private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
			_ctrlDescription ctrlSetPosition [0,_posY,LISTNBOX_WIDTH,ITEM_HEIGHT];
			_ctrlDescription ctrlCommit 0;
			_ctrlDescription ctrlSetText _descriptionText;
			_ctrlDescription ctrlSetTooltip _descriptionTooltip;

			if (!_forceDefault) then {
				_selection = GVAR(cache) getVariable [[_title,_description,_type,_rows] joinString "~",_selection];
			};

			private _ctrlBG = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
			_ctrlBG ctrlSetPosition [0,_posY + ITEM_HEIGHT + SPACING,LISTNBOX_WIDTH,_height];
			_ctrlBG ctrlCommit 0;

			private _ctrl = _display ctrlCreate [QGVAR(ListNBox),-1,_ctrlGroup];
			_ctrl ctrlSetPosition [0,_posY + ITEM_HEIGHT + SPACING,LISTNBOX_WIDTH,_height];
			_ctrl ctrlCommit 0;

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
			_ctrl setVariable [QGVAR(data),[_type,_description,[_rows,lnbCurSelRow _ctrl,_height],_onValueChanged,_enableCondition]];
			_ctrl setVariable [QGVAR(ctrlDescription),_ctrlDescription];
			_ctrl setVariable [QGVAR(ctrlBG),_ctrlBG];
			_controls pushBack _ctrl;

			[_ctrl,"LBSelChanged",{
				params ["_ctrl","_selection"];

				private _data = _ctrl getVariable QGVAR(data);
				(_data select 2) set [1,_selection];
				_ctrl setVariable [QGVAR(data),_data];
				[_selection,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_data # 3);
			}] call CBA_fnc_addBISEventHandler;

			_posY = _posY + ITEM_HEIGHT + SPACING + _height + SPACING;
		};

		case "BUTTON" : {
			_valueData params [["_code",{},[{},""]]];

			if (_code isEqualType "") then {
				_code = compile _code;
			};

			if (!_forceDefault) then {
				_code = GVAR(cache) getVariable [[_title,_description,_type] joinString "~",_code];
			};

			private _ctrl = _display ctrlCreate [QGVAR(Button),-1,_ctrlGroup];
			_ctrl ctrlSetPosition [0,_posY];
			_ctrl ctrlCommit 0;
			_ctrl ctrlSetText _descriptionText;
			_ctrl ctrlSetTooltip _descriptionTooltip;
			
			_ctrl setVariable [QGVAR(data),[_type,_description,_code,_onValueChanged,_enableCondition]];
			_ctrl setVariable [QGVAR(ctrlDescription),_ctrl];
			_controls pushBack _ctrl;

			[_ctrl,"ButtonClick",{
				params ["_ctrl"];

				[(_ctrl getVariable QGVAR(data)) # 2,uiNamespace getVariable QGVAR(arguments)] call CBA_fnc_directCall;
			}] call CBA_fnc_addBISEventHandler;

			_posY = _posY + ITEM_HEIGHT + SPACING;
		};
	};
} forEach _content;

uiNamespace setVariable [QGVAR(controls),_controls];

// Init all onValueChanged functions
{
	private _data = _x getVariable QGVAR(data);
	private _value = switch (_data # 0) do {
		case "CHECKBOX";
		case "EDITBOX" : {_data # 2};
		case "SLIDER";
		case "COMBOBOX";
		case "LISTNBOX" : {_data # 2 # 1};
	};

	[_value,_arguments,_x] call (_data # 3);
} forEach _controls;

// Handle enableConditions
GVAR(PFHID) = [{
	disableSerialization;
	params ["_display","_PFHID"];

	if (isNull _display) exitWith {
		_PFHID call CBA_fnc_removePerFrameHandler;
	};

	{
		_x params ["_ctrl"];

		private _data = _ctrl getVariable QGVAR(data);
		private _value = switch (_data # 0) do {
			case "CHECKBOX";
			case "EDITBOX" : {_data # 2};
			case "SLIDER";
			case "COMBOBOX";
			case "LISTNBOX" : {_data # 2 # 1};
		};

		private _enableCtrl = [_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_data # 4);
		private _ctrlDescription = _ctrl getVariable [QGVAR(ctrlDescription),controlNull];

		if (!_enableCtrl && ctrlEnabled _ctrl) then {
			_ctrl ctrlEnable false;

			if (!isNull _ctrlDescription) then {
				_ctrlDescription ctrlSetTextColor [COLOR_DISABLED];
			};
			
			if (_data # 0 == "SLIDER") then {
				(_ctrl getVariable QGVAR(ctrlEdit)) ctrlEnable false;
			};
		};

		if (_enableCtrl && !ctrlEnabled _ctrl) then {
			_ctrl ctrlEnable true;

			if (!isNull _ctrlDescription) then {
				_ctrlDescription ctrlSetTextColor [1,1,1,1];
			};

			if (_data # 0 == "SLIDER") then {
				(_ctrl getVariable QGVAR(ctrlEdit)) ctrlEnable true;
			};
		};
	} forEach (uiNamespace getVariable QGVAR(controls));
},0,_display] call CBA_fnc_addPerFrameHandler;

// Update positions
private _contentHeight = MIN_HEIGHT max (_posY - SPACING) min MAX_HEIGHT;
private _contentX = (1 - _contentHeight) / 2;

_ctrlBG ctrlSetPosition [POS_X - BUFFER,_contentX - BUFFER,CONTENT_WIDTH + (BUFFER * 2),_contentHeight + (BUFFER * 2)];
_ctrlBG ctrlCommit 0;
_ctrlTitle ctrlSetPosition [POS_X - BUFFER,_contentX - BUFFER - SPACING - TITLE_HEIGHT,CONTENT_WIDTH + (BUFFER * 2),TITLE_HEIGHT];
_ctrlTitle ctrlCommit 0;
_ctrlGroup ctrlSetPosition [POS_X,_contentX,CONTENT_WIDTH + BUFFER,_contentHeight];
_ctrlGroup ctrlCommit 0;
_ctrlCancel ctrlSetPosition [POS_X - BUFFER,_contentX + _contentHeight + BUFFER + SPACING,MENU_BUTTON_WIDTH,MENU_BUTTON_HEIGHT];
_ctrlCancel ctrlCommit 0;
_ctrlConfirm ctrlSetPosition [POS_X + CONTENT_WIDTH - MENU_BUTTON_WIDTH + BUFFER,_contentX + _contentHeight + BUFFER + SPACING,MENU_BUTTON_WIDTH,MENU_BUTTON_HEIGHT];
_ctrlConfirm ctrlCommit 0;

// Set title and focus
_ctrlTitle ctrlSetText _title;
ctrlSetFocus _ctrlConfirm;

// Handle ESC key
[_display,"KeyDown",{
	if (_this # 1 == DIK_ESCAPE) then {call FUNC(cancel);};
	false
}] call CBA_fnc_addBISEventHandler;

true
