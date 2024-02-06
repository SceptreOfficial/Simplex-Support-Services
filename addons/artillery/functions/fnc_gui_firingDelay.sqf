#include "..\script_component.hpp"

params ["_ctrlFiringDelay","_firingDelay"];

(GVAR(plan) # GVAR(planIndex)) set [5,_firingDelay];
(ctrlParent _ctrlFiringDelay displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN) lnbSetText [
	[GVAR(planIndex),5],
	str _firingDelay
];
