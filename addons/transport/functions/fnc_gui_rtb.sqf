#include "script_component.hpp"

params ["_ctrl"];

private _display = ctrlParent _ctrl;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _ctrlTask = _ctrlTaskGroup controlsGroupCtrl IDC_TASK;

_ctrlTask lbSetCurSel 0;
