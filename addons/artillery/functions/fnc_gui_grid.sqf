#include "script_component.hpp"

params ["_ctrl"];

private _display = ctrlParent _ctrl;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _ctrlPlan = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;
private _ctrlE = _ctrlTaskGroup controlsGroupCtrl IDC_GRID_E;
private _ctrlN = _ctrlTaskGroup controlsGroupCtrl IDC_GRID_N;

private _easting = ctrlText _ctrlE;
if (count _easting > 5) then {
	_easting = _easting select [0,5];
	_ctrlE ctrlSetText _easting;
};

private _northing = ctrlText _ctrlN;
if (count _northing > 5) then {
	_northing = _northing select [0,5];
	_ctrlN ctrlSetText _northing;
};

private _area = GVAR(plan) # GVAR(planIndex) # 0;

_area set [0,AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid))];

_ctrlPlan lnbSetText [[GVAR(planIndex),0],format ["%1 E %2 N",_easting,_northing]];

private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QGVAR(viaGrid),true];

if ((GVAR(plan) # GVAR(planIndex) # 1) in ["CONVERGED","PARALLEL"]) then {
	[_ctrlMap,[[[_area # 0]],[],[],0]] call EFUNC(sdf,setValueData);
} else {
	[_ctrlMap,[[],[_area],[],1]] call EFUNC(sdf,setValueData);
};

call FUNC(gui_verify);
