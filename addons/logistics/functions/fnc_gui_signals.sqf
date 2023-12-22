#include "script_component.hpp"

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlItemsGroup = _ctrlGroup controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlSignal1 = _ctrlItemsGroup controlsGroupCtrl IDC_SIGNAL1;
private _ctrlSignal2 = _ctrlItemsGroup controlsGroupCtrl IDC_SIGNAL2;

GVAR(request) set ["signals",[
	_ctrlSignal1 lbData lbCurSel _ctrlSignal1,
	_ctrlSignal2 lbData lbCurSel _ctrlSignal2
]];

call FUNC(gui_verify);
