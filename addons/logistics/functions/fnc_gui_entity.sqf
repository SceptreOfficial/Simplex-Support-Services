#include "..\script_component.hpp"

params ["_ctrlEntity","_entity"];

private _display = ctrlParent _ctrlEntity;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlItemsGroup = _ctrlGroup controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlItems = _ctrlItemsGroup controlsGroupCtrl IDC_ITEMS;
private _ctrlSelection = _ctrlItemsGroup controlsGroupCtrl IDC_SELECTION;

GVAR(capacity) = _entity getVariable [QPVAR(capacity),0];
GVAR(load) = 0;

lnbClear _ctrlSelection;
_ctrlSelection lnbSetColumnsPos [0,0.75,0.9];

[_ctrlItems,_entity] call FUNC(compileList);

GVAR(objectCount) = 0;
GVAR(crewCount) = 0;
private _useLimits = _entity getVariable QPVAR(supportType) == "SLINGLOAD" && {_entity getVariable QPVAR(fulfillment) != "MULTI"};

if (_useLimits) then {
	private _class = _entity getVariable QPVAR(class);
	GVAR(crewLimit) = ([_class,true] call BIS_fnc_crewCount) - ([_class,false] call BIS_fnc_crewCount);
	GVAR(objectLimit) = 1;
} else {
	GVAR(crewLimit) = -1;
	GVAR(objectLimit) = -1;
};

{(_ctrlItemsGroup controlsGroupCtrl _x) ctrlShow _useLimits} forEach [
	IDC_OBJECT_LIMIT,
	IDC_OBJECT_LIMIT_ICON,
	IDC_CREW_LIMIT,
	IDC_CREW_LIMIT_ICON
];

_entity getVariable [QGVAR(cache),[]] params [["_cacheList",[]],["_cacheRequest",createHashMap]];
GVAR(request) = +_cacheRequest;
GVAR(request) set ["selection",[]];

if (_cacheList isEqualTo GVAR(list)) then {
	{[_ctrlItems,_x] call FUNC(gui_itemAdd)} forEach (_cacheRequest getOrDefault ["selection",[]]);
};

private _posASL = GVAR(request) getOrDefault ["posASL",call FUNC(gui_getPos)];
[_posASL] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];
(_ctrlItemsGroup controlsGroupCtrl IDC_GRID_E) ctrlSetText _easting;
(_ctrlItemsGroup controlsGroupCtrl IDC_GRID_N) ctrlSetText _northing;
[_display displayCtrl IDC_MAP,[[[_posASL]],[],[],0]] call EFUNC(sdf,setValueData);

(GVAR(request) getOrDefault ["signals",["",""]]) params ["_signal1","_signal2"];

(_ctrlItemsGroup controlsGroupCtrl IDC_SIGNAL1) lbSetCurSel (SIGNAL_CLASSES find _signal1);
(_ctrlItemsGroup controlsGroupCtrl IDC_SIGNAL2) lbSetCurSel (SIGNAL_CLASSES find _signal2);
(_ctrlItemsGroup controlsGroupCtrl IDC_AI_HANDLING) lbSetCurSel (GVAR(request) getOrDefault ["aiHandling",0]);

FUNC(gui_verify) call CBA_fnc_execNextFrame;
