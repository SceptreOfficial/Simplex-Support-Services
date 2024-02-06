#include "..\script_component.hpp"

params ["_ctrlClear"];

private _display = ctrlParent _ctrlClear;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlItemsGroup = _ctrlGroup controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlItems = _ctrlItemsGroup controlsGroupCtrl IDC_ITEMS;

GVAR(load) = 0;
lnbClear (_ctrlItemsGroup controlsGroupCtrl IDC_SELECTION);
GVAR(request) set ["selection",[]];

{_ctrlItems setVariable [str _forEachIndex,nil]} forEach GVAR(list);

GVAR(objectCount) = 0;
GVAR(crewCount) = 0;

call FUNC(gui_verify);
