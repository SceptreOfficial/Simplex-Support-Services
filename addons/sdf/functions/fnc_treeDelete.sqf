#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_path",[],[[]]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;

_ctrl tvDelete _path;
