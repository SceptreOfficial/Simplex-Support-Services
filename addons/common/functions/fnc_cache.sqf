#include "script_component.hpp"

params ["_vehicle","_hide"];

[QGVAR(enableSimulationGlobal),[_vehicle,_hide]] call CBA_fnc_serverEvent;
[QGVAR(hideObjectGlobal),[_vehicle,_hide]] call CBA_fnc_serverEvent;

[QGVAR(cache),[_vehicle,_hide]] call CBA_fnc_globalEvent;

