#include "script_component.hpp"

[QPVAR(vehicleCommissioned),{call FUNC(commission)}] call CBA_fnc_addEventHandler;

{
	[_x,FUNC(gui_verify)] call CBA_fnc_addEventHandler;
	[_x,FUNC(guiStation_verify)] call CBA_fnc_addEventHandler;
} forEach [
	QPVAR(requestSubmitted),
	QPVAR(requestCompleted),
	QPVAR(requestAborted),
	QPVAR(cooldownStarted),
	QPVAR(cooldownCompleted)
];

if (isServer) then {
	[QPVAR(cooldownCompleted),{
		params ["_entity"];

		if (_entity getVariable [QPVAR(service),""] != QSERVICE) exitWith {};

		if (_entity getVariable [QPVAR(supportType),""] == "STATION") then {
			NOTIFY(_entity,LSTRING(notifyStationCooldownComplete));
		} else {
			NOTIFY(_entity,LSTRING(notifyCooldownComplete));
		};
	}] call CBA_fnc_addEventHandler;
};

[QGVAR(recompileList),{
	params ["_entity"];

	private _display = uiNamespace getVariable [QEGVAR(sdf,display),displayNull];
	private _displayClass = uiNamespace getVariable [QEGVAR(sdf,displayClass),""];

	if (isNull _display ||
		!(_displayClass in [QGVAR(gui),QGVAR(guiStation)]) ||
		_entity != PVAR(guiEntity)
	) exitWith {};

	private _ctrlItems = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_ITEMS_GROUP controlsGroupCtrl IDC_ITEMS;
	private _path = tvCurSel _ctrlItems;

	if (_displayClass == QGVAR(gui)) then {
		[_display displayCtrl IDC_ENTITY,_entity] call FUNC(gui_entity);
	} else {
		[_display displayCtrl IDC_ENTITY,_entity] call FUNC(guiStation_entity);
	};

	private _itemKey = _ctrlItems tvData _path;
	if (_itemKey isEqualTo "") exitWith {};
		
	_ctrlItems tvSetCurSel _path;
}] call CBA_fnc_addEventHandler;
