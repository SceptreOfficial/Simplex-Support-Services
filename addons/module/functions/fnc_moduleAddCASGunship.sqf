#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;
		private _classname = "B_T_VTOL_01_armed_F";
		private _callsign = "Blackfish";

		if (_object isKindOf "Plane") then {
			_classname = typeOf _object;
			_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
		};

		["Add CAS Gunship",[
			["EDITBOX","Classname",_classname],
			["EDITBOX",["Turret path","Turret path to gunner"],"[1]"],
			["EDITBOX","Callsign",_callsign],
			["EDITBOX","Cooldown",str DEFAULT_COOLDOWN_GUNSHIPS],
			["EDITBOX","Loiter time",str DEFAULT_LOITER_TIME_GUNSHIPS],
			["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""],
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",["Access items","Item classes that permit usage of support. \nSeparate with commas (eg. itemRadio,itemMap)"],"itemRadio"],
			["EDITBOX",["Access condition","Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];"],"true"]
		],{
			params ["_values"];
			_values params ["_classname","_turretPath","_callsign","_cooldown","_loiterTime","_customInit","_sideSelection","_accessItems","_accessCondition"];

			[
				_classname,
				parseSimpleArray _turretPath,
				_callsign,
				parseNumber _cooldown,
				parseNumber _loiterTime,
				_customInit,
				[west,east,independent] # _sideSelection,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition
			] call EFUNC(support,addCASGunship);

			ZEUS_MESSAGE("CAS Gunship added");
		}] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		[
			_logic getVariable ["Classname","B_T_VTOL_01_armed_F"],
			parseSimpleArray (_logic getVariable ["TurretPath","[1]"]),
			_logic getVariable ["Callsign",""],
			parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_GUNSHIPS]),
			parseNumber (_logic getVariable ["LoiterTime",str DEFAULT_LOITER_TIME_GUNSHIPS]),
			_logic getVariable ["CustomInit",""],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			STR_TO_ARRAY_LOWER(_logic getVariable [ARR_2("AccessItems","itemRadio")]),
			_logic getVariable ["AccessCondition","true"]
		] call EFUNC(support,addCASGunship);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
