#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB",LLSTRING(RTB),ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportLandVehicle);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move",LLSTRING(Move),ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_MoveEngOff",LLSTRING(MoveEngineOff),ICON_MOVE_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE_ENG_OFF"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_ImmediateStop","Stop",ICON_STOP_VEHICLE,{
		(_this # 2) call EFUNC(common,stopVehicle);
	},{(_this # 2) getVariable "SSS_onTask"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior",LLSTRING(ChangeBehavior),ICON_GEAR,{
		private _entity = _this # 2;

		[LLSTRING(ChangeBehavior),[
			["COMBOBOX",LLSTRING(SpeedMode),[[LLSTRING(SpeedLimited),LLSTRING(SpeedNormal),LLSTRING(SpeedFull)],_entity getVariable "SSS_speedMode"]],
			["COMBOBOX",LLSTRING(CombatMode),[[LLSTRING(FireAtWill),LLSTRING(HoldFire)],_entity getVariable "SSS_combatMode"]],
			["CHECKBOX",LLSTRING(Headlight),_entity getVariable "SSS_lightsOn"],
			["BUTTON",LLSTRING(ShutUp),SHUP_UP_BUTTON_CODE]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SITREP",LLSTRING(SITREP),ICON_SITREP,{
		(_this # 2) call EFUNC(common,sitrep);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]
