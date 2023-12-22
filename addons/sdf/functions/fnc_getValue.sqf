#include "script_component.hpp"

params [["_ctrl",0,[0,controlNull]]];

if (_ctrl isEqualType 0) then {
	_ctrl = (uiNamespace getVariable QGVAR(controls)) # _ctrl;
};

_ctrl getVariable QGVAR(value)
