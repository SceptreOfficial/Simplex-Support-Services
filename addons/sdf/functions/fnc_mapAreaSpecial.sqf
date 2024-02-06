#include "..\script_component.hpp"

disableSerialization;
params [["_ctrl",0,[0,controlNull]],["_tip",LLSTRING(special),[""]],["_shiftMovingCode",{},[{}]],["_shiftDownCode",{},[{}]]];

if (_ctrl isEqualType 0) then {
	_ctrl = (uiNamespace getVariable QGVAR(controls)) # _ctrl;
};

if (_shiftMovingCode isEqualTo {} && _shiftDownCode isEqualTo {}) then {
	_ctrl setVariable [QGVAR(areaSpecial),false];
} else {
	_ctrl setVariable [QGVAR(areaSpecial),true];
};

_ctrl setVariable [QGVAR(areaSpecialTip),_tip];
_ctrl setVariable [QGVAR(areaSpecialMoving),_shiftMovingCode];
_ctrl setVariable [QGVAR(areaSpecialKeyDown),_shiftDownCode];
