#include "script_component.hpp"

params ["_posASL","_radius"];

if (_radius isEqualType "") then {
	_radius = 0.7 * (_radius call EFUNC(common,sizeOf));
};

{
	if (isNull (_x getVariable [QPVAR(entity),objNull]) &&
		{!alive _x || {alive _x} count crew _x isEqualTo 0} &&
		{_x isKindOf "LandVehicle" || _x isKindOf "Air" || _x isKindOf "Ship"}
	) then {
		deleteVehicleCrew _x;
		deleteVehicle _x;
	};
} forEach (ASLToAGL _posASL nearObjects _radius);
