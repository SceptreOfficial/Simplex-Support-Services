#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;
		private _classname = "B_UAV_02_F";
		private _callsign = "";

		if (_object isKindOf "Plane") then {
			_classname = typeOf _object;
			_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
		};

		["Add CAS Drone",[
			["EDITBOX","Classname",_classname],
			["EDITBOX","Callsign",_callsign],
			["EDITBOX","Cooldown",str DEFAULT_COOLDOWN_DRONES],
			["EDITBOX","Loiter time",str DEFAULT_LOITER_TIME_DRONES],
			["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""],
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",["Access items","Item classes that permit usage of support. \nSeparate with commas (eg. itemRadio,itemMap)"],"itemMap"],
			["EDITBOX",["Access condition","Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];"],"true"],
			["EDITBOX",["Request approval condition","Code evaluated on a requester's client that must return true for requests to be fulfilled. \n\nPassed arguments: \n0: Position <ARRAY> \n\nAccepted return values: \n0: Approval <BOOL> \n1: Denial reason <STRING>"],"true"]
		],{
			params ["_values"];
			_values params ["_classname","_callsign","_cooldown","_loiterTime","_customInit","_sideSelection","_accessItems","_accessCondition","_requestCondition"];

			[
				_classname,
				_callsign,
				parseNumber _cooldown,
				parseNumber _loiterTime,
				_customInit,
				[west,east,independent] # _sideSelection,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition,
				_requestCondition
			] call EFUNC(support,addCASDrone);

			ZEUS_MESSAGE("CAS Drone added");
		}] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		[
			_logic getVariable ["Classname",""],
			_logic getVariable ["Callsign",""],
			parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_DRONES]),
			parseNumber (_logic getVariable ["LoiterTime",str DEFAULT_LOITER_TIME_DRONES]),
			_logic getVariable ["CustomInit",""],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			STR_TO_ARRAY_LOWER(_logic getVariable [ARR_2("AccessItems","itemRadio")]),
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestApprovalCondition","true"]
		] call EFUNC(support,addCASDrone);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
