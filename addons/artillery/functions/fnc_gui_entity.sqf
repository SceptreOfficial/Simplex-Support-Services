#include "script_component.hpp"

params ["_ctrlEntity","_entity"];

private _display = ctrlParent _ctrlEntity;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlOptionsGroup = _ctrlGroup controlsGroupCtrl IDC_PLAN_OPTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;

GVAR(plan) = _entity getVariable [QGVAR(cache),[]];
GVAR(planIndex) = count GVAR(plan) - 1;
GVAR(loops) = _entity getVariable [QGVAR(loops),0];
GVAR(loopDelay) = _entity getVariable [QGVAR(loopDelay),_entity getVariable QPVAR(cooldown)];
GVAR(coordinated) = _entity getVariable [QGVAR(coordinated),[]];
private _ammunition = +(_entity getVariable QPVAR(ammunition));
GVAR(magTypes) = _ammunition apply {_x # 0};
GVAR(limits) = _entity getVariable QPVAR(guiLimits);

// Sheaf types
private _ctrlSheaf = _ctrlTaskGroup controlsGroupCtrl IDC_SHEAF;
lbClear _ctrlSheaf;

{
	_ctrlSheaf lbAdd (GVAR(sheafNames) get _x);
	_ctrlSheaf lbSetData [_forEachIndex,_x];
	_ctrlSheaf setVariable [_x,_forEachIndex];
} forEach (_entity getVariable QPVAR(sheafTypes));

// Loop count
[
	_ctrlOptionsGroup controlsGroupCtrl IDC_LOOP_COUNT,
	_ctrlOptionsGroup controlsGroupCtrl IDC_LOOP_COUNT_EDIT,
	[0,GVAR(limits) get "loops",0],
	GVAR(loops),
	{GVAR(loops) = _this # 1}
] call EFUNC(sdf,manageSlider);

// Loop delay
[
	_ctrlOptionsGroup controlsGroupCtrl IDC_LOOP_DELAY,
	_ctrlOptionsGroup controlsGroupCtrl IDC_LOOP_DELAY_EDIT,
	[_entity getVariable QPVAR(cooldown),GVAR(limits) get "loopDelay",0],
	GVAR(loopDelay),
	{GVAR(loopDelay) = _this # 1}
] call EFUNC(sdf,manageSlider);

// Ammunition
private _ctrlAmmunition = _ctrlTaskGroup controlsGroupCtrl IDC_AMMUNITION;
private _cfgMagazines = configFile >> "CfgMagazines";
lnbClear _ctrlAmmunition;

{
	_ctrlAmmunition lnbAddRow ["",getText (_cfgMagazines >> _x # 0 >> "displayName")];

	if (_x # 1 >= 0) then {
		_ctrlAmmunition lnbSetText [[_forEachIndex,0],str (_x # 1)];
	} else {
		_ctrlAmmunition lnbSetPicture [[_forEachIndex,0],ICON_INFINITE];
	};
} forEach _ammunition;

// Populate planner
call FUNC(gui_planRefresh);

if (GVAR(plan) isEqualTo []) then {
	(_ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_ADD) call FUNC(gui_addTask);
} else {
	(_ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN) lbSetCurSel GVAR(planIndex);
};

// Load cached relocate data
private _ctrlRelocateGroup = _ctrlGroup controlsGroupCtrl IDC_RELOCATE_GROUP;
private _ctrlRelocateE = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_E;
private _ctrlRelocateN = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_N;
_entity getVariable [QGVAR(relocateCache),["00000","00000"]] params ["_easting","_northing"];

GVAR(relocatePosASL) = AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid));
_ctrlRelocateE ctrlSetText _easting;
_ctrlRelocateN ctrlSetText _northing;

private _ctrlTabs = _ctrlGroup controlsGroupCtrl IDC_TABS;
_ctrlTabs ctrlEnable ((_entity getVariable QPVAR(relocation)) # 0);
_ctrlTabs lbSetCurSel 0;
[_ctrlTabs,0] call FUNC(gui_tabs);

_ctrlGroup setVariable [QGVAR(planOptionsOpen),nil];
0 call FUNC(gui_planOptions);

private _ctrlRemoteControl = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_REMOTE_CONTROL;
_ctrlRemoteControl ctrlShow (_entity getVariable [QPVAR(remoteControl),false]);
