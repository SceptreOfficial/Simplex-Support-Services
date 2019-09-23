#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	["Add CAS Gunship",[
		["EDITBOX","Callsign","Blackfish"],
		["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
		["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_GUNSHIPS_STR],
		["EDITBOX","Loiter time",SSS_DEFAULT_LOITER_TIME_GUNSHIPS_STR],
		["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""]
	],{
		params ["_values"];
		_values params ["_callsign","_sideSelection","_cooldown","_loiterTime"];

		[
			[],
			_callsign,
			[west,east,independent] # _sideSelection,
			parseNumber _cooldown,
			parseNumber _loiterTime
		] call FUNC(addCASGunship);

		ZEUS_MESSAGE("CAS Gunship added");
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
		_logic getVariable ["Callsign",""],
		[west,east,independent] # (_logic getVariable ["Side",0]),
		parseNumber (_logic getVariable ["Cooldown",SSS_DEFAULT_COOLDOWN_GUNSHIPS_STR]),
		parseNumber (_logic getVariable ["LoiterTime",SSS_DEFAULT_LOITER_TIME_GUNSHIPS_STR]),
		_logic getVariable ["CustomInit",""]
	] call FUNC(addCASGunship);
};

deleteVehicle _logic;
