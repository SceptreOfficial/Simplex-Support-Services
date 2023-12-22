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

private _posASL = if (GVAR(plan) # GVAR(planIndex) get "task" == "RTB") then {
	PVAR(guiEntity) getVariable QPVAR(base)
} else {
	AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid))
};

GVAR(plan) # GVAR(planIndex) set ["posASL",_posASL];
[QGVAR(guiPosUpdated),[_display,_posASL]] call CBA_fnc_localEvent;

if (GVAR(plan) # GVAR(planIndex) get "task" == "RTB") then {
	[_posASL] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];
	_ctrlE ctrlSetText _easting;
	_ctrlN ctrlSetText _northing;
};

_ctrlPlan lnbSetText [[GVAR(planIndex),1],format ["%1 E %2 N",_easting,_northing]];

private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QGVAR(viaGrid),true];
[_ctrlMap,[[[_posASL]],[],[],0]] call EFUNC(sdf,setValueData);

call FUNC(gui_verify);
