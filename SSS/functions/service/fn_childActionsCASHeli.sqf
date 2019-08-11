#include "script_component.hpp"

params ["_target","_player","_vehicle"];

[
	[["SSS_CAS_RTB","RTB",ICON_HOME,{
		[_this # 2,0] remoteExecCall ["SSS_fnc_requestCASHeli",_this # 2];
	},{(_this # 2) getVariable "SSS_awayFromBase"},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_CAS_SAD","Search and Destroy",ICON_TARGET,{
		[_this # 2,1] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_CAS_Move","Move",ICON_MOVE,{
		[_this # 2,2] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_CAS_Loiter","Loiter",ICON_LOITER,{
		[_this # 2,3] call SSS_fnc_selectMapPosition;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_CAS_Behavior","Change Behavior",ICON_GEAR,{
		private _vehicle = _this # 2;

		["Change CAS Behavior",[
			["SLIDER","Flying height",[[40,1000,0],_vehicle getVariable "SSS_flyingHeight"]]
		],{
			_this remoteExecCall ["SSS_fnc_changeBehavior",_this # 1];
		},{},_vehicle] call SSS_CDS_fnc_dialog;
	},{true},{},_vehicle] call ace_interact_menu_fnc_createAction,[],_target]
]
