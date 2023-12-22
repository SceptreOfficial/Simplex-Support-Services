#include "script_component.hpp"

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlMap = _display displayCtrl IDC_MAP;
private _posASL = _ctrlMap getVariable [QGVAR(relocatePos),[]];

if (_posASL isEqualTo []) exitWith {
	if (_ctrlMap getVariable [QGVAR(relocateMapClick),false]) exitWith {};

	_ctrlMap setVariable [QEGVAR(sdf,override),true];
	_ctrlMap setVariable [QGVAR(relocateMapClick),true];
	_ctrlMap ctrlAddEventHandler ["MouseButtonUp",{
		params ["_ctrlMap","_button","_xPos","_yPos"];
		
		if (_button != 0) exitWith {};

		private _pos = _ctrlMap posScreenToWorld [_xPos,_yPos];

		_ctrlMap setVariable [QGVAR(relocatePos),AGLToASL _pos];
		_ctrlMap ctrlRemoveEventHandler [_thisEvent,_thisEventHandler];
		{call FUNC(gui_relocateMapSelect)} call CBA_fnc_execNextFrame;

		private _marker = createMarkerLocal [GEN_STR(_ctrlMap),_pos];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "mil_end_noShadow";
		_marker setMarkerColorLocal "ColorBlue";

		[{
			_this params ["_marker","_end"];
			private _alpha = 0 max ((_end - CBA_missionTime) / 2);
			_marker setMarkerAlphaLocal _alpha;
			_alpha <= 0
		},{deleteMarkerLocal (_this # 0)},[_marker,CBA_missionTime + 2]] call CBA_fnc_waitUntilAndExecute;
	}];
};

_ctrlMap setVariable [QEGVAR(sdf,override),GVAR(manualInput)];
_ctrlMap setVariable [QGVAR(relocatePos),nil];
_ctrlMap setVariable [QGVAR(relocateMapClick),nil];

GVAR(relocatePosASL) = _posASL;

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlRelocateGroup = _ctrlGroup controlsGroupCtrl IDC_RELOCATE_GROUP;
private _ctrlE = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_E;
private _ctrlN = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_N;

[_posASL] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

_ctrlE ctrlSetText _easting;
_ctrlN ctrlSetText _northing;

call FUNC(gui_verify);
