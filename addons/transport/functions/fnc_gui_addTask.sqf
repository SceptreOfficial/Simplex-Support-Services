#include "..\script_component.hpp"

params ["_ctrl"];

if (GVAR(plan) isEqualTo []) then {
	GVAR(planIndex) = -1;
};

GVAR(plan) insert [GVAR(planIndex) + 1,[createHashMapFromArray [
	["task",PVAR(guiEntity) getVariable QPVAR(taskTypes) param [1,"RTB"]],
	["posASL",call FUNC(gui_getPos)],
	["behaviors",+(GVAR(plan) param [GVAR(planIndex),createHashMap] getOrDefault ["behaviors",createHashMap])],
	["timeout",0]
]]];

call FUNC(gui_planRefresh);

private _ctrlPlan = ctrlParent _ctrl displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;
_ctrlPlan lnbSetCurSelRow (GVAR(planIndex) + 1);
