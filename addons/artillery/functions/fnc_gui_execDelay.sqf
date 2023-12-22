#include "script_component.hpp"

params ["_ctrlExecDelay","_execDelay"];

(GVAR(plan) # GVAR(planIndex)) set [4,_execDelay];
(ctrlParent _ctrlExecDelay displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN) lnbSetText [
	[GVAR(planIndex),4],
	str _execDelay
];