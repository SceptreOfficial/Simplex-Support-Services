#include "script_component.hpp"

disableSerialization;
removeMissionEventHandler ["EachFrame",SSS_CDS_EFID];

private _returnValues = (uiNamespace getVariable "SSS_CDS_controls") apply {
	private _ctrlInfo = (findDisplay DISPLAY_IDD displayCtrl _x) getVariable "SSS_CDS_ctrlInfo";
	[_ctrlInfo # 0,_ctrlInfo # 1,_ctrlInfo # 2,true] call FUNC(cacheValue);
	switch (_ctrlInfo # 0) do {
		case "SLIDER";
		case "COMBOBOX" : {(_ctrlInfo # 2) # 1};
		default {_ctrlInfo # 2};
	};
};

[_returnValues,uiNamespace getVariable "SSS_CDS_customArguments"] call (uiNamespace getVariable "SSS_CDS_onOK");

closeDialog 0;
