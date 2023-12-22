#include "script_component.hpp"

params ["_service","_entity","_display"];

if (_service != QSERVICE) exitWith {};

private _ctrlItemsGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_ITEMS_GROUP;
private _request = +GVAR(request);

if (_entity getVariable QPVAR(supportType) == "STATION") then {
	private _ctrlItems = _ctrlItemsGroup controlsGroupCtrl IDC_ITEMS;

	_request set ["selection",[GVAR(list) param [parseNumber (_ctrlItems tvData tvCurSel _ctrlItems),[]]]];

	[call CBA_fnc_currentUnit,PVAR(guiEntity),_request] call FUNC(request);
} else {
	private _ctrlSelection = _ctrlItemsGroup controlsGroupCtrl IDC_SELECTION;
	private _selection = [];

	for "_i" from 0 to ((lnbSize _ctrlSelection) # 0 - 1) do {
		private _item = GVAR(list) param [parseNumber (_ctrlSelection lnbData [_i,0]),[]];

		if (_item isNotEqualTo []) then {
			_selection pushBack _item;
		};
	};

	_request set ["selection",_selection];

	[call CBA_fnc_currentUnit,PVAR(guiEntity),_request] call FUNC(request);
};
