#include "..\script_component.hpp"

params ["_ctrlRounds","_rounds"];

(GVAR(plan) # GVAR(planIndex)) set [3,_rounds];
(ctrlParent _ctrlRounds displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN) lnbSetText [
	[GVAR(planIndex),3],
	str _rounds//format ["%1 x %2",_rounds,count (PVAR(guiEntity) getVariable QPVAR(vehicles))]//str _rounds
];

call FUNC(gui_verify);
