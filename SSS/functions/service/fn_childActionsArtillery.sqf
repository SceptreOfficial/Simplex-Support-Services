#include "script_component.hpp"

params ["_target","_player","_vehicle"];

private _actions = [];

{
	private _action = [format["SSS_artillery:%1:%2",_vehicle,_forEachIndex],getText (configFile >> "CfgMagazines" >> _x >> "displayName"),"",{
		[_this # 2 # 0,_this # 2 # 1] call SSS_fnc_selectMapPosition;
	},{true},{},[_vehicle,_x]] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action,[],_target];
} forEach getArtilleryAmmo [_vehicle];

_actions
