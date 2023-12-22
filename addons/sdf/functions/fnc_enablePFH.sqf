#include "script_component.hpp"

disableSerialization;
params ["_parent","_PFHID"];

if (isNull _parent) exitWith {_PFHID call CBA_fnc_removePerFrameHandler};

{
	_x params ["_ctrl"];

	private _enableCtrl = [_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(enableCondition));
	private _ctrlDescription = _ctrl getVariable [QGVAR(ctrlDescription),controlNull];

	if (!_enableCtrl && ctrlEnabled _ctrl) then {
		_ctrl ctrlEnable false;

		if (!isNull _ctrlDescription) then {
			_ctrlDescription ctrlSetTextColor [COLOR_DISABLED];
		};
		
		if ((_ctrl getVariable QGVAR(parameters)) # 0 == "SLIDER") then {
			(_ctrl getVariable QGVAR(ctrlEdit)) ctrlEnable false;
		};
	};

	if (_enableCtrl && !ctrlEnabled _ctrl) then {
		_ctrl ctrlEnable true;

		if (!isNull _ctrlDescription) then {
			_ctrlDescription ctrlSetTextColor [1,1,1,1];
		};

		if ((_ctrl getVariable QGVAR(parameters)) # 0 == "SLIDER") then {
			(_ctrl getVariable QGVAR(ctrlEdit)) ctrlEnable true;
		};
	};
} forEach (uiNamespace getVariable QGVAR(controls));
