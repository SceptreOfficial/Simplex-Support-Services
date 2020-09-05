#include "script_component.hpp"

params ["_array"];

// Manage empty string to avoid parseSimpleArray crash
if (_array isEqualTo "") exitWith {[]};

parseSimpleArray _array
