#include "..\script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

disableSerialization;
params [["_text","",[""]]];

private _display = findDisplay IDD_RSCDISPLAYCURATOR;

private _parent = _display ctrlCreate ["RscControlsGroupNoScrollbars",-1];
_parent ctrlSetBackgroundColor [0,0,0,0];
_parent ctrlSetPosition [safeZoneXAbs,safeZoneY,safeZoneWAbs,safeZoneH];
_parent ctrlCommit 0;
ctrlSetFocus _parent;

private _container = _display ctrlCreate ["RscControlsGroupNoScrollbars",-1,_parent];
_container ctrlSetBackgroundColor [0,0,0,0];
_container ctrlSetPosition [0,0,safeZoneWAbs,safeZoneH];
_container ctrlCommit 0;

private _posX = (safezoneWAbs / 2) - 0.5;
private _posY = (safezoneH / 2) - 0.5;

private _editbox = _display ctrlCreate ["RscEditMulti",-1,_container];
_editbox ctrlSetBackgroundColor [0,0,0,1];
_editbox ctrlSetPosition [_posX,_posY,1,0.95];
_editbox ctrlCommit 0;
_editbox ctrlSetText _this;

private _closeButton = _display ctrlCreate ["RscButton",-1,_container];
_closeButton ctrlSetPosition [_posX,_posY + 0.955,1,0.045];
_closeButton ctrlCommit 0;
_closeButton ctrlSetText "CLOSE";

ctrlSetFocus _editbox;

GVAR(copyBoxKeyDownEHID) = [_display,"KeyDown",{
	if (_this # 1 == DIK_ESCAPE) then {
		(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler [_thisType,_thisID];
		ctrlDelete _thisArgs;
		true
	} else {
		false
	};
},_parent] call CBA_fnc_addBISEventHandler;

[_closeButton,"ButtonClick",{
	(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler ["KeyDown",GVAR(copyBoxKeyDownEHID)];
	ctrlDelete _thisArgs;
},_parent] call CBA_fnc_addBISEventHandler;
