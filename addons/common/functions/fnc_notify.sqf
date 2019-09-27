#include "script_component.hpp"

if (!hasInterface) exitWith {};

params [["_entity",objNull,[objNull]],["_message","",[""]]];

if (isNull _entity) exitWith {};

private _side = _entity getVariable "SSS_side";

if (!(ADMIN_ACCESS_CONDITION) && {!(_entity in (player getVariable ["SSS_assignedEntities",[]]))}) exitWith {};
if (ADMIN_ACCESS_CONDITION && SSS_setting_adminLimitSide && _side != side player) exitWith {};

private _interruptedTask = _entity getVariable ["SSS_interruptedTask",""];
if (_interruptedTask != "" && {alive (_entity getVariable ["SSS_vehicle",objNull])}) then {
	_message = format ["%1 cancelled; %2",_interruptedTask,_message];
	_entity setVariable ["SSS_interruptedTask",nil,true];
};

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
