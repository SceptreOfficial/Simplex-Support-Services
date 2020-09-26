#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB","RTB",ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportPlane);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move","Move",ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Paradrop","Paradrop",ICON_PARACHUTE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"PARADROP"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter","Loiter",ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LOITER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior","Change Behavior",ICON_GEAR,{
		private _entity = _this # 2;

		["Change Behavior",[
			["SLIDER","Flying height",[[50,2000,0],_entity getVariable "SSS_flyingHeight"]],
			["COMBOBOX","Speed Mode",[["LIMITED","NORMAL","FULL"],_entity getVariable "SSS_speedMode"]],
			["COMBOBOX","Combat Mode",[["Fire At will","Hold Fire"],_entity getVariable "SSS_combatMode"]],
			["CHECKBOX","Headlight",_entity getVariable "SSS_lightsOn"],
			["CHECKBOX","Collision lights",_entity getVariable "SSS_collisionLightsOn"],
			["BUTTON","Shut up!",SHUP_UP_BUTTON_CODE]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SITREP","SITREP",ICON_SITREP,{
		(_this # 2) call EFUNC(common,sitrep);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]
