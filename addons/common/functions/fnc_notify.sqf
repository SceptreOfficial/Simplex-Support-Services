#include "script_component.hpp"

if (!hasInterface) exitWith {};

params [["_entity",objNull,[objNull]],["_message","",[""]]];

if (isNull _entity) exitWith {};

if !(_entity in ([player,_entity getVariable "SSS_service"] call EFUNC(interaction,availableEntities))) exitWith {};

if (SSS_setting_useChatNotifications) then {
	systemChat format ["%1 : %2",_entity getVariable "SSS_callsign",_message];
} else {
	private _color = switch (_entity getVariable "SSS_side") do {
		case east : {"#800000"};
		case independent : {"#008000"};
		case west : {"#004d99"};
		case civilian : {"#b300e6"};
		default {"#ffffff"};
	};

	private _title = format ["<img image='%1'/><t color='%2'> %3</t>",_entity getVariable "SSS_icon",_color,_entity getVariable "SSS_callsign"];

	[_title,_message] call FUNC(notification);
};
