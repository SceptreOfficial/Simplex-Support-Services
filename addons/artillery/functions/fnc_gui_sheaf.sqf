#include "script_component.hpp"

params ["_ctrlSheaf","_lbCurSel"];

private _sheaf = _ctrlSheaf lbData _lbCurSel;

if (GVAR(plan) isNotEqualTo []) then {
	(GVAR(plan) # GVAR(planIndex)) set [1,_sheaf];
	(ctrlParent _ctrlSheaf displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN) lnbSetText [
		[GVAR(planIndex),1],
		GVAR(sheafNames) get _sheaf
	];	
};

_sheaf call FUNC(gui_sheafParams);
