#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_enableCondition",{true},[{},true]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _data = _ctrl getVariable QGVAR(data);

if (_enableCondition isEqualType true) then {
	_enableCondition = [{false},{true}] select _enableCondition;
};

_data set [4,_enableCondition];
_ctrl setVariable [QGVAR(data),_data];
