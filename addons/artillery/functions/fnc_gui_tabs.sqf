#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_ctrlTabs","_index"];

private _display = ctrlParent _ctrlTabs;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlRelocateBG = _ctrlGroup controlsGroupCtrl IDC_RELOCATE_BG;
private _ctrlRelocateGroup = _ctrlGroup controlsGroupCtrl IDC_RELOCATE_GROUP;
private _ctrlPlanGroup = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP;
private _ctrlPlanOptionsBG = _ctrlGroup controlsGroupCtrl IDC_PLAN_OPTIONS_BG;
private _ctrlPlanOptionsGroup = _ctrlGroup controlsGroupCtrl IDC_PLAN_OPTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;

private _planOpen = _index == 0;
GVAR(guiTab) = _index;

_ctrlRelocateBG ctrlShow !_planOpen;
_ctrlRelocateGroup ctrlShow !_planOpen;
_ctrlRelocateGroup ctrlEnable !_planOpen;

_ctrlPlanGroup ctrlShow _planOpen;
_ctrlPlanGroup ctrlEnable _planOpen;

_ctrlPlanOptionsBG ctrlShow _planOpen;
_ctrlPlanOptionsGroup ctrlShow _planOpen;
_ctrlPlanOptionsGroup ctrlEnable _planOpen;

_ctrlTaskGroup ctrlShow _planOpen;
_ctrlTaskGroup ctrlEnable _planOpen;

private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QEGVAR(sdf,override),GVAR(manualInput)];
_ctrlMap setVariable [QEGVAR(sdf,disableMarkers),!GVAR(visualAids)];
_ctrlMap setVariable [QEGVAR(sdf,skip),true];

if (_planOpen) then {
	GVAR(plan) # GVAR(planIndex) params ["_area","_sheaf"];
	
	if (_sheaf in ["CONVERGED","PARALLEL"]) then {
		[_ctrlMap,[[_area # 0]],[],[],0,FUNC(gui_map)] call EFUNC(sdf,manageMap);
	} else {
		[_ctrlMap,[],[_area],[],1,FUNC(gui_map)] call EFUNC(sdf,manageMap);
	};

	(_ctrlPlanGroup controlsGroupCtrl IDC_REMOTE_CONTROL) ctrlShow (PVAR(guiEntity) getVariable [QPVAR(remoteControl),false]);
} else {	
	[_ctrlMap,[[GVAR(relocatePosASL)]],[],[],0,FUNC(gui_relocateMap)] call EFUNC(sdf,manageMap);
};

call FUNC(gui_verify);
