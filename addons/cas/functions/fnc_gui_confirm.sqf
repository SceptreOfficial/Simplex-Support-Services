#include "..\script_component.hpp"

params ["_service","_entity","_display"];

if (_service != QSERVICE) exitWith {};

[call CBA_fnc_currentUnit,PVAR(guiEntity),GVAR(request)] call FUNC(request);
