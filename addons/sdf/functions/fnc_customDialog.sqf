#include "script_component.hpp"

// _posX true to center based on width
// _posY true to center based on height

disableSerialization;

params [["_posX",true,[false,0]],["_posY",true,[false,0]],["_posW",20,[0]],["_posH",20,[0]],["_onClose",{},[{},[]]]];

if (!isNull (uiNamespace getVariable [QGVAR(parent),displayNull])) exitWith {[displayNull,controlNull,controlNull,controlNull,controlNull,controlNull]};

if (!createDialog QGVAR(CustomDialog)) exitWith {[displayNull,controlNull,controlNull,controlNull,controlNull,controlNull]};

_onClose params [["_onConfirm",{},[{}]],["_onCancel",{},[{}]]];

private _display = uiNamespace getVariable QGVAR(parent);
private _ctrlBG = _display displayCtrl 1;
private _ctrlTitle = _display displayCtrl 2;
private _ctrlGroup = _display displayCtrl 3;
private _ctrlCancel = _display displayCtrl 4;
private _ctrlConfirm = _display displayCtrl 5;

if (_posX isEqualType true) then {
	if (_posX) then {
		_posX = MAIN_X(_posW) max safeZoneX;
	} else {
		_posX = 0;
	};
};

if (_posY isEqualType true) then {
	if (_posY) then {
		_posY = MAIN_Y(_posH) max safeZoneY;
	} else {
		_posY = 0;
	};
};

_ctrlBG ctrlSetPosition [_posX - BUFFER_W,_posY - BUFFER_H,GD_W(_posW) + (BUFFER_W * 2),GD_H(_posH) + (BUFFER_H * 3.5)];
_ctrlBG ctrlCommit 0;
_ctrlTitle ctrlSetPosition [_posX - BUFFER_W,_posY - (BUFFER_H * 0.5) - GD_H(1),GD_W(_posW) + (BUFFER_W * 2),GD_H(1) - BUFFER_H];
_ctrlTitle ctrlCommit 0;
_ctrlGroup ctrlSetPosition [_posX,_posY,GD_W(_posW) + BUFFER_W,GD_H(_posH) + BUFFER_H];
_ctrlGroup ctrlCommit 0;
_ctrlCancel ctrlSetPosition [_posX - BUFFER_W,_posY + GD_H(_posH) + (BUFFER_H * 3),GD_W(5),GD_H(1)];
_ctrlCancel ctrlCommit 0;
_ctrlConfirm ctrlSetPosition [_posX + GD_W(_posW) + BUFFER_W - GD_W(5),_posY + GD_H(_posH) + (BUFFER_H * 3),GD_W(5),GD_H(1)];
_ctrlConfirm ctrlCommit 0;

// Dummy control because listNbox makes first control disappear for some reason
private _dummy = _display ctrlCreate ["RscText",-1,_ctrlGroup];
_dummy ctrlSetPosition [0,0,0,0];
_dummy ctrlCommit 0;

private _controls = [_display,_ctrlBG,_ctrlTitle,_ctrlGroup,_ctrlCancel,_ctrlConfirm];

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
	if (_key == DIK_ESCAPE) then {
		(_thisArgs # 0) call (_thisArgs # 1);
		closeDialog 0;
	};
	
	false
},[_controls,_onCancel]] call CBA_fnc_addBISEventHandler;

GVAR(cancelClickEHID) = [_ctrlCancel,"ButtonClick",{
	(_thisArgs # 0) call (_thisArgs # 1);
	closeDialog 0;
},[_controls,_onCancel]] call CBA_fnc_addBISEventHandler;

GVAR(confirmClickEHID) = [_ctrlConfirm,"ButtonClick",{
	(_thisArgs # 0) call (_thisArgs # 1);
	closeDialog 0;
},[_controls,_onConfirm]] call CBA_fnc_addBISEventHandler;

_controls
