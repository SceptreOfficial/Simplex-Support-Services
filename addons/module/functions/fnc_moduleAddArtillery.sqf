#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;
		private _ammunitionSet = str [];

		if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

		[LLSTRING(AddArtillery),[
			["EDITBOX",[LLSTRING(CallsignName),LLSTRING(CallsignDescription)],getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
			["EDITBOX",[LLSTRING(AmmunitionSetName),LLSTRING(AmmunitionSetDescription)],_ammunitionSet],
			["EDITBOX",[LLSTRING(RespawnTimeName),LLSTRING(RespawnTimeDescription)],str DEFAULT_RESPAWN_TIME],
			["EDITBOX",[LLSTRING(CooldownName),LLSTRING(CooldownDescription)],str DEFAULT_COOLDOWN_ARTILLERY_MIN],
			["EDITBOX",[LLSTRING(RoundCooldownName),LLSTRING(RoundCooldownDescription)],str DEFAULT_COOLDOWN_ARTILLERY_ROUND],
			["EDITBOX",[LLSTRING(MaxRoundsName),LLSTRING(MaxRoundsDescription)],str DEFAULT_ARTILLERY_MAX_ROUNDS],
			["EDITBOX",[LLSTRING(CoordinationDistanceName),LLSTRING(CoordinationDistanceDescription)],str DEFAULT_ARTILLERY_COORDINATION_DISTANCE],
			["COMBOBOX",[LLSTRING(CoordinationTypeName),LLSTRING(CoordinationTypeDescription)],[[LLSTRING(CoordinationTypeSupport),LLSTRING(CoordinationTypeNonSupport),LLSTRING(CoordinationTypeAll)],0]],
			["EDITBOX",[LLSTRING(CustomInitName),LLSTRING(CustomInitDescription)],""],
			["EDITBOX",[LLSTRING(AccessItemsName),LLSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[LLSTRING(AccessConditionName),LLSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[LLSTRING(RequestApprovalConditionName),LLSTRING(RequestApprovalConditionDescription)],"true"]
		],{
			params ["_values","_object"];
			_values params ["_callsign","_ammunitionSet","_respawnTime","_cooldown","_roundCooldown","_maxRounds","_coordinationDistance","_coordinationType","_customInit","_accessItems","_accessCondition","_requestCondition"];

			[
				_object,
				_callsign,
				_ammunitionSet call EFUNC(common,parseSimpleArray),
				parseNumber _respawnTime,
				[parseNumber _cooldown,parseNumber _roundCooldown],
				parseNumber _maxRounds,
				parseNumber _coordinationDistance,
				_coordinationType,
				_customInit,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition,
				_requestCondition
			] call EFUNC(support,addArtillery);

			ZEUS_MESSAGE(LLSTRING(ZeusArtilleryAdded));
		},{},_object] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		{
			if (alive _x) then {
				[
					_x,
					_logic getVariable ["Callsign",""],
					(_logic getVariable ["AmmunitionSet","[]"]) call EFUNC(common,parseSimpleArray),
					parseNumber (_logic getVariable ["RespawnTime",str DEFAULT_RESPAWN_TIME]),
					[
						parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_ARTILLERY_ROUND]),
						parseNumber (_logic getVariable ["RoundCooldown",str DEFAULT_ARTILLERY_MAX_ROUNDS])
					],
					parseNumber (_logic getVariable ["MaxRounds",str DEFAULT_ARTILLERY_MAX_ROUNDS]),
					parseNumber (_logic getVariable ["CoordinationDistance",str DEFAULT_ARTILLERY_COORDINATION_DISTANCE]),
					_logic getVariable ["CoordinationType",0],
					_logic getVariable ["CustomInit",""],
					STR_TO_ARRAY_LOWER(_logic getVariable [ARR_2("AccessItems","itemRadio")]),
					_logic getVariable ["AccessCondition","true"],
					_logic getVariable ["RequestApprovalCondition","true"]
				] call EFUNC(support,addArtillery);
			};
		} forEach synchronizedObjects _logic;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
