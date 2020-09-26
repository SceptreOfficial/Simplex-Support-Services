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

	[["SSS_SlingLoadSelect","Select object to sling load",[ICON_SLINGLOAD,HEX_GREEN],{
		params ["_target","_player","_entity"];

		private _vehicle = _entity getVariable "SSS_vehicle";
		private _position = _entity getVariable ["SSS_slingLoadPosition",getPos _vehicle];
		private _objects = (nearestObjects [_position,SSS_slingLoadWhitelist,SSS_setting_slingLoadSearchRadius]) select {
			_vehicle canSlingLoad _x && {side _vehicle getFriend side _x >= 0.6}
		};

		if (_objects isEqualTo []) exitWith {
			NOTIFY_LOCAL(_entity,"No sling loadable objects nearby.");
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

		["Select object",[
			["LISTNBOX","Sling loadable objects:",[_rows,0,12]]
		],{
			params ["_values","_args"];
			_values params ["_index"];
			_args params ["_entity","_objects"];

			_entity setVariable ["SSS_slingLoadObject",_objects # _index,true];
			_entity setVariable ["SSS_slingLoadReady",false,true];
		},{},[_entity,_objects]] call EFUNC(CDS,dialog);
	},{(_this # 2) getVariable "SSS_slingLoadReady"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Unhook","Unhook",[ICON_SLINGLOAD,HEX_YELLOW],{
		_this call FUNC(selectPosition);
	},{!isNull getSlingLoad (_this # 2 # 0 getVariable "SSS_vehicle")},{},[_entity,"UNHOOK"]] call ace_interact_menu_fnc_createAction,[],_target],
	
	[["SSS_RTB","RTB",ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportHelicopter);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Pickup","Pickup",ICON_SMOKE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"PICKUP"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Land","Land",ICON_LAND,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LAND"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_LandEngOff","Land - Engine Off",ICON_LAND_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LAND_ENG_OFF"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move","Move",ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Hover","Hover/Fastrope",ICON_ROPE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"HOVER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter","Loiter",ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LOITER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SlingLoad","Sling Load",ICON_SLINGLOAD,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"SLINGLOAD"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Paradrop","Paradrop",ICON_PARACHUTE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"PARADROP"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior","Change Behavior",ICON_GEAR,{
		private _entity = _this # 2;

		["Change Behavior",[
			["SLIDER","Flying height",[[0,2000,0],_entity getVariable "SSS_flyingHeight"]],
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
