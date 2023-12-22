#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(positionAvg),_this] call CBA_fnc_directCall};

if !(_this isEqualType []) exitWith {[0,0,0]};

if (_this # 0 isEqualType objNull) then {
	_this = _this apply {getPosASL _x};
};

if (_this isEqualTo []) exitWith {[0,0,0]};

[
	_this apply {_x # 0} call BIS_fnc_arithmeticMean,
	_this apply {_x # 1} call BIS_fnc_arithmeticMean,
	_this apply {_x # 2} call BIS_fnc_arithmeticMean
]
