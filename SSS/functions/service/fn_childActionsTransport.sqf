#include "script_component.hpp"

params ["_target","_player","_vehicle"];

[
	[["SSS_transportConfirmSignal","Confirm Signal",ICON_LAND_GREEN,{
		private _vehicle = _this # 2;
		_vehicle setVariable ["SSS_signalApproved",true,true];
		_vehicle setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportDenySignal","Search for new Signal",ICON_SEARCH_YELLOW,{
		private _vehicle = _this # 2;
		_vehicle setVariable ["SSS_signalApproved",false,true];
		_vehicle setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportRTB","RTB",ICON_HOME,{
		[_this # 2,0] remoteExecCall ["SSS_fnc_requestTransport",_this # 2];
	},{(_this # 2) getVariable "SSS_awayFromBase"},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportPickup","Pickup",ICON_SMOKE,{
		[_this # 2,1,"transport"] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportLand","Land",ICON_LAND,{
		[_this # 2,2,"transport"] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportLandEngOff","Land - Engine Off",ICON_LAND_ENG_OFF,{
		[_this # 2,3,"transport"] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportMove","Move",ICON_MOVE,{
		[_this # 2,4,"transport"] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportHover","Hover/Fastrope",ICON_ROPE,{
		[_this # 2,5,"transport"] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportLoiter","Loiter",ICON_LOITER,{
		[_this # 2,6,"transport"] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_transportBehavior","Change Behavior",ICON_GEAR,{
		private _vehicle = _this # 2;

		["Change transport behavior",[
			["SLIDER","Flying height",[[40,1000,0],_vehicle getVariable "SSS_flyingHeight"]],
			["COMBOBOX","Speed Mode",[["LIMITED","NORMAL","FULL"],_vehicle getVariable "SSS_speedMode"]],
			["COMBOBOX","Combat Mode",[["Fire At will","Hold Fire"],_vehicle getVariable "SSS_combatMode"]]
		],{
			_this remoteExecCall ["SSS_fnc_changeBehavior",_this # 1];
		},{},_vehicle] call SSS_CDS_fnc_dialog;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target]
]
