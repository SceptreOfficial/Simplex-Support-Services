#include "..\script_component.hpp"

params [
	["_player",objNull,[objNull]],
	["_entity",objNull,[objNull]],
	["_plan",[],[[]]],
	["_logic",0,[0]]
];

if (isNull _entity || _plan isEqualTo []) exitWith {};

[QGVAR(request),[_player,_entity,_plan,_logic]] call CBA_fnc_serverEvent;
