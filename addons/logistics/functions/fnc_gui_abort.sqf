#include "..\script_component.hpp"

params ["_service","_entity","_display"];

if (_service != QSERVICE) exitWith {};

[QGVAR(abort),[call CBA_fnc_currentUnit,_entity]] call CBA_fnc_serverEvent;
