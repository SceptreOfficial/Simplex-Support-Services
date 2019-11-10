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
				parseNumber (_logic getVariable ["RespawnTime",str DEFAULT_RESPAWN_TIME]),
				[
					parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_ARTILLERY_ROUND]),
					parseNumber (_logic getVariable ["RoundCooldown",str DEFAULT_ARTILLERY_MAX_ROUNDS])
				],
				parseNumber (_logic getVariable ["MaxRounds",str DEFAULT_ARTILLERY_MAX_ROUNDS]),
				parseNumber (_logic getVariable ["CoordinationDistance",str DEFAULT_ARTILLERY_COORDINATION_DISTANCE]),
				_logic getVariable ["CustomInit",""]
			] call EFUNC(support,addArtillery));
		} forEach _vehicles;

		{_x setVariable ["SSS_entitiesToAssign",(_x getVariable ["SSS_entitiesToAssign",[]]) + _entities,true]} forEach _requesterModules;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;