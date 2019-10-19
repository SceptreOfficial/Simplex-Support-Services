#include "script_component.hpp"

if (!hasInterface) exitWith {};

params [["_entity",objNull,[objNull]],["_message","",[""]]];

if (isNull _entity) exitWith {};

private _side = _entity getVariable "SSS_side";

private _canSee = if (ADMIN_ACCESS_CONDITION) then {
	if (SSS_setting_adminLimitSide && {_side != side player}) then {false} else {true};
} else {
	private _specialItems = (([SSS_setting_specialItems] call CBA_fnc_removeWhitespace) splitString ",") apply {toLower _x};
	private _hasItem = if (_specialItems isEqualTo []) then {
		true
	} else {
		private _playerItems = assignedItems player;
		_playerItems append uniformItems player;
		_playerItems append vestItems player;
		_playerItems append backpackItems player;
		_playerItems = _playerItems apply {toLower _x};

		!((_playerItems arrayIntersect _specialItems) isEqualTo [])
	};

	if (SSS_setting_specialItemsLogic) then {
		_hasItem && _entity in (player getVariable ["SSS_assignedEntities",[]])
	} else {
		if (SSS_setting_specialItemsLimitSide) then {
			_hasItem || _entity in (player getVariable ["SSS_assignedEntities",[]]) && {_side == side player}
		} else {
			_hasItem || _entity in (player getVariable ["SSS_assignedEntities",[]])
		};
	};
};

if (!_canSee) exitWith {};

if (SSS_setting_useChatNotifications) then {
	systemChat format ["%1 : %2",_entity getVariable "SSS_callsign",_message];
} else {
	private _color = switch (_side) do {
		case east : {"#800000"};
		case independent : {"#008000"};
		case west : {"#004d99"};
		case civilian : {"#b300e6"};
		default {"#ffffff"};
	};

	private _title = format ["<img image='%1'/><t color='%2'> %3</t>",_entity getVariable "SSS_icon",_color,_entity getVariable "SSS_callsign"];

	[_title,_message] call FUNC(notification);
};
