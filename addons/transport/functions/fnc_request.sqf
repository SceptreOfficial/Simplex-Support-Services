#include "..\script_component.hpp"

params [
	["_player",objNull,[objNull]],
	["_entity",objNull,[objNull]],
	["_plan",[],[[]]],
	["_logic",0,[0]]
];

if (isNull _entity || _plan isEqualTo []) exitWith {};

if !(_plan isEqualTypeAll createHashMap) then {
	{
		if (_x isEqualType []) then {
			_plan set [_forEachIndex,createHashMapFromArray _x];
		};
	} forEach +_plan;
};

[QGVAR(request),[_player,_entity,_plan,_logic]] call CBA_fnc_serverEvent;
