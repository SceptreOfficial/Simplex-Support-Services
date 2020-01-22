#include "script_component.hpp"

[{
	params ["_logic","_synced"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;

		if (!alive _object || !(_object isKindOf "Helicopter")) exitWith {};

		["Add CAS Helicopter",[
			["EDITBOX","Callsign",getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
			["EDITBOX","Respawn time",str DEFAULT_RESPAWN_TIME],
			["EDITBOX",["Custom init code","Code executed when vehicle is added & respawned (vehicle = _this)"],""],
			["EDITBOX",["Access items","Item classes that permit usage of support. \nSeparate with commas (eg. itemRadio,itemMap)"],"itemRadio"],
			["EDITBOX",["Access condition","Code evaluated on a requester's client that must return true for the support to be accessible."],"true"]
		],{
			params ["_values","_object"];
			_values params ["_callsign","_respawnTime","_customInit","_accessItems","_accessCondition"];

			[
				_object,
				_callsign,
				parseNumber _respawnTime,
				_customInit,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition
			] call EFUNC(support,addCASHelicopter);

			ZEUS_MESSAGE("CAS Helicopter added");
		},{},_object] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		{
			if (alive _x) then {
				[
					_x,
					_logic getVariable ["Callsign",""],
					parseNumber (_logic getVariable ["RespawnTime",str DEFAULT_RESPAWN_TIME]),
					_logic getVariable ["CustomInit",""],
					STR_TO_ARRAY_LOWER(_logic getVariable [ARR_2("AccessItems","itemRadio")]),
					_logic getVariable ["AccessCondition","true"]
				] call EFUNC(support,addCASHelicopter);
			};
		} forEach synchronizedObjects _logic;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;