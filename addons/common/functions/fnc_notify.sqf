#include "script_component.hpp"

if (!hasInterface) exitWith {};

params [["_entity",objNull,[objNull]],["_message_code",{},[{}]],["_args",[],[]]];

if (isNull _entity) exitWith {};

if !(_entity in ([player,_entity getVariable "SSS_service"] call EFUNC(interaction,availableEntities))) exitWith {};

// Execute code to get the notification message
private _notification_message = _args call _message_code;

if (SSS_setting_useChatNotifications) then {
	systemChat format ["%1 : %2",_entity getVariable "SSS_callsign",_notification_message];
} else {
	private _color = switch (_entity getVariable "SSS_side") do {
		case east : {"#800000"};
		case independent : {"#008000"};
		case west : {"#004d99"};
		case civilian : {"#b300e6"};
		default {"#ffffff"};
	};

	private _title = format ["<img image='%1'/><t color='%2'> %3</t>",_entity getVariable "SSS_icon",_color,_entity getVariable "SSS_callsign"];

	[_title,_notification_message] call FUNC(notification);
};
