#include "script_component.hpp"

[{
	params ["_logic","_synced"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;

		if (!alive _object || _object isKindOf "CAManBase" || _object isKindOf "Logic") exitWith {};

		["Add Transport",[
			["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
			["EDITBOX","Respawn time",str DEFAULT_RESPAWN_TIME],
			["EDITBOX",["Custom init code","Code executed when vehicle is added & respawned (vehicle = _this)"],""]
		],{
			params ["_values","_object"];
			_values params ["_callsign","_respawnTime","_customInit"];

			[
				[],
				_object,
				_callsign,
				parseNumber _respawnTime,
				_customInit
			] call EFUNC(support,addTransport);

			switch (true) do {
				case (_object isKindOf "Plane");
				case (_object isKindOf "Helicopter") : {ZEUS_MESSAGE("Air Transport added");};
				case (_object isKindOf "Ship") : {ZEUS_MESSAGE("Sea Transport added");};
				case (_object isKindOf "LandVehicle") : {ZEUS_MESSAGE("Land Transport added");};
			};
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
				_logic getVariable ["CustomInit",""]
			] call EFUNC(support,addTransport));
		} forEach _vehicles;

		{_x setVariable ["SSS_entitiesToAssign",(_x getVariable ["SSS_entitiesToAssign",[]]) + _entities,true]} forEach _requesterModules;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
