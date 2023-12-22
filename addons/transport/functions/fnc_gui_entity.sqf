#include "script_component.hpp"

params ["_ctrlEntity","_entity"];

private _display = ctrlParent _ctrlEntity;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlPlanGroup = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;

GVAR(plan) = _entity getVariable [QGVAR(cache),[]];
GVAR(planIndex) = count GVAR(plan) - 1;
GVAR(planLogic) = _entity getVariable [QPVAR(planLogic),1];
GVAR(limits) = _entity getVariable QPVAR(guiLimits);
GVAR(confirmation) = [];

// Task types
private _ctrlTask = _ctrlTaskGroup controlsGroupCtrl IDC_TASK;
lbClear _ctrlTask;

{
	_ctrlTask lbAdd (GVAR(taskNames) get _x);
	_ctrlTask lbSetPicture [_forEachIndex,GVAR(taskIcons) get _x];
	_ctrlTask lbSetData [_forEachIndex,_x];
	_ctrlTask setVariable [_x,_forEachIndex];
} forEach (_entity getVariable QPVAR(taskTypes));

if ((_entity getVariable [QPVAR(relocation),[false,60]]) # 0) then {
	private _index = _ctrlTask lbAdd (GVAR(taskNames) get "RELOCATE");
	_ctrlTask lbSetData [_index,"RELOCATE"];
	_ctrlTask lbSetPicture [_index,GVAR(taskIcons) get "RELOCATE"];
	_ctrlTask setVariable ["RELOCATE",_index];
};

// Populate planner
call FUNC(gui_planRefresh);

if (GVAR(plan) isEqualTo []) then {
	(_ctrlPlanGroup controlsGroupCtrl IDC_ADD) call FUNC(gui_addTask);
} else {
	(_ctrlPlanGroup controlsGroupCtrl IDC_PLAN) lbSetCurSel GVAR(planIndex);
};

private _ctrlTabs = _ctrlGroup controlsGroupCtrl IDC_TABS;
_ctrlTabs lbSetCurSel 0;
[_ctrlTabs,0] call FUNC(gui_tabs);

private _ctrlPlanLogic = _ctrlPlanGroup controlsGroupCtrl IDC_PLAN_LOGIC;
_ctrlPlanLogic lbSetCurSel GVAR(planLogic);

// Toggle remote control button
private _ctrlRemoteControl = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_REMOTE_CONTROL;
_ctrlRemoteControl ctrlShow (_entity getVariable [QPVAR(remoteControl),false]);
