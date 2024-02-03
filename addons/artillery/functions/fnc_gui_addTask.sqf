#include "..\script_component.hpp"

params ["_ctrl"];

private _limit = GVAR(limits) get "tasks";

if (_limit >= 0 && count GVAR(plan) >= _limit) exitWith {
	systemChat LLSTRING(TaskLimitReached);
	playSound QPVAR(failure);
};

private _display = ctrlParent _ctrl;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _ctrlPlan = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;

private _ammunition = (_ctrlTaskGroup controlsGroupCtrl IDC_AMMUNITION) call EFUNC(sdf,lbSelection) apply {GVAR(magTypes) # _x};
if (_ammunition isEqualTo []) then {_ammunition = [GVAR(magTypes) param [0,""]]};

if (GVAR(plan) isEqualTo []) then {
	GVAR(planIndex) = -1;
};

GVAR(plan) insert [GVAR(planIndex) + 1,[[
	call FUNC(gui_getArea),
	(_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF) lbData (0 max lbCurSel (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF)),
	_ammunition,
	1 max sliderPosition (_ctrlTaskGroup controlsGroupCtrl IDC_ROUNDS),
	sliderPosition (_ctrlTaskGroup controlsGroupCtrl IDC_EXECUTION_DELAY),
	sliderPosition (_ctrlTaskGroup controlsGroupCtrl IDC_FIRING_DELAY)
]]];

call FUNC(gui_planRefresh);

_ctrlPlan lnbSetCurSelRow (GVAR(planIndex) + 1);
