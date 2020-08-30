#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;

		if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

		[localize LSTRING(AddArtillery),[
			["EDITBOX",[localize LSTRING(CallsignName),localize LSTRING(CallsignDescription)],getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
			["EDITBOX",[localize LSTRING(RespawnTimeName),localize LSTRING(RespawnTimeDescription)],str DEFAULT_RESPAWN_TIME],
			["EDITBOX",[localize LSTRING(CooldownName),localize LSTRING(CooldownDescription)],str DEFAULT_COOLDOWN_ARTILLERY_MIN],
			["EDITBOX",[localize LSTRING(RoundCooldownName),localize LSTRING(RoundCooldownDescription)],str DEFAULT_COOLDOWN_ARTILLERY_ROUND],
			["EDITBOX",[localize LSTRING(MaxRoundsName),localize LSTRING(MaxRoundsDescription)],str DEFAULT_ARTILLERY_MAX_ROUNDS],
			["EDITBOX",[localize LSTRING(CoordinationDistanceName),localize LSTRING(CoordinationDistanceDescription)],str DEFAULT_ARTILLERY_COORDINATION_DISTANCE],
			["EDITBOX",[localize LSTRING(CustomInitName),localize LSTRING(CustomInitDescription)],""],
			["EDITBOX",[localize LSTRING(AccessItemsName),localize LSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[localize LSTRING(AccessConditionName),localize LSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[localize LSTRING(RequestApprovalConditionName),localize LSTRING(RequestApprovalConditionDescription)],"true"]
		],{
			params ["_values","_object"];
			_values params ["_callsign","_respawnTime","_cooldown","_roundCooldown","_maxRounds","_coordinationDistance","_customInit","_accessItems","_accessCondition","_requestCondition"];

			[
				_object,
				_callsign,
				parseNumber _respawnTime,
				[parseNumber _cooldown,parseNumber _roundCooldown],
				parseNumber _maxRounds,
				parseNumber _coordinationDistance,
				_customInit,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition,
				_requestCondition
			] call EFUNC(support,addArtillery);

			ZEUS_MESSAGE(localize LSTRING(ZeusArtilleryAdded));
		},{},_object] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		{
			if (alive _x) then {
				[
					_x,
					_logic getVariable ["Callsign",""],
					parseNumber (_logic getVariable ["RespawnTime",str DEFAULT_RESPAWN_TIME]),
					[
						parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_ARTILLERY_ROUND]),
						parseNumber (_logic getVariable ["RoundCooldown",str DEFAULT_ARTILLERY_MAX_ROUNDS])
					],
					parseNumber (_logic getVariable ["MaxRounds",str DEFAULT_ARTILLERY_MAX_ROUNDS]),
					parseNumber (_logic getVariable ["CoordinationDistance",str DEFAULT_ARTILLERY_COORDINATION_DISTANCE]),
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
