#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB",LLSTRING(RTB),ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportMaritime);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move",LLSTRING(Move),ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_MoveEngOff",LLSTRING(MoveEngineOff),ICON_MOVE_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE_ENG_OFF"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior",LLSTRING(ChangeBehavior),ICON_GEAR,{
		private _entity = _this # 2;

		[LLSTRING(ChangeBehavior),[
			["COMBOBOX",LLSTRING(SpeedMode),[[LLSTRING(Limited),LLSTRING(Normal),LLSTRING(Full)],_entity getVariable "SSS_speedMode"]],
			["COMBOBOX",LLSTRING(CombatMode),[[LLSTRING(FireAtWill),LLSTRING(HoldFire)],_entity getVariable "SSS_combatMode"]],
			["CHECKBOX",LLSTRING(Headlight),_entity getVariable "SSS_lightsOn"],
			["CHECKBOX",LLSTRING(CollisionLights),_entity getVariable "SSS_collisionLightsOn"],
			["BUTTON",LLSTRING(ShutUp),SHUP_UP_BUTTON_CODE]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SITREP",LLSTRING(SITREP),ICON_SITREP,{
		private _entity = _this # 2;
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];
		private _message = format [LLSTRING(LocationGridAndStatus),mapGridPosition _vehicle,switch true do {
			case (!canMove _vehicle) : {LLSTRING(StatusDisabled)};
			case (damage _vehicle > 0) : {LLSTRING(StatusDamaged)};
			default {LLSTRING(StatusGreen)};
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
