#include "script_component.hpp"

params ["_service","_entity","_display"];

if (_service != QSERVICE) exitWith {};

if (GVAR(guiTab) == 0) then {
	// Cache values
	PVAR(guiEntity) setVariable [QGVAR(cache),+GVAR(plan),true];
	PVAR(guiEntity) setVariable [QGVAR(loops),GVAR(loops),true];
	PVAR(guiEntity) setVariable [QGVAR(loopDelay),GVAR(loopDelay),true];
	PVAR(guiEntity) setVariable [QGVAR(coordinated),+GVAR(coordinated),true];

	+[
		call CBA_fnc_currentUnit,
		PVAR(guiEntity),
		"FIRE MISSION",
		[
			GVAR(plan),
			GVAR(loops),
			GVAR(loopDelay),
			GVAR(coordinated)
		]
	] call FUNC(request);
} else {
	private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
	private _ctrlRelocateGroup = _ctrlGroup controlsGroupCtrl IDC_RELOCATE_GROUP;
	private _ctrlE = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_E;
	private _ctrlN = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_N;

	private _ctrlTabs = _ctrlGroup controlsGroupCtrl IDC_TABS;
	_ctrlTabs lbSetCurSel 0;

	private _easting = ctrlText _ctrlE;
	private _northing = ctrlText _ctrlN;

	PVAR(guiEntity) setVariable [QGVAR(relocateCache),[_easting,_northing]];

	[
		call CBA_fnc_currentUnit,
		PVAR(guiEntity),
		"RELOCATE",
		[AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid))]
	] call FUNC(request);
};
