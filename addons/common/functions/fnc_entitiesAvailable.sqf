#include "script_component.hpp"

params ["_unit"];

private _available = false;

{
	if (_y findIf {[_unit,_x] call FUNC(isAuthorized)} > -1) exitWith {
		_available = true;
	};
} forEach GVAR(services);

_available
