/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Sets the text/description of a control.

Parameters:
0: Control index <SCALAR>
1: New text/description <STRING,ARRAY>

Returns:
Nothing
//-----------------------------------------------------------------------------------------------*/
#include "..\defines.hpp"

disableSerialization;
params [["_index",0,[0]],["_description","",["",[]]]];

private _ctrl = findDisplay DISPLAY_IDD displayCtrl ((uiNamespace getVariable "SSS_CDS_controls") # _index);
private _text = findDisplay DISPLAY_IDD displayCtrl (_ctrl getVariable "SSS_CDS_descriptionIDC");
private _ctrlInfo = _ctrl getVariable "SSS_CDS_ctrlInfo";

_ctrlInfo set [1,_description];
_ctrl setVariable ["SSS_CDS_ctrlInfo",_ctrlInfo];

if (_description isEqualType []) then {
	_text ctrlSetText (_description # 0 + ":");
	_text ctrlSetTooltip (_description # 1);
} else {
	_text ctrlSetText (_description + ":");
	_text ctrlSetTooltip "";
};
