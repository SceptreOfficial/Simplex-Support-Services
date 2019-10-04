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
			["EDITBOX","Respawn time",SSS_DEFAULT_RESPAWN_TIME_STR],
			["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN_STR],
			["EDITBOX","Extra cooldown time per round",SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND_STR],
			["EDITBOX","Maximum rounds per request",SSS_DEFAULT_ARTILLERY_MAX_ROUNDS_STR],
			["EDITBOX",["Maximum coordination distance","Set what ""nearby"" really means for artillery coordination"],SSS_DEFAULT_ARTILLERY_COORDINATION_DISTANCE_STR],
			["EDITBOX",["Custom init code","Code executed when vehicle is added & respawned (vehicle = _this)"],""]
		],{
			params ["_values","_object"];
			_values params ["_callsign","_respawnTime","_cooldown","_roundCooldown","_maxRounds","_coordinationDistance","_customInit"];

			[
				[],
				_object,
				_callsign,
				parseNumber _respawnTime,
				[parseNumber _cooldown,parseNumber _roundCooldown],
				parseNumber _maxRounds,
				parseNumber _coordinationDistance,
				_customInit
			] call EFUNC(support,addArtillery);

			ZEUS_MESSAGE("Artillery added");
		},{},_object] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		private _requesterModules = [];
		private _requesters = [];
		private _vehicles = [];

		{
			if (typeOf _x == QGVAR(AssignRequesters)) then {
				_requesterModules pushBack _x;
				_requesters append ((synchronizedObjects _x) select {!(_x isKindOf "Logic")});
			} else {
				if (alive _x) then {
					_vehicles pushBackUnique _x;
				};
			};
		} forEach synchronizedObjects _logic;

		if (_vehicles isEqualTo []) exitWith {};

		private _entities = [];

		{
			_entities pushBack ([
				_requesters,
				_x,
				_logic getVariable ["Callsign",""],
				parseNumber (_logic getVariable ["RespawnTime",SSS_DEFAULT_RESPAWN_TIME_STR]),
				[
					parseNumber (_logic getVariable ["Cooldown",SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND_STR]),
					parseNumber (_logic getVariable ["RoundCooldown",SSS_DEFAULT_ARTILLERY_MAX_ROUNDS_STR])
				],
				parseNumber (_logic getVariable ["MaxRounds",SSS_DEFAULT_ARTILLERY_MAX_ROUNDS_STR]),
				parseNumber (_logic getVariable ["CoordinationDistance",SSS_DEFAULT_ARTILLERY_COORDINATION_DISTANCE_STR]),
				_logic getVariable ["CustomInit",""]
			] call EFUNC(support,addArtillery));
		} forEach _vehicles;

		{_x setVariable ["SSS_entitiesToAssign",(_x getVariable ["SSS_entitiesToAssign",[]]) + _entities,true]} forEach _requesterModules;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;