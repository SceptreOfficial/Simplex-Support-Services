#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_enableCondition",{true},[{}]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _data = _ctrl getVariable QGVAR(data);

_data set [4,_enableCondition];
_ctrl setVariable [QGVAR(data),_data];
