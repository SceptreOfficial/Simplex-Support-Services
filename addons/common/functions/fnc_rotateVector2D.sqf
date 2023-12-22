#include "script_component.hpp"

params ["_v","_d"];
_v params ["_x","_y","_z"];

[_x * cos _d - _y * sin _d,_x * sin _d + _y * cos _d,_z]
