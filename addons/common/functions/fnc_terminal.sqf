#include "script_component.hpp"

params [
	["_terminal",objNull,[objNull]],
	["_entity",objNull,[objNull]]
];

if (isNull _terminal || isNull _entity) exitWith {};

[
	[QGVAR(terminal),[_terminal,_entity]] call CBA_fnc_globalEventJIP,
	_terminal
] call CBA_fnc_removeGlobalEventJIP;
