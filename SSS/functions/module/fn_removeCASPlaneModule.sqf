#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};
deleteVehicle _logic;
"CASPlanes" call SSS_fnc_removeEntity;
