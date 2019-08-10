#include "script_component.hpp"

if (!hasInterface) exitWith {};

params [["_source",objNull,[objNull]],["_message","",[""]]];
private _side = _source getVariable "SSS_side";

if !(_side isEqualTo side player) exitWith {};

private _icon = switch (_source getVariable "SSS_service") do {
	case "artillery" : {[ICON_SELF_PROPELLED,ICON_MORTAR] select (_source isKindOf "StaticWeapon")};
	case "CASDrones" : {ICON_DRONE};
	case "CASGunships" : {ICON_GUNSHIP};
	case "CASHelis" : {ICON_HELI};
	case "CASPlanes" : {ICON_PLANE};
	case "transport" : {ICON_HELI};
	default {""};
};

private _color = switch (_side) do {
	case east : {"#800000"};
	case independent : {"#008000"};
	case west : {"#004d99"};
	default {"#ffffff"};
};

private _interruptedTask = _source getVariable ["SSS_interruptedTask",""];
if (_interruptedTask isEqualTo "") then {
	[format ["<img image='%1'/><t color='%2'> %3</t>",_icon,_color,_source getVariable "SSS_displayName"],_message] call SSS_fnc_notification;
} else {
	[format ["<img image='%1'/><t color='%2'> %3</t>",_icon,_color,_source getVariable "SSS_displayName"],format ["%1 cancelled; %2",_interruptedTask,_message]] call SSS_fnc_notification;
	_source setVariable ["SSS_interruptedTask",nil,true];
};

