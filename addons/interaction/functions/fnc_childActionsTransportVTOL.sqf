#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_SignalConfirm","Confirm Signal",ICON_LAND_GREEN,{
		private _entity = _this # 2;
		_entity setVariable ["SSS_signalApproved",true,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SignalDeny","Search for new Signal",ICON_SEARCH_YELLOW,{
		private _entity = _this # 2;
		_entity setVariable ["SSS_signalApproved",false,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_RTB","RTB",ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportVTOL);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,0]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Pickup","Pickup",ICON_SMOKE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,1]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Land","Land",ICON_LAND,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,2]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_LandEngOff","Land - Engine Off",ICON_LAND_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,3]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move","Move",ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,4]] call ace_interact_menu_fnc_createAction,[],_target],

	//[["SSS_Hover","Hover/Fastrope",ICON_ROPE,{
	//	_this call FUNC(selectPosition);
	//},{true},{},[_entity,5]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter","Loiter",ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,6]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior","Change Behavior",ICON_GEAR,{
		private _entity = _this # 2;

		["Change Behavior",[
			["SLIDER","Flying height",[[40,1000,0],_entity getVariable "SSS_flyingHeight"]],
			["COMBOBOX","Speed Mode",[["LIMITED","NORMAL","FULL"],_entity getVariable "SSS_speedMode"]],
			["COMBOBOX","Combat Mode",[["Fire At will","Hold Fire"],_entity getVariable "SSS_combatMode"]],
			["CHECKBOX","Headlight",_entity getVariable "SSS_lightsOn"],
			["CHECKBOX","Collision lights",_entity getVariable "SSS_collisionLightsOn"]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]
