#include "..\script_component.hpp"

params ["_string"];

([_string] call CBA_fnc_removeWhitespace) splitString ","
