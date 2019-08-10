#include "..\defines.hpp"

disableSerialization;
removeMissionEventHandler ["EachFrame",SSS_CDS_EFID];

private _returnValues = (uiNamespace getVariable "SSS_CDS_controls") apply {
	private _ctrlInfo = (findDisplay DISPLAY_IDD displayCtrl _x) getVariable "SSS_CDS_ctrlInfo";
	switch (_ctrlInfo # 0) do {
		case "SLIDER";
		case "COMBOBOX" : {(_ctrlInfo # 2) # 1};
		default {_ctrlInfo # 2};
	};
};

[_returnValues,uiNamespace getVariable "SSS_CDS_customArguments"] call (uiNamespace getVariable "SSS_CDS_onCancel");

closeDialog 0;
