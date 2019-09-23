#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Sets the condition to enable the use of a control.

Parameters:
0: Control index <SCALAR>
1: New condition <CODE>

Returns:
Nothing
//-----------------------------------------------------------------------------------------------*/
disableSerialization;
params [["_index",0,[0]],["_enableCondition",{true},[{}]]];

private _ctrl = findDisplay DISPLAY_IDD displayCtrl ((uiNamespace getVariable QGVAR(controls)) # _index);
private _ctrlInfo = _ctrl getVariable QGVAR(ctrlInfo);

_ctrlInfo set [4,_enableCondition];
_ctrl setVariable [QGVAR(ctrlInfo),_ctrlInfo];
