#include "script_component.hpp"

params ["_class"];

private _size = sizeOf _class;

if (_size isEqualTo 0) then {
	if (isNil QGVAR(sizeOfCache)) then {
		GVAR(sizeOfCache) = call CBA_fnc_createNamespace;
	};

	_size = GVAR(sizeOfCache) getVariable [_class,_size];

	if (_size isNotEqualTo 0) exitWith {};

	private _dummy = _class createVehicleLocal [0,0,0];
	_size = sizeOf _class;
	deleteVehicle _dummy;

	GVAR(sizeOfCache) setVariable [_class,_size];
};

_size
