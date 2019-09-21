#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Sets the modifier function of a control that executes when the value of it has changed.

Parameters:
0: Control index <SCALAR>
1: New modifier function <CODE>

Returns:
Nothing
//-----------------------------------------------------------------------------------------------*/
disableSerialization;
params [["_index",0,[0]],["_onValueChanged",{},[{}]]];

private _ctrl = findDisplay DISPLAY_IDD displayCtrl ((uiNamespace getVariable QGVAR(controls)) # _index);
private _ctrlInfo = _ctrl getVariable QGVAR(ctrlInfo);

_ctrlInfo set [3,_onValueChanged];
_ctrl setVariable [QGVAR(ctrlInfo),_ctrlInfo];
