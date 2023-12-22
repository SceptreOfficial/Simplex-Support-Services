#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_enableCondition",{true},[{},true]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;

if (_enableCondition isEqualType true) then {
	_enableCondition = [{false},{true}] select _enableCondition;
};

_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
