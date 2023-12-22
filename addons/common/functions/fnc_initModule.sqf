#include "script_component.hpp"

if (!is3DEN) exitWith {};

params ["_logic"];

_logic addEventHandler ["ConnectionChanged3DEN",{
	[QGVAR(ConnectionChanged3DEN),_this] call CBA_fnc_localEvent;
}];
