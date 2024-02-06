#include "..\script_component.hpp"

params ["_ctrlMap","_value"];

if (GVAR(manualInput) || _ctrlMap getVariable [QGVAR(viaGrid),false]) exitWith {
	_ctrlMap setVariable [QGVAR(viaGrid),nil];
};

private _display = ctrlParent _ctrlMap;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;

private _posASL = call FUNC(gui_getPos);

GVAR(request) set ["posASL",_posASL];

[QGVAR(guiPosUpdated),[_display,_posASL]] call CBA_fnc_localEvent;

[_posASL] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

(_ctrlGroup controlsGroupCtrl IDC_GRID_E) ctrlSetText _easting;
(_ctrlGroup controlsGroupCtrl IDC_GRID_N) ctrlSetText _northing;	

call FUNC(gui_verify);
