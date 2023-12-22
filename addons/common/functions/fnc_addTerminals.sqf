#include "script_component.hpp"

params ["_logic","_entity"];

{
	if !(_x isKindOf QGVAR(moduleTerminal)) then {continue};
	{
		if (_x isKindOf "Logic") then {continue};
		[_x,_entity] call EFUNC(common,terminal);
	} forEach synchronizedObjects _x;
} forEach synchronizedObjects _logic;
