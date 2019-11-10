#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;
		private _classname = "B_T_VTOL_01_vehicle_F";

		if (_object isKindOf "Air") then {
			_classname = typeOf _object;
		};

		["Add Logistics Airdrop",[
			["EDITBOX","Classname",_classname],
			["EDITBOX","Callsign","Logistics Airdrop"],
			["EDITBOX",["Fixed spawn position","In format [x,y] or [x,y,z]. Leave empty to generate random position from request location."],""],
			["EDITBOX",["Spawn delay","Time before air vehicle is spawned after request is submitted"],str DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY],
			["EDITBOX",["Flying height","AGL altitude in meters"],str DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT],
			["EDITBOX",["List function","Code that must return an array of items that can be requested"],"[]"],
			["EDITBOX",["Universal init code","Code executed when request object is spawned"],""],
			["CHECKBOX",["Allow amount input","Allow requesting multiple items"],false],
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX","Cooldown",str DEFAULT_COOLDOWN_LOGISTICS_AIRDROP],
			["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned \n(Vehicle = _this)"],""]
		],{
			(_this # 0) params ["_classname","_callsign","_spawnPosition","_spawnDelay","_flyingHeight","_listFnc","_universalInitFnc","_allowMulti","_sideSelection","_cooldown","_customInit"];
			
			if (_spawnPosition == "") then {
				_spawnPosition = "[]";
			};

			[
				[],
				_classname,
				_callsign,
				parseSimpleArray _spawnPosition,
				parseNumber _spawnDelay,
				parseNumber _flyingHeight,
				_listFnc,
				_universalInitFnc,
				_allowMulti,
				[west,east,independent] # _sideSelection,
				parseNumber _cooldown,
				_customInit
			] call EFUNC(support,addLogisticsAirdrop);

			ZEUS_MESSAGE("Logistics airdrop added");
		}] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		private _requesterModules = [];
		private _requesters = [];

		{
			if (typeOf _x == QGVAR(AssignRequesters)) then {
				_requesterModules pushBack _x;
				_requesters append ((synchronizedObjects _x) select {!(_x isKindOf "Logic")});
			};
		} forEach synchronizedObjects _logic;

		private _spawnPosition = _logic getVariable ["SpawnPosition","[]"];
		if (_spawnPosition == "") then {
			_spawnPosition = "[]";
		};

		private _entity = [
			_requesters,
			_logic getVariable ["Classname",""],
			_logic getVariable ["Callsign",""],
			parseSimpleArray _spawnPosition,
			parseNumber (_logic getVariable ["SpawnDelay",str DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY]),
			parseNumber (_logic getVariable ["FlyingHeight",str DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT]),
			_logic getVariable ["ListFunction","[]"],
			_logic getVariable ["UniversalInitCode",""],
			(_logic getVariable ["AllowMulti",0]) isEqualTo 1,
			[west,east,independent] # (_logic getVariable ["Side",0]),
			parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_LOGISTICS_AIRDROP]),
			_logic getVariable ["CustomInit",""]
		] call EFUNC(support,addLogisticsAirdrop);

		{_x setVariable ["SSS_entitiesToAssign",(_x getVariable ["SSS_entitiesToAssign",[]]) + [_entity],true]} forEach _requesterModules;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
