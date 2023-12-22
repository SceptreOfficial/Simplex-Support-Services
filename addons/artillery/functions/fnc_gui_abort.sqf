#include "script_component.hpp"

params ["_service","_entity","_display"];

if (_service != QSERVICE) exitWith {};

switch (_entity getVariable QPVAR(task)) do {
	case "RELOCATE" : {
		[QGVAR(abortRelocate),[call CBA_fnc_currentUnit,_entity]] call CBA_fnc_serverEvent;
	};
	case "FIRE MISSION" : {
		[QGVAR(abortFireMission),[call CBA_fnc_currentUnit,_entity]] call CBA_fnc_serverEvent;
	};
};
