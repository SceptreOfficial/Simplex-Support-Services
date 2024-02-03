#include "..\script_component.hpp"

params ["_ctrl"];

GVAR(plan) = [];
lnbClear (ctrlParent _ctrl displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN);
call FUNC(gui_addTask);
