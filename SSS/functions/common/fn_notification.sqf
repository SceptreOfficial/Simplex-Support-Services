#include "script_component.hpp"
/*
	Function: SSS_fnc_notification

	Authors: Sceptre
	Creates a notification on top of a stacked notification system.

	Parameters:
	0: Title <STRING>
	1: Content <STRING>

	Returns:
	Nothing
*/
#include "\a3\ui_f\hpp\defineCommonGrids.inc"

#define POS_X (safezoneX + 1 * GUI_GRID_W)
#define POS_Y (safezoneY + 14 * GUI_GRID_H)
#define WIDTH (16 * GUI_GRID_W)
#define TITLE_H (1 * GUI_GRID_H)
#define CONTENT_H (2 * GUI_GRID_H)
#define GAP_H (0.05 * GUI_GRID_H)
#define SLOT_H ((0.25 * GUI_GRID_H) + TITLE_H + GAP_H + CONTENT_H)
#define SLOT_LIMIT 6
#define TIME_DURATION 5
#define TIME_FADE_IN 0.3
#define TIME_FADE_OUT 3
#define TIME_CLEAR_SLOT 0.2
#define TIME_PUSH_SLOT 0.2

disableSerialization;
params [["_title","",[""]],["_content","",[""]]];

if (canSuspend) exitWith {[SSS_fnc_notification,_this] call CBA_fnc_directCall;};

if (isNil "SSS_notificationLayers") then {
	SSS_notificationLayers = [];
	SSS_notifications = [];
};

// Push down notifications and clear slots
if !(SSS_notifications isEqualTo []) then {
	private _cleared = [];
	{
		_x params ["_ctrlTitle","_ctrlContent"];
		private _slotIndex = (_ctrlTitle getVariable ["SSS_slotIndex",0]) + 1;
		_ctrlTitle setVariable ["SSS_slotIndex",_slotIndex];

		if (_slotIndex >= SLOT_LIMIT) then {
			{
				_x ctrlSetFade 1;
				_x ctrlCommit TIME_CLEAR_SLOT;
			} forEach _x;
			_cleared pushBack _x;
		} else {
			private _posY = POS_Y + _slotIndex * SLOT_H;
			_ctrlTitle ctrlSetPosition [POS_X,_posY,WIDTH,TITLE_H];
			_ctrlTitle ctrlCommit TIME_PUSH_SLOT;
			_ctrlContent ctrlSetPosition [POS_X,_posY + TITLE_H + GAP_H,WIDTH,CONTENT_H];
			_ctrlContent ctrlCommit TIME_PUSH_SLOT;
		};
	} forEach SSS_notifications;
	SSS_notifications = SSS_notifications - _cleared;
};

// Get a unique layer name
private "_layerName";
private _int = 1;
while {true} do {
	if (SSS_notificationLayers find (format ["SSS_notification_%1",_int]) isEqualTo -1) exitWith {
		_layerName = format ["SSS_notification_%1",_int];
	};
	_int = _int + 1;
};

SSS_notificationLayers pushBack _layerName;

// Create display
_layerName cutRsc ["RscTitleDisplayEmpty","PLAIN",0,true];
private _display = uiNamespace getVariable "RscTitleDisplayEmpty";
(_display displayCtrl 1202) ctrlShow false;

private _ctrlTitle = _display ctrlCreate ["RscStructuredText",-1];
_ctrlTitle ctrlSetStructuredText parseText _title;
_ctrlTitle ctrlSetBackgroundColor [0,0,0,0.4];
_ctrlTitle ctrlSetPosition [POS_X,POS_Y,WIDTH,TITLE_H];
_ctrlTitle ctrlCommit 0;

private _ctrlContent = _display ctrlCreate ["RscStructuredText",-1];
_ctrlContent ctrlSetStructuredText parseText _content;
_ctrlContent ctrlSetBackgroundColor [0,0,0,0.3];
_ctrlContent ctrlSetPosition [POS_X,POS_Y + TITLE_H + GAP_H,WIDTH,CONTENT_H];
_ctrlContent ctrlCommit 0;

private _controls = [_ctrlTitle,_ctrlContent];
SSS_notifications pushBack _controls;

// Fade in
{
	_x ctrlSetFade 1;
	_x ctrlCommit 0;
	_x ctrlSetFade 0;
	_x ctrlCommit TIME_FADE_IN;
} forEach _controls;

// Fade out and remove
[{
	params ["_layerName","_controls"];

	{
		_x ctrlSetFade 1;
		_x ctrlCommit TIME_FADE_OUT;
	} forEach _controls;

	[{
		SSS_notificationLayers deleteAt (SSS_notificationLayers find _this);
		_this cutFadeout 0;
	},_layerName,TIME_FADE_OUT] call CBA_fnc_waitAndExecute;
},[_layerName,_controls],TIME_DURATION] call CBA_fnc_waitAndExecute;

nil
