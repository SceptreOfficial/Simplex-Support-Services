#include "script_component.hpp"

params ["_ctrl"];

private _ctrlTaskGroup = ctrlParentControlsGroup _ctrl;
private _ctrlWidth = _ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_WIDTH;
private _ctrlHeight = _ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_HEIGHT;
private _ctrlAngle = _ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_ANGLE;
private _sheaf = GVAR(plan) # GVAR(planIndex) # 1;
private _area = GVAR(plan) # GVAR(planIndex) # 0;

_area set [1,999999 min parseNumber ctrlText _ctrlWidth];
_area set [2,999999 min parseNumber ctrlText _ctrlHeight];
_area set [3,360 min parseNumber ctrlText _ctrlAngle];

if (GVAR(manualInput)) then { // Update values if map clicking won't do it
	_ctrlWidth ctrlSetText str (_area # 1);
	_ctrlHeight ctrlSetText str (_area # 2);
	_ctrlAngle ctrlSetText str (_area # 3);

	call FUNC(gui_verify);
};

if (_sheaf in ["CONVERGED","PARALLEL"]) then {
	[ctrlParent _ctrl displayCtrl IDC_MAP,[[[_area # 0]],[],[],0]] call EFUNC(sdf,setValueData);
} else {
	[ctrlParent _ctrl displayCtrl IDC_MAP,[[],[_area],[],1]] call EFUNC(sdf,setValueData);
};
