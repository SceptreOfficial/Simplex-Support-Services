#include "script_component.hpp"

disableSerialization;
params [["_ctrl",0,[0,controlNull]],["_isRectangle",true,[false]]];

if (_ctrl isEqualType 0) then {
	_ctrl = (uiNamespace getVariable QGVAR(controls)) # _ctrl;
};

if (_ctrl getVariable QGVAR(mode) != 1) exitWith {};

private _value = _ctrl getVariable QGVAR(value);
private _markers = _ctrl getVariable [QGVAR(markers),[]];

_value set [4,_isRectangle];
_ctrl setVariable [QGVAR(value),_value];

(_markers # 0) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _isRectangle);
