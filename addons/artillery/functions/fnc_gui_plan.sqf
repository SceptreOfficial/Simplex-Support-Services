#include "..\script_component.hpp"

params ["_ctrlPlan","_index"];

GVAR(planIndex) = _index;

private _display = ctrlParent _ctrlPlan;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;

// Default task
(GVAR(plan) param [_index,[
	[[0,0,0],0,0,0,true],
	(PVAR(guiEntity) getVariable QPVAR(sheafTypes)) # 0,
	[],
	1,
	0,
	0
]]) params [
	"_area",
	"_sheaf",
	"_magazines",
	"_rounds",
	"_execDelay",
	"_firingDelay"
];

// Sheaf parameters
[
	_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_DISPERSION,
	_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_DISPERSION_EDIT,
	[0,500,0],
	_area # 1,
	FUNC(gui_dispersion)
] call EFUNC(sdf,manageSlider);

(_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_WIDTH) ctrlSetText str (_area # 1);
(_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_HEIGHT) ctrlSetText str (_area # 2);
(_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_ANGLE) ctrlSetText str (_area # 3);

// Grid
[_area # 0] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_E) ctrlSetText _easting;
(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_N) ctrlSetText _northing;

if (_sheaf in ["CONVERGED","PARALLEL","NONE"]) then {
	[_display displayCtrl IDC_MAP,[[[_area # 0]],[],[],0]] call EFUNC(sdf,setValueData);
} else {
	[_display displayCtrl IDC_MAP,[[],[_area],[],1]] call EFUNC(sdf,setValueData);
};

// Select sheaf
private _ctrlSheaf = _ctrlTaskGroup controlsGroupCtrl IDC_SHEAF;
_ctrlSheaf lbSetCurSel (_ctrlSheaf getVariable [_sheaf,0]);

// Select ammunition
private _ctrlAmmunition = _ctrlTaskGroup controlsGroupCtrl IDC_AMMUNITION;
{_ctrlAmmunition lbSetSelected [_forEachIndex,_x in _magazines]} forEach GVAR(magTypes);

// Rounds & delays
[
	_ctrlTaskGroup controlsGroupCtrl IDC_ROUNDS,
	_ctrlTaskGroup controlsGroupCtrl IDC_ROUNDS_EDIT,
	[1,GVAR(limits) get "rounds",0],
	_rounds,
	FUNC(gui_rounds)
] call EFUNC(sdf,manageSlider);

[
	_ctrlTaskGroup controlsGroupCtrl IDC_EXECUTION_DELAY,
	_ctrlTaskGroup controlsGroupCtrl IDC_EXECUTION_DELAY_EDIT,
	[0,GVAR(limits) get "executionDelay",1],
	_execDelay,
	FUNC(gui_execDelay)
] call EFUNC(sdf,manageSlider);

[
	_ctrlTaskGroup controlsGroupCtrl IDC_FIRING_DELAY,
	_ctrlTaskGroup controlsGroupCtrl IDC_FIRING_DELAY_EDIT,
	[0,GVAR(limits) get "firingDelay",1],
	_firingDelay,
	FUNC(gui_firingDelay)
] call EFUNC(sdf,manageSlider);
