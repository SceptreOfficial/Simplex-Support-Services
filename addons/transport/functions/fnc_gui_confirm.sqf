#include "script_component.hpp"

params ["_service","_entity","_display"];

if (_service != QSERVICE) exitWith {};

if (GVAR(guiTab) == 0) then {
	[call CBA_fnc_currentUnit,PVAR(guiEntity),GVAR(plan),GVAR(planLogic)] call FUNC(request);
} else {
	GVAR(confirmation) params ["_vehicle","_value","_fnc"];
	GVAR(confirmation) = [];

	if (PVAR(guiEntity) getVariable [QPVAR(vehicle),objNull] isNotEqualTo _vehicle) exitWith {};

	[_vehicle,_value] call _fnc;

	private _ctrlTabs = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_TABS;
	_ctrlTabs lbSetCurSel 0;
	[_ctrlTabs,0] call FUNC(gui_tabs);
};
