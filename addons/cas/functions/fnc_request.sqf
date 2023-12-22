#include "script_component.hpp"

params [
	["_player",objNull,[objNull]],
	["_entity",objNull,[objNull]],
	"_request"
];

if (isNull _entity) exitWith {};

[QGVAR(request),[_player,_entity,_request]] call CBA_fnc_serverEvent;
