#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(notify),_this] call CBA_fnc_directCall};

params [["_entity",objNull,[objNull]],["_message","",["",{}]],["_args",[],[[]]]];

_entity = _entity getVariable [QPVAR(entity),_entity];

if (isNull _entity || !hasInterface) exitWith {};

private _inScope = if (isNil {_entity getVariable QPVAR(notifyScope)}) then {
	switch OPTION(notifyScope) do {
		case "REQUESTER" : {[player,_entity] call FUNC(isAuthorized) && player == _entity getVariable [QPVAR(requester),objNull]};
		case "ACCESS" : {[player,_entity] call FUNC(isAuthorized)};
		case "SIDE" : {side group player == _entity getVariable [QPVAR(side),sideUnknown]};
		default {false};
	};
} else {
	[_entity,_message,_args] call (_entity getVariable QPVAR(notifyScope))
};

if (!_inScope) exitWith {};

if (OPTION(notificationStyle) isEqualTo 0) then {
	private _color = switch (_entity getVariable QPVAR(side)) do {
		case east : {"#800000"};
		case independent : {"#008000"};
		case west : {"#004d99"};
		case civilian : {"#b300e6"};
		default {"#ffffff"};
	};

	[
		format ["<img image='%1'/><t color='%2'> %3</t>",_entity getVariable QPVAR(icon),_color,_entity getVariable QPVAR(callsign)],
		[_message,_args] call FUNC(parseMessage)
	] call FUNC(popup);
} else {
	systemChat format ["%1: %2",_entity getVariable QPVAR(callsign),[_message,_args] call FUNC(parseMessage)];
};
