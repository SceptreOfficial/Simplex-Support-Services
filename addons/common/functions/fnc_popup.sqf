#include "..\script_component.hpp"
#include "..\popup.hpp"

/*
	Authors: Sceptre
	Creates a new message on top of a stacked message system.

	Parameters:
	0: Title (~45 character limit) <STRING>
	1: Body (~90 character limit) <STRING>

	Returns:
	Nothing
*/

disableSerialization;
params [["_title","",[""]],["_body","",[""]]];

if (canSuspend) exitWith {[FUNC(popup),_this] call CBA_fnc_directCall;};
if (isNil QGVAR(popups)) then {GVAR(popups) = []};

// Push down and clear slots
if (GVAR(popups) isNotEqualTo []) then {	
	{
		if (isNull _x) then {
			GVAR(popups) deleteAt _forEachIndex;
		};

		private _ctrlTitle = _x displayCtrl IDC_POPUP_TITLE;
		private _ctrlBody = _x displayCtrl IDC_POPUP_BODY;
		private _index = (_x getVariable [QGVAR(popupIndex),0]) + 1;
		_x setVariable [QGVAR(popupIndex),_index];

		if (_index >= POPUP_LIMIT) then {
			{_x ctrlSetFade 1; _x ctrlCommit POPUP_CLEAR} forEach [_ctrlTitle,_ctrlBody];
			GVAR(popups) deleteAt _forEachIndex;
		} else {
			private _posY = (profileNamespace getVariable [QUOTE(TRIPLES(IGUI,GVAR(popupGrid),Y)),POPUP_Y]) + _index * POPUP_H;
			_ctrlTitle ctrlSetPositionY _posY;
			_ctrlTitle ctrlCommit POPUP_PUSH;
			_ctrlBody ctrlSetPositionY (_posY + POPUP_TITLE_H + POPUP_GAP_H);
			_ctrlBody ctrlCommit POPUP_PUSH;
		};
	} forEach +GVAR(popups);
};

str GEN_STR(CBA_missionTime) cutRsc [QGVAR(popup),"PLAIN",POPUP_FADE_IN,true,false];

private _display = uiNamespace getVariable [QGVAR(popup),displayNull];
private _ctrlTitle = _display displayCtrl IDC_POPUP_TITLE;
private _ctrlBody = _display displayCtrl IDC_POPUP_BODY;

_ctrlTitle ctrlSetStructuredText parseText _title;
_ctrlBody ctrlSetStructuredText parseText _body;

GVAR(popups) pushBack _display;

nil
