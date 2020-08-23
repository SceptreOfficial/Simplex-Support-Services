#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB",localize LSTRING(RTB),ICON_HOME,{
		(_this # 2) call EFUNC(support,requestCASHelicopter);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SAD",localize LSTRING(SAD),ICON_TARGET,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"SAD"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move",localize LSTRING(Move),ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Loiter",localize LSTRING(Loiter),ICON_LOITER,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"LOITER"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior",localize LSTRING(ChangeBehavior),ICON_GEAR,{
		private _entity = _this # 2;

		[localize LSTRING(ChangeBehavior),[
			["SLIDER",localize LSTRING(FlyingHeight),[[40,2000,0],_entity getVariable "SSS_flyingHeight"]],
			["CHECKBOX",localize LSTRING(Headlight),_entity getVariable "SSS_lightsOn"],
			["CHECKBOX",localize LSTRING(CollisionLights),_entity getVariable "SSS_collisionLightsOn"]
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
