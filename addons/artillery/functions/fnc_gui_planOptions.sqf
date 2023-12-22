#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"
#define PLAN_H 7
#define PLAN_OPTIONS_H 8

params [["_uiSpeed",0.1]];

private _ctrlGroup = (uiNamespace getVariable QEGVAR(sdf,display)) displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlPlanGroup = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP;
private _ctrlPlanOptions = _ctrlPlanGroup controlsGroupCtrl IDC_PLAN_OPTIONS_BUTTON;
private _ctrlPlanOptionsBG = _ctrlGroup controlsGroupCtrl IDC_PLAN_OPTIONS_BG;
private _ctrlPlanOptionsGroup = _ctrlGroup controlsGroupCtrl IDC_PLAN_OPTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;

if (_ctrlGroup getVariable [QGVAR(planOptionsOpen),true]) then {
	_ctrlGroup setVariable [QGVAR(planOptionsOpen),false];

	_ctrlPlanOptions ctrlSetStructuredText parseText "<t align='center'>PLAN OPTIONS <img image='\a3\3DEN\Data\Displays\Display3DENSave\sort_down_ca.paa'/></t>";
	_ctrlPlanOptionsBG ctrlSetPositionH 0;
	_ctrlPlanOptionsGroup ctrlSetPositionH 0;
	_ctrlPlanGroup ctrlSetPositionY (GD_H(1));
	_ctrlTaskGroup ctrlSetPositionY (GD_H(1) + GD_H(PLAN_H));
	
	[{{_x ctrlShow false} forEach _this},[_ctrlPlanOptionsBG,_ctrlPlanOptionsGroup],_uiSpeed] call CBA_fnc_waitAndExecute;
} else {
	_ctrlGroup setVariable [QGVAR(planOptionsOpen),true];

	_ctrlPlanOptions ctrlSetStructuredText parseText "<t align='center'>PLAN OPTIONS <img image='\a3\3DEN\Data\Displays\Display3DENSave\sort_up_ca.paa'/></t>";
	_ctrlPlanOptionsBG ctrlSetPositionH CTRL_H_BUFFER(PLAN_OPTIONS_H);
	_ctrlPlanOptionsGroup ctrlSetPositionH GD_H(PLAN_OPTIONS_H);
	_ctrlPlanGroup ctrlSetPositionY (GD_H(1));
	_ctrlTaskGroup ctrlSetPositionY (GD_H(1) + GD_H(PLAN_H) + GD_H(PLAN_OPTIONS_H));

	_ctrlPlanOptionsBG ctrlShow true;
	_ctrlPlanOptionsGroup ctrlShow true;
};

_ctrlPlanGroup ctrlCommit _uiSpeed;
_ctrlPlanOptionsBG ctrlCommit _uiSpeed;
_ctrlPlanOptionsGroup ctrlCommit _uiSpeed;
_ctrlTaskGroup ctrlCommit _uiSpeed;
