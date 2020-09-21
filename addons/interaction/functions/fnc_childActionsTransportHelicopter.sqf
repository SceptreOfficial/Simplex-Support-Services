#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_SignalConfirm",LLSTRING(ConfirmSignal),ICON_LAND_GREEN,{
		private _entity = _this # 2;
		_entity setVariable ["SSS_signalApproved",true,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SignalDeny",LLSTRING(SearchNewSignal),ICON_SEARCH_YELLOW,{
		private _entity = _this # 2;
		_entity setVariable ["SSS_signalApproved",false,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SlingLoadSelect",LLSTRING(SelectObjectSlingLoad),[ICON_SLINGLOAD,HEX_GREEN],{
		params ["_target","_player","_entity"];

		private _vehicle = _entity getVariable "SSS_vehicle";
		private _position = _entity getVariable ["SSS_slingLoadPosition",getPos _vehicle];
		private _objects = (nearestObjects [_position,SSS_slingLoadWhitelist,SSS_setting_slingLoadSearchRadius]) select {
			_vehicle canSlingLoad _x && {side _vehicle getFriend side _x >= 0.6}
		};

		if (_objects isEqualTo []) exitWith {
			NOTIFY_LOCAL(_entity,{LLSTRING(NoSlingLoadableObjects)});
		};

		private _cfgVehicles = configFile >> "CfgVehicles";
		private _rows = [];
		
		{
			private _cfg = _cfgVehicles >> typeOf _x;
			private _name = getText (_cfg >> "displayName");
			private _icon = getText (_cfg >> "picture");

			if (toLower _icon in ["","picturething"]) then {
				_icon = ICON_BOX;
			};

			_rows pushBack [[_name,_icon],"","","",str (_x distance _position) + "m"];
		} forEach _objects;

		[LLSTRING(SelectObject),[
			["LISTNBOX",LLSTRING(SlingLoadableObjects),[_rows,0,12]]
		],{
			params ["_values","_args"];
			_values params ["_index"];
			_args params ["_entity","_objects"];

			_entity setVariable ["SSS_slingLoadObject",_objects # _index,true];
			_entity setVariable ["SSS_slingLoadReady",false,true];
		},{},[_entity,_objects]] call EFUNC(CDS,dialog);
	},{(_this # 2) getVariable "SSS_slingLoadReady"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Unhook",LLSTRING(Unhook),[ICON_SLINGLOAD,HEX_YELLOW],{
		_this call FUNC(selectPosition);
	},{!isNull getSlingLoad (_this # 2 # 0 getVariable "SSS_vehicle")},{},[_entity,"UNHOOK"]] call ace_interact_menu_fnc_createAction,[],_target],
	
	[["SSS_RTB",LLSTRING(RTB),ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportHelicopter);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Pickup",LLSTRING(Pickup),ICON_SMOKE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"PICKUP"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Land",LLSTRING(Land),ICON_LAND,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LAND"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_LandEngOff",LLSTRING(LandEngineOff),ICON_LAND_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LAND_ENG_OFF"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move",LLSTRING(Move),ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Hover",LLSTRING(HoverFastrope),ICON_ROPE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"HOVER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter",LLSTRING(Loiter),ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LOITER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SlingLoad",LLSTRING(SlingLoad),ICON_SLINGLOAD,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"SLINGLOAD"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Paradrop",LLSTRING(Paradrop),ICON_PARACHUTE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"PARADROP"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior",LLSTRING(ChangeBehavior),ICON_GEAR,{
		private _entity = _this # 2;

		[LLSTRING(ChangeBehavior),[
			["SLIDER",LLSTRING(FlyingHeight),[[0,2000,0],_entity getVariable "SSS_flyingHeight"]],
			["COMBOBOX",LLSTRING(SpeedMode),[[LLSTRING(SpeedLimited),LLSTRING(SpeedNormal),LLSTRING(SpeedFull)],_entity getVariable "SSS_speedMode"]],
			["COMBOBOX",LLSTRING(CombatMode),[[LLSTRING(FireAtWill),LLSTRING(HoldFire)],_entity getVariable "SSS_combatMode"]],
			["CHECKBOX",LLSTRING(Headlight),_entity getVariable "SSS_lightsOn"],
			["CHECKBOX",LLSTRING(CollisionLights),_entity getVariable "SSS_collisionLightsOn"],
			["BUTTON",LLSTRING(ShutUp),SHUP_UP_BUTTON_CODE]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SITREP",LLSTRING(SITREP),ICON_SITREP,{
		(_this # 2) call EFUNC(common,sitrep);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]
