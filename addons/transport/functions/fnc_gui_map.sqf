#include "..\script_component.hpp"

params ["_ctrlMap","_value"];

if (GVAR(manualInput) || _ctrlMap getVariable [QGVAR(viaGrid),false]) exitWith {
	_ctrlMap setVariable [QGVAR(viaGrid),nil];
};

// Special handling
if (_ctrlKey) exitWith {call FUNC(gui_addTask)};

private _display = ctrlParent _ctrlMap;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _ctrlPlan = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;

private _pos = if (GVAR(plan) # GVAR(planIndex) get "task" == "RTB") then {
	PVAR(guiEntity) getVariable QPVAR(base)
} else {
	call FUNC(gui_getPos)
};

GVAR(plan) # GVAR(planIndex) set ["posASL",_pos];
[QGVAR(guiPosUpdated),[_display,_posASL]] call CBA_fnc_localEvent;

[_pos] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_E) ctrlSetText _easting;
(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_N) ctrlSetText _northing;	

_ctrlPlan lnbSetText [[GVAR(planIndex),1],format ["%1 E %2 N",_easting,_northing]];

call FUNC(gui_verify);
