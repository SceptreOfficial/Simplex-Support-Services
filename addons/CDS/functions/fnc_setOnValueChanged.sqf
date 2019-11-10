#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_onValueChanged",{},[{}]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _data = _ctrl getVariable QGVAR(data);

_data set [3,_onValueChanged];
_ctrl setVariable [QGVAR(data),_data];
