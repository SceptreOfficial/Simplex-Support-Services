#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(vehiclesReady),_this] call CBA_fnc_directCall};

params ["_entity","_wpPos"];

if (isNil "_wpPos") then {
	{unitReady _x} count (_entity getVariable [QPVAR(vehicles),[]]) == (_entity getVariable [QPVAR(vehicleCount),0])
} else {
	{
		unitReady _x && _x distance2D (_wpPos vectorAdd (_x getVariable [QGVAR(formOffset),[0,0,0]])) < 30
	} count (_entity getVariable [QPVAR(vehicles),[]]) == (_entity getVariable [QPVAR(vehicleCount),0])
};
