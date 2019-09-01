#include "script_component.hpp"

if (!hasInterface) exitWith {};

params [["_source",objNull,[objNull]],["_message","",[""]]];

private _side = _source getVariable "SSS_side";
if !(_side isEqualTo side player) exitWith {};

private _interruptedTask = _source getVariable ["SSS_interruptedTask",""];
if (_interruptedTask != "") then {
	_message = format ["%1 cancelled; %2",_interruptedTask,_message];
	_source setVariable ["SSS_interruptedTask",nil,true];
};

if (SSS_setting_useChatNotifications) then {
	systemChat format ["%1 : %2",_source getVariable "SSS_displayName",_message];
} else {
	private _color = switch (_side) do {
		case east : {"#800000"};
		case independent : {"#008000"};
		case west : {"#004d99"};
		default {"#ffffff"};
	};

	private _title = format ["<img image='%1'/><t color='%2'> %3</t>",_source getVariable "SSS_icon",_color,_source getVariable "SSS_displayName"];

	[_title,_message] call FUNC(notification);
};
