#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};
deleteVehicle _logic;
"CASDrones" call FUNC(removeEntity);