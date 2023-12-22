#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_onValueChanged",{},[{}]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;

_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
