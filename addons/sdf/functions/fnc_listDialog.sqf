#include "..\script_component.hpp"
/*
	Authors: Sceptre + ideas from Zeus Enhanced by mharis001

	Parameters:
	0: Title <STRING>
	1: Content <ARRAY>
		[
			0: Control type <STRING>
			1: Description <STRING,ARRAY>
			2: Value data
			3: Force default value (Optional, default: true) <BOOL>
			4: 'onValueChanged' (Optional, default: {}) <CODE>
				0: _currentValue <BOOL,SCALAR,STRING>
				1: _customArguments <ANY>
				2: _ctrl <CONTROL>
			5: Enable Condition (Optional, default: {true}) <CODE>
				0: _currentValue <BOOL,SCALAR,STRING>
				1: _customArguments <ANY>
				2: _ctrl <CONTROL>
		]
	2: Close code (Optional, default: {}) <CODE,ARRAY>
		0: _onConfirm <CODE>
		1: _onCancel <CODE>
	3: Custom arguments (Optional, default: []) <ANY>

	Returns:
	Dialog created <BOOL>
*/
disableSerialization;
params [
	["_title","",[""]],
	["_content",[],[[]]],
	["_onClose",{},[{},[]]],
	["_arguments",[]]
];

if (!isNull (uiNamespace getVariable [QGVAR(parent),displayNull])) exitWith {false};

GVAR(exit) = false;
GVAR(cache) = GVAR(listCache);

_onClose params [["_onConfirm",{},[{}]],["_onCancel",{},[{}]]];

uiNamespace setVariable [QGVAR(title),_title];
uiNamespace setVariable [QGVAR(onConfirm),_onConfirm];
uiNamespace setVariable [QGVAR(onCancel),_onCancel];
uiNamespace setVariable [QGVAR(arguments),_arguments];

private _zeusDisplay = findDisplay IDD_RSCDISPLAYCURATOR;

if (!isNull _zeusDisplay && visibleMap) then {
	private _parent = _zeusDisplay ctrlCreate [QGVAR(dialog_zeus),-1];
	ctrlSetFocus _parent;

	[
		(safezoneWAbs / 2) - (CONTENT_W / 2),
		_zeusDisplay,
		_parent,
		_parent controlsGroupCtrl 1,
		_parent controlsGroupCtrl 2,
		_parent controlsGroupCtrl 3,
		_parent controlsGroupCtrl 4,
		_parent controlsGroupCtrl 5
	]
} else {
	createDialog QGVAR(dialog);
	private _parent = uiNamespace getVariable QGVAR(parent);

	[
		(safezoneXAbs + (safezoneWAbs / 2)) - (CONTENT_W / 2),
		_parent,
		_parent,
		_parent displayCtrl 1,
		_parent displayCtrl 2,
		_parent displayCtrl 3,
		_parent displayCtrl 4,
		_parent displayCtrl 5
	]
} params ["_posX","_display","_parent","_ctrlBG","_ctrlTitle","_ctrlGroup","_ctrlCancel","_ctrlConfirm"];

private _controls = [];
private _posY = 0;

// Dummy control because listNbox makes first control disappear for some reason
private _dummy = _display ctrlCreate ["RscText",-1,_ctrlGroup];
_dummy ctrlSetPosition [0,0,0,0];
_dummy ctrlCommit 0;

// Initialize content
{[0,_x] call FUNC(initialize)} forEach _content;
uiNamespace setVariable [QGVAR(controls),_controls];

// Init all onValueChanged functions
{
	if (GVAR(skipOnValueChanged)) then {continue};
	[_x getVariable QGVAR(value),_arguments,_x] call (_x getVariable QGVAR(onValueChanged))
} forEach _controls;

if (GVAR(exit)) exitWith {};

// Handle enable conditions
GVAR(PFHID) = [FUNC(enablePFH),0,_parent] call CBA_fnc_addPerFrameHandler;

