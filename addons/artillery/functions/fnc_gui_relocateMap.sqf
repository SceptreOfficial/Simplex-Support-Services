#include "script_component.hpp"

params ["_ctrlMap","_value"];

if (GVAR(manualInput) || _ctrlMap getVariable [QGVAR(viaGrid),false]) exitWith {
	_ctrlMap setVariable [QGVAR(viaGrid),nil];
};

private _display = ctrlParent _ctrlMap;
private _ctrlRelocateGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_RELOCATE_GROUP;

private _posASL = AGLtoASL (_value param [0,[0,0,0]]);
GVAR(relocatePosASL) = _posASL;

[_posASL] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

(_ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_E) ctrlSetText _easting;
(_ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_N) ctrlSetText _northing;

call FUNC(gui_verify);
