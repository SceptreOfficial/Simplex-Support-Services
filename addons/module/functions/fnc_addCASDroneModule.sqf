#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	private _object = attachedTo _logic;
	["",""] params ["_classname","_callsign"];

	if (_object isKindOf "AllVehicles") then {
		_classname = typeOf _object;
		_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
	};

	["Add CAS Drone",[
		["EDITBOX","Classname",_classname],
		["EDITBOX","Callsign",_callsign],
		["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
		["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_DRONES],
		["EDITBOX","Loiter time",SSS_DEFAULT_LOITER_TIME_DRONES]
	],{
		params ["_values"];
		_values params ["_classname","_callsign","_sideSelection","_cooldown","_loiterTime"];

		[_classname,_callsign,[west,east,independent] # _sideSelection,parseNumber _cooldown,parseNumber _loiterTime] call EFUNC(service,addCASDrone);

		ZEUS_MESSAGE("CAS drone added")
	}] call EFUNC(CDS,dialog);
} else {
	[
		_logic getVariable ["Classname",""],
		_logic getVariable ["Callsign",""],
		[west,east,independent] # (_logic getVariable ["Side",0]),
		parseNumber (_logic getVariable ["Cooldown","90"]),
		parseNumber (_logic getVariable ["LoiterTime","8"])
	] call EFUNC(service,addCASDrone);
};

deleteVehicle _logic;
