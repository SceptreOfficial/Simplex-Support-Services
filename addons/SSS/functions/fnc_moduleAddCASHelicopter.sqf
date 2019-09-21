#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	private _object = attachedTo _logic;

	if (!alive _object || !(_object isKindOf "Helicopter")) exitWith {};

	["Add CAS Helicopter",[
		["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
		["EDITBOX","Respawn time",SSS_DEFAULT_RESPAWN_TIME_STR],
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
		] call FUNC(addCASHelicopter);

		ZEUS_MESSAGE("CAS Helicopter added");
	},{},_object] call EFUNC(CDS,dialog);
} else {
	private _requesters = [];
	private _vehicles = [];

	{
		if (typeOf _x == "SSS_Module_AssignRequesters") then {
			_requesters append ((synchronizedObjects _x) select {!(_x isKindOf "Logic")});
		} else {
			if (alive _x) then {
				_vehicles pushBackUnique _x;
			};
		};
	} forEach synchronizedObjects _logic;

	if (_vehicles isEqualTo []) exitWith {};

	{
		[
			_requesters,
			_x,
			_logic getVariable ["Callsign",""],
			parseNumber (_logic getVariable ["RespawnTime",SSS_DEFAULT_RESPAWN_TIME_STR]),
			_logic getVariable ["CustomInit",""]
		] call FUNC(addCASHelicopter);
	} forEach _vehicles;
};

deleteVehicle _logic;
