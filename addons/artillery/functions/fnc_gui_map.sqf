#include "..\script_component.hpp"

params ["_ctrlMap","_value"];

if (GVAR(manualInput) || _ctrlMap getVariable [QGVAR(viaGrid),false]) exitWith {
	_ctrlMap setVariable [QGVAR(viaGrid),nil];
};

private _display = ctrlParent _ctrlMap;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _ctrlPlan = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;

private _area = call FUNC(gui_getArea);

GVAR(plan) # GVAR(planIndex) set [0,_area];

[_area # 0] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_E) ctrlSetText _easting;
(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_N) ctrlSetText _northing;
(_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_WIDTH) ctrlSetText str (_area # 1);
(_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_HEIGHT) ctrlSetText str (_area # 2);
(_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_ANGLE) ctrlSetText str (_area # 3);	

// LOCALIZE THIS
_ctrlPlan lnbSetText [[GVAR(planIndex),0],format ["%1 E %2 N",_easting,_northing]];

call FUNC(gui_verify);
