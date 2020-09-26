#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB","RTB",ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportMaritime);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move","Move",ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_MoveEngOff","Move - Engine Off",ICON_MOVE_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE_ENG_OFF"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_ImmediateStop","Stop",ICON_STOP_VEHICLE,{
		(_this # 2) call EFUNC(common,stopVehicle);
	},{(_this # 2) getVariable "SSS_onTask"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior","Change Behavior",ICON_GEAR,{
		private _entity = _this # 2;

		["Change Behavior",[
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
