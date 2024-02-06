#include "..\script_component.hpp"

params ["_vehicle","_magazine"];

if (_vehicle isKindOf "B_Ship_MRLS_01_base_F" || _vehicle isKindOf "OPTRE_archer_system_base") exitWith {[50,9999999]};

([_vehicle,_magazine] call FUNC(calculateData)) params ["","_maxElev","","_minVelocity","_maxVelocity"];

[
	_minVelocity^2 * sin (2 * _maxElev) / GRAVITY,//(2 * _minVelocity^2 / GRAVITY) * cos _maxElev * sin _maxElev,
	_maxVelocity^2 / GRAVITY
]
