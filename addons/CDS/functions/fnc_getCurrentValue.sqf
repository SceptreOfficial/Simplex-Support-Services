#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Gets the current value of a selected control.

Parameters:
0: Control index <SCALAR>

Returns:
Nothing
//-----------------------------------------------------------------------------------------------*/
disableSerialization;
params [["_index",0,[0]]];

private _ctrl = findDisplay DISPLAY_IDD displayCtrl ((uiNamespace getVariable QGVAR(controls)) # _index);
private _ctrlInfo = _ctrl getVariable QGVAR(ctrlInfo);

switch (_ctrlInfo # 0) do {
	case "SLIDER";
	case "COMBOBOX" : {(_ctrlInfo # 2) # 1};
	default {_ctrlInfo # 2};
};
