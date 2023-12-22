#include "script_component.hpp"

params ["_display"];

[QGVAR(zeusDisplayUnload),_display] call CBA_fnc_localEvent;
