#include "script_component.hpp"

params ["_ctrlEntity","_entity"];

private _display = ctrlParent _ctrlEntity;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlItemsGroup = _ctrlGroup controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlItems = _ctrlItemsGroup controlsGroupCtrl IDC_ITEMS;

[_ctrlItems,_entity] call FUNC(compileList);

_entity getVariable [QGVAR(cache),[]] params [["_cacheList",[]],["_cacheRequest",createHashMap]];
GVAR(request) = +_cacheRequest;
GVAR(request) set ["selection",[]];

if (_cacheList isEqualTo GVAR(list)) then {
	_ctrlItems tvSetCurSel (_cacheRequest getOrDefault ["selection",[]]);
};

(_ctrlItemsGroup controlsGroupCtrl IDC_AI_HANDLING) lbSetCurSel (GVAR(request) getOrDefault ["aiHandling",0]);

FUNC(guiStation_verify) call CBA_fnc_execNextFrame;
