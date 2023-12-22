#include "script_component.hpp"
/*
	Authors: Sceptre

	Parameters:
	0: Dialog size [w,h] <ARRAY>
	1: Content <ARRAY>
		[
			0: Position [x,y,w,h] <ARRAY>
			1: Control type <STRING>
			2: Description <STRING,ARRAY>
			3: Value data
			4: Force default value (Optional, default: true) <BOOL>
			5: 'onValueChanged' (Optional, default: {}) <CODE>
				Arguments:
				0: _currentValue <BOOL,SCALAR,STRING>
				1: _customArguments <ANY>
				2: _ctrl <CONTROL>
			6: Enable Condition (Optional, default: {true}) <CODE>
				Arguments:
				0: _currentValue <BOOL,SCALAR,STRING>
				1: _customArguments <ANY>
				2: _ctrl <CONTROL>
		]
	2: 'Escape' close code (Optional, default: {}) <CODE>
	3: Custom arguments (Optional, default: []) <ANY>

	Returns:
	Dialog created <BOOL>
*/
disableSerialization;
params [
	["_dialogSize",[10,10],[[]],2],
	["_content",[],[[]]],
	["_onEsc",{},[{}]],
	["_arguments",[]]
];

if (!isNull (uiNamespace getVariable [QGVAR(parent),displayNull])) exitWith {false};

GVAR(exit) = false;
GVAR(cache) = GVAR(gridCache);

uiNamespace setVariable [QGVAR(title),""];
uiNamespace setVariable [QGVAR(onEsc),_onEsc];
uiNamespace setVariable [QGVAR(arguments),_arguments];

createDialog QGVAR(gridDialog);

private _display = uiNamespace getVariable QGVAR(parent);
private _ctrlBG = _display displayCtrl 1;
private _ctrlGroup = _display displayCtrl 2;
private _controls = [];

_dialogSize params ["_sizeW","_sizeH"];
private _posX = ((safezoneXAbs + (safezoneWAbs / 2)) - (GD_W(_sizeW) / 2)) max safeZoneX;
private _posY = ((safezoneY + (safezoneH / 2)) - (GD_H(_sizeH) / 2)) max safeZoneY;

// Dummy control because listNbox makes first control disappear for some reason
private _dummy = _display ctrlCreate ["RscText",-1,_ctrlGroup];
_dummy ctrlSetPosition [0,0,0,0];
_dummy ctrlCommit 0;

// Initialize content
{[1,_x] call FUNC(initialize)} forEach _content;
uiNamespace setVariable [QGVAR(controls),_controls];

// Init all onValueChanged functions
{
	if (GVAR(skipOnValueChanged)) then {continue};
	[_x getVariable QGVAR(value),_arguments,_x] call (_x getVariable QGVAR(onValueChanged))
} forEach _controls;

if (GVAR(exit)) exitWith {};

// Handle enable conditions
GVAR(PFHID) = [FUNC(enablePFH),0,_display] call CBA_fnc_addPerFrameHandler;

// Update positions
_ctrlBG ctrlSetPosition [_posX - (BUFFER_W / 2),_posY - (BUFFER_H / 2),GD_W(_sizeW) + BUFFER_W,GD_H(_sizeH) + BUFFER_H];
_ctrlBG ctrlCommit 0;
_ctrlGroup ctrlSetPosition [_posX,_posY,GD_W(_sizeW) + BUFFER_W,GD_H(_sizeH)];
_ctrlGroup ctrlCommit 0;

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
	if (_key == DIK_ESCAPE) then {(uiNamespace getVariable QGVAR(onEsc)) call FUNC(close)};
	
	false
}] call CBA_fnc_addBISEventHandler;

[CBA_fnc_localEvent,[QGVAR(opened),[_dialogSize,_content,_onEsc,_arguments]]] call CBA_fnc_execNextFrame;

true
