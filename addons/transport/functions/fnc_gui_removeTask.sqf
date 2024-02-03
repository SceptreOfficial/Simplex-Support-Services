#include "..\script_component.hpp"

params ["_ctrl"];

GVAR(plan) deleteAt GVAR(planIndex);

if (GVAR(plan) isEqualTo []) exitWith {
	call FUNC(gui_addTask);
};

private _ctrlPlan = ctrlParentControlsGroup _ctrl controlsGroupCtrl IDC_PLAN;
_ctrlPlan lnbSetCurSelRow (0 max (GVAR(planIndex) - 1));

call FUNC(gui_planRefresh);
