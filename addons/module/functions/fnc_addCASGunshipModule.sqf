#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	["Add CAS Gunship",[
		["EDITBOX","Callsign","Blackfish"],
		["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
		["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_GUNSHIPS],
		["EDITBOX","Loiter time",SSS_DEFAULT_LOITER_TIME_GUNSHIPS]
	],{
		params ["_values"];
		_values params ["_callsign","_sideSelection","_cooldown","_loiterTime"];

		[_callsign,[west,east,independent] # _sideSelection,parseNumber _cooldown,parseNumber _loiterTime] call EFUNC(service,addCASGunship);

		ZEUS_MESSAGE("CAS gunship added")
	}] call EFUNC(CDS,dialog);
} else {
	[
		_logic getVariable ["Callsign",""],
		[west,east,independent] # (_logic getVariable ["Side",0]),
		parseNumber (_logic getVariable ["Cooldown","90"]),
		parseNumber (_logic getVariable ["LoiterTime","8"])
	] call EFUNC(service,addCASGunship);
};

deleteVehicle _logic;
