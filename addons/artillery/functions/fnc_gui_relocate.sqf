#include "..\script_component.hpp"

params ["_ctrl"];

private _display = ctrlParent _ctrl;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlRelocateGroup = _ctrlGroup controlsGroupCtrl IDC_RELOCATE_GROUP;
private _ctrlE = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_E;
private _ctrlN = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_N;

private _easting = ctrlText _ctrlE;
private _northing = ctrlText _ctrlN;

PVAR(guiEntity) setVariable [QGVAR(relocateCache),[_easting,_northing]];

[
	call CBA_fnc_currentUnit,
	PVAR(guiEntity),
	"RELOCATE",
	[AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid))]
] call FUNC(request);

