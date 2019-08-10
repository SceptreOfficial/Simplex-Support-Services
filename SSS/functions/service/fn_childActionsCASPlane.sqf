#include "script_component.hpp"

params ["_target","_player","_plane"];

private _actions = [];

{
	private _action = [format ["SSS_CAS:%1:%2",_plane,_x # 0],getText (configFile >> "CfgMagazines" >> _x # 1 >> "displayName"),"",{
		[_this # 2 # 0,_this # 2 # 1,"CASPlane"] call SSS_fnc_selectMapPosition;
	},{true},{},[_plane,_x]] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action,[],_target];
} forEach (_plane getVariable "SSS_weapons");

_actions
