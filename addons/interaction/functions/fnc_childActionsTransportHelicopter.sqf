#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_SignalConfirm",localize LSTRING(ConfirmSignal),ICON_LAND_GREEN,{
		private _entity = _this # 2;
		_entity setVariable ["SSS_signalApproved",true,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SignalDeny",localize LSTRING(SearchNewSignal),ICON_SEARCH_YELLOW,{
		private _entity = _this # 2;
		_entity setVariable ["SSS_signalApproved",false,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
	},{(_this # 2) getVariable "SSS_needConfirmation"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SlingLoadSelect",localize LSTRING(SelectObjectSlingLoad),[ICON_SLINGLOAD,HEX_GREEN],{
		params ["_target","_player","_entity"];

		private _vehicle = _entity getVariable "SSS_vehicle";
		private _position = _entity getVariable ["SSS_slingLoadPosition",getPos _vehicle];
		private _objects = (nearestObjects [_position,SSS_slingLoadWhitelist,SSS_setting_slingLoadSearchRadius]) select {
			_vehicle canSlingLoad _x && {side _vehicle getFriend side _x >= 0.6}
		};

		if (_objects isEqualTo []) exitWith {
			NOTIFY_LOCAL(_entity,localize LSTRING(NoSlingLoadableObjects));
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
			["LISTNBOX",localize LSTRING(SlingLoadableObjects),[_rows,0,12]]
		],{
			params ["_values","_args"];
			_values params ["_index"];
			_args params ["_entity","_objects"];

			_entity setVariable ["SSS_slingLoadObject",_objects # _index,true];
			_entity setVariable ["SSS_slingLoadReady",false,true];
		},{},[_entity,_objects]] call EFUNC(CDS,dialog);
	},{(_this # 2) getVariable "SSS_slingLoadReady"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Unhook",localize LSTRING(Unhook,[ICON_SLINGLOAD,HEX_YELLOW],{
		_this call FUNC(selectPosition);
	},{!isNull getSlingLoad (_this # 2 # 0 getVariable "SSS_vehicle")},{},[_entity,"UNHOOK"]] call ace_interact_menu_fnc_createAction,[],_target],
	
	[["SSS_RTB",localize LSTRING(RTB),ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportHelicopter);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Pickup",localize LSTRING(Pickup),ICON_SMOKE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"PICKUP"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Land",localize LSTRING(Land),ICON_LAND,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LAND"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_LandEngOff",localize LSTRING(LandEngineOff),ICON_LAND_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LAND_ENG_OFF"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move",localize LSTRING(Move),ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Hover",localize LSTRING(HoverFastrope),ICON_ROPE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"HOVER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter",localize LSTRING(Loiter),ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LOITER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SlingLoad",localize LSTRING(SlingLoad),ICON_SLINGLOAD,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"SLINGLOAD"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Paradrop",localize LSTRING(Paradrop),ICON_PARACHUTE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"PARADROP"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior",localize LSTRING(ChangeBehavior),ICON_GEAR,{
		private _entity = _this # 2;

		["Change Behavior",[
			["SLIDER",localize LSTRING(FlyingHeight),[[40,2000,0],_entity getVariable "SSS_flyingHeight"]],
			["COMBOBOX",localize LSTRING(SpeedMode),[[localize LSTRING(Limited),localize LSTRING(Normal),localize LSTRING(Full)],_entity getVariable "SSS_speedMode"]],
			["COMBOBOX",localize LSTRING(CombatMode),[[localize LSTRING(FireAtWill),localize LSTRING(HoldFire)],_entity getVariable "SSS_combatMode"]],
			["CHECKBOX",localize LSTRING(Headlight),_entity getVariable "SSS_lightsOn"],
			["CHECKBOX",localize LSTRING(CollisionLights),_entity getVariable "SSS_collisionLightsOn"],
			["BUTTON",localize LSTRING(ShutUp),SHUP_UP_BUTTON_CODE]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SITREP",localize LSTRING(SITREP),ICON_SITREP,{
		private _entity = _this # 2;
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];
		private _message = format [localize LSTRING(LocationGridAndStatus),mapGridPosition _vehicle,switch true do {
			case (!canMove _vehicle) : {localize LSTRING(StatusDisabled)};
			case (damage _vehicle > 0) : {localize LSTRING(StatusDamaged)};
			default {localize LSTRING(StatusGreen)};
		}];

		NOTIFY_LOCAL(_entity,_message);

		private _marker = createMarkerLocal [format ["SSS_%1$%2$%3",_vehicle,CBA_missionTime,random 1],getPos _vehicle];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "mil_box";
		_marker setMarkerColorLocal "ColorGrey";
		_marker setMarkerTextLocal (_entity getVariable "SSS_callsign");
		_marker setMarkerAlphaLocal 1;
		
		[{
			params ["_args","_PFHID"];
			_args params ["_vehicle","_marker"];

			private _alpha = markerAlpha _marker - 0.005;
			_marker setMarkerAlphaLocal _alpha;

			if (alive _vehicle) then {
				_marker setMarkerPosLocal getPosVisual _vehicle;
			};

			if (_alpha <= 0) then {
				_PFHID call CBA_fnc_removePerFrameHandler;
				deleteMarkerLocal _marker;
			};
		},0.1,[_vehicle,_marker]] call CBA_fnc_addPerFrameHandler;
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]
