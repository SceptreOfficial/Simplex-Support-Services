#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB",LLSTRING(RTB),ICON_HOME,{
		(_this # 2) call EFUNC(support,requestCASHelicopter);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SAD",LLSTRING(SAD),ICON_TARGET,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"SAD"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move",LLSTRING(Move),ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter",LLSTRING(Loiter),ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LOITER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior",LLSTRING(ChangeBehavior),ICON_GEAR,{
		private _entity = _this # 2;

		[LLSTRING(ChangeBehavior),[
			["SLIDER",LLSTRING(FlyingHeight),[[0,2000,0],_entity getVariable "SSS_flyingHeight"]],
			["CHECKBOX",LLSTRING(Headlight),_entity getVariable "SSS_lightsOn"],
			["CHECKBOX",LLSTRING(CollisionLights),_entity getVariable "SSS_collisionLightsOn"]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SITREP",LLSTRING(SITREP),ICON_SITREP,{
		(_this # 2) call EFUNC(common,sitrep);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]
