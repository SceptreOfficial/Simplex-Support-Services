#include "..\script_component.hpp"

params ["_ctrlService"];

lbClear _ctrlService;

{
	private _service = toUpper configName _x;

	if ([call CBA_fnc_currentUnit,_service,PVAR(terminalEntity)] call FUNC(getEntities) isNotEqualTo []) then {
		private _index = _ctrlService lbAdd getText (_x >> "name");
		_ctrlService lbSetPicture [_index,getText (_x >> "icon")];
		_ctrlService lbSetData [_index,_service];
	};
} forEach configProperties [configFile >> QPVAR(services),"isClass _x"];

lbSort _ctrlService;

for "_i" from 0 to (lbSize _ctrlService) do {
	if (GVAR(guiService) == _ctrlService lbData _i) exitWith {
		_ctrlService lbSetCurSel _i;
	};
};

_ctrlService ctrlAddEventHandler ["LBSelChanged",{
	params ["_ctrlService","_lbCurSel"];
	
	private _service = _ctrlService lbData _lbCurSel;

	if (_service != GVAR(guiService)) then {
		_service call FUNC(openGUI);
	};
}];
