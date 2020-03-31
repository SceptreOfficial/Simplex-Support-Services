#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;

		if (!alive _object || !(_object isKindOf "AllVehicles")) exitWith {};

		["Add Artillery",[
			["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
			["EDITBOX","Respawn time",str DEFAULT_RESPAWN_TIME],
			["EDITBOX","Cooldown",str DEFAULT_COOLDOWN_ARTILLERY_MIN],
			["EDITBOX","Extra cooldown time per round",str DEFAULT_COOLDOWN_ARTILLERY_ROUND],
			["EDITBOX","Maximum rounds per request",str DEFAULT_ARTILLERY_MAX_ROUNDS],
			["EDITBOX",["Maximum coordination distance","Set what ""nearby"" really means for artillery coordination"],str DEFAULT_ARTILLERY_COORDINATION_DISTANCE],
			["COMBOBOX",["Coordinate with","Set what kind of artillery to coordinate with"],[["Support entities only (requires access)","Non-support entities only","Any nearby batteries (supports require access)"],0]],
			["EDITBOX",["Custom init code","Code executed when vehicle is added & respawned (vehicle = _this)"],""],
			["EDITBOX",["Access items","Item classes that permit usage of support. \nSeparate with commas (eg. itemRadio,itemMap)"],"itemMap"],
			["EDITBOX",["Access condition","Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];"],"true"],
			["EDITBOX",["Request approval condition","Code evaluated on a requester's client that must return true for requests to be fulfilled. \n\nPassed arguments: \n0: Position <ARRAY> \n\nAccepted return values: \n0: Approval <BOOL> \n1: Denial reason <STRING>"],"true"]
		],{
			params ["_values","_object"];
			_values params ["_callsign","_respawnTime","_cooldown","_roundCooldown","_maxRounds","_coordinationDistance","_coordinationType","_customInit","_accessItems","_accessCondition","_requestCondition"];

			[
				_object,
				_callsign,
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

			ZEUS_MESSAGE("Artillery added");
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