// Update positions
private _contentHeight = MIN_H max (_posY - SPACING_H) min MAX_H;
private _contentY = if (_parent isEqualType displayNull) then {
	(safezoneY + (safezoneH / 2)) - (_contentHeight / 2)
} else {
	(safezoneH / 2) - (_contentHeight / 2)
};

_ctrlBG ctrlSetPosition [_posX - BUFFER_W,_contentY - BUFFER_H - SPACING_H,CONTENT_W + (BUFFER_W * 2),_contentHeight + (BUFFER_H * 2) + (SPACING_H * 2)];
_ctrlBG ctrlCommit 0;
_ctrlTitle ctrlSetPosition [_posX - BUFFER_W,_contentY - BUFFER_H - SPACING_H - LEG_TITLE_H,CONTENT_W + (BUFFER_W * 2),LEG_TITLE_H];
_ctrlTitle ctrlCommit 0;
_ctrlGroup ctrlSetPosition [_posX,_contentY,CONTENT_W + BUFFER_H,_contentHeight];
_ctrlGroup ctrlCommit 0;
_ctrlCancel ctrlSetPosition [_posX - BUFFER_W,_contentY + _contentHeight + BUFFER_H + SPACING_H,MENU_BUTTON_W,MENU_BUTTON_H];
_ctrlCancel ctrlCommit 0;
_ctrlConfirm ctrlSetPosition [_posX + CONTENT_W - MENU_BUTTON_W + BUFFER_W,_contentY + _contentHeight + BUFFER_H + SPACING_H,MENU_BUTTON_W,MENU_BUTTON_H];
_ctrlConfirm ctrlCommit 0;

// Set title and focus
_ctrlTitle ctrlSetText _title;
ctrlSetFocus _ctrlConfirm;

// Handle key presses
GVAR(shiftKey) = false;

GVAR(keyUpEHID) = [_display,"KeyUp",{
	private _key = _this # 1;
	if (_key in [DIK_LSHIFT,DIK_RSHIFT]) then {GVAR(shiftKey) = false};
}] call CBA_fnc_addBISEventHandler;

GVAR(keyDownEHID) = [_display,"KeyDown",{
	private _key = _this # 1;

	if (_key in [DIK_LSHIFT,DIK_RSHIFT]) then {GVAR(shiftKey) = true};
	if (_key in [DIK_UP,DIK_DOWN,DIK_LEFT,DIK_RIGHT]) exitWith {false};
	if (_key == DIK_ESCAPE) then {[uiNamespace getVariable QGVAR(onCancel),false] call FUNC(close)};
	if (!isNull findDisplay IDD_RSCDISPLAYCURATOR && visibleMap) exitWith {
		private _ctrl = uiNamespace getVariable [QGVAR(editFocus),controlNull];

		if (isNull _ctrl) exitWith {true};

		if (_key == DIK_HOME) then {_ctrl ctrlSetTextSelection [0,0]};
		if (_key == DIK_END) then {_ctrl ctrlSetTextSelection [count ctrlText _ctrl,0]};
		if (_key in [DIK_BACKSPACE,DIK_DELETE]) then {
			private _text = toArray ctrlText _ctrl;

			ctrlTextSelection _ctrl params ["_start","_length","_selectedText"];

			if (_length != 0) exitWith {
				_start = [_start,_start + _length] select (_length < 0);
				_text deleteRange [_start,abs _length];
				_ctrl ctrlSetText toString _text;
				_ctrl ctrlSetTextSelection [_start,0];
			};

			if (_key == DIK_BACKSPACE) then {
				_text deleteAt (_start - 1);
				_ctrl ctrlSetText toString _text;
				_ctrl ctrlSetTextSelection [_start - 1,0];
			};

			if (_key == DIK_DELETE) then {
				_text deleteAt _start;
				_ctrl ctrlSetText toString _text;
			};
		};

		true
	};

	false
}] call CBA_fnc_addBISEventHandler;

[CBA_fnc_localEvent,[QGVAR(opened),[_title,_content,_onClose,_arguments]]] call CBA_fnc_execNextFrame;

true
