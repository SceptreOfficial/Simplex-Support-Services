#include "script_component.hpp"

params ["_service","_actionParams"];
_actionParams params ["_target","_player"];

if (ADMIN_ACCESS_CONDITION) exitWith {true};

private _specialItems = (([SSS_setting_specialItems] call CBA_fnc_removeWhitespace) splitString ",") apply {toLower _x};
private _hasItem = if (_specialItems isEqualTo []) then {
	true
} else {
	private _playerItems = assignedItems _player;
	_playerItems append uniformItems _player;
	_playerItems append vestItems _player;
	_playerItems append backpackItems _player;
	_playerItems = _playerItems apply {toLower _x};

	!((_playerItems arrayIntersect _specialItems) isEqualTo [])
};

private _assignedServices = (_player getVariable ['SSS_assignedEntities',[]]) select {!isNull _x && {(_x getVariable "SSS_service") == _service}};
private _showService = switch (_service) do {
	case "artillery" : {SSS_showArtillery};
	case "CAS" : {SSS_showCAS};
	case "transport" : {SSS_showTransport};
};

private _bool = if (SSS_setting_specialItemsLogic) then {
	_showService && {_hasItem && !(_assignedServices isEqualTo [])}
} else {
	_showService && {_hasItem || !(_assignedServices isEqualTo [])}
};

_bool
