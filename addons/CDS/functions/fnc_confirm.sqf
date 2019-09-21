#include "script_component.hpp"

disableSerialization;
removeMissionEventHandler ["EachFrame",GVAR(EFID)];

private _returnValues = (uiNamespace getVariable QGVAR(controls)) apply {
	private _ctrlInfo = (findDisplay DISPLAY_IDD displayCtrl _x) getVariable QGVAR(ctrlInfo);
	
	[_ctrlInfo # 0,_ctrlInfo # 1,_ctrlInfo # 2,true] call FUNC(cacheValue);
	switch (_ctrlInfo # 0) do {
		case "SLIDER";
		case "COMBOBOX" : {(_ctrlInfo # 2) # 1};
		default {_ctrlInfo # 2};
	};
};

[_returnValues,uiNamespace getVariable QGVAR(customArguments)] call (uiNamespace getVariable QGVAR(onOK));

closeDialog 0;
