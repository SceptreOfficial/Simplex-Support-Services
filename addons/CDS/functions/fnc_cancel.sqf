#include "script_component.hpp"

disableSerialization;
removeMissionEventHandler ["EachFrame",GVAR(EFID)];

private _returnValues = (uiNamespace getVariable QGVAR(controls)) apply {
	private _ctrlInfo = (findDisplay DISPLAY_IDD displayCtrl _x) getVariable QGVAR(ctrlInfo);
	switch (_ctrlInfo # 0) do {
		case "SLIDER";
		case "COMBOBOX" : {(_ctrlInfo # 2) # 1};
		default {_ctrlInfo # 2};
	};
};

closeDialog 0;

[{isNull (findDisplay DISPLAY_IDD)},{
	params ["_returnValues","_customArguments","_code"];
	[_returnValues,_customArguments] call _code;
},[_returnValues,uiNamespace getVariable QGVAR(customArguments),uiNamespace getVariable QGVAR(onCancel)]] call CBA_fnc_waitUntilAndExecute;
