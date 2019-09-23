#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	private _object = attachedTo _logic;
	private _classname = "";
	private _callsign = "";

	if (_object isKindOf "Plane") then {
		_classname = typeOf _object;
		_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
	};

	["Add CAS Drone",[
		["EDITBOX","Classname",_classname],
		["EDITBOX","Callsign",_callsign],
		["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
		["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_DRONES_STR],
		["EDITBOX","Loiter time",SSS_DEFAULT_LOITER_TIME_DRONES_STR],
		["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""]
	],{
		params ["_values"];
		_values params ["_classname","_callsign","_sideSelection","_cooldown","_loiterTime"];

		[
			[],
			_classname,
			_callsign,
			[west,east,independent] # _sideSelection,
			parseNumber _cooldown,
			parseNumber _loiterTime
		] call FUNC(addCASDrone);

		ZEUS_MESSAGE("CAS Drone added");
	}] call EFUNC(CDS,dialog);
} else {
	private _requesters = [];

	{
		if (typeOf _x == "SSS_Module_AssignRequesters") then {
			_requesters append ((synchronizedObjects _x) select {!(_x isKindOf "Logic")});
		};
	} forEach synchronizedObjects _logic;

	[
		_requesters,
		_logic getVariable ["Classname",""],
		_logic getVariable ["Callsign",""],
		[west,east,independent] # (_logic getVariable ["Side",0]),
		parseNumber (_logic getVariable ["Cooldown",SSS_DEFAULT_COOLDOWN_DRONES_STR]),
		parseNumber (_logic getVariable ["LoiterTime",SSS_DEFAULT_LOITER_TIME_DRONES_STR]),
		_logic getVariable ["CustomInit",""]
	] call FUNC(addCASDrone);
};

deleteVehicle _logic;