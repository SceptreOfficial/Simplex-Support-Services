#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB","RTB",ICON_HOME,{
		(_this # 2) call FUNC(requestCASHelicopter);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,0]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SAD","Search and Destroy",ICON_TARGET,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,1]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move","Move",ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,2]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter","Loiter",ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,3]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior","Change Behavior",ICON_GEAR,{
		private _entity = _this # 2;

		["Change Behavior",[
			["SLIDER","Flying height",[[40,1000,0],_entity getVariable "SSS_flyingHeight"]],
			["CHECKBOX","Headlight",_entity getVariable "SSS_lightsOn"],
			["CHECKBOX","Collision lights",_entity getVariable "SSS_collisionLightsOn"]
		],{
			_this call FUNC(changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]