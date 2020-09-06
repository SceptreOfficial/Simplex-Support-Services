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

		[LLSTRING(AddCASDrone),[
			["EDITBOX",[LLSTRING(ClassnameName),LLSTRING(ClassnameCASDroneDescription)],_classname],
			["EDITBOX",[LLSTRING(CallsignName),LLSTRING(CallsignDescription)],_callsign],
			["EDITBOX",[LLSTRING(CooldownName),LLSTRING(CooldownCASDescription)],str DEFAULT_COOLDOWN_DRONES],
			["EDITBOX",[LLSTRING(LoiterTimeName),LLSTRING(LoiterTimeDescription)],str DEFAULT_LOITER_TIME_DRONES],
			["EDITBOX",[LLSTRING(CustomInitName),LLSTRING(CustomInitDescription)],""],
			["COMBOBOX",[LLSTRING(SideName),LLSTRING(SideDescription)],[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",[LLSTRING(AccessItemsName),LLSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[LLSTRING(AccessConditionName),LLSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[LLSTRING(RequestApprovalConditionName),LLSTRING(RequestApprovalConditionDescription)],"true"]
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

			ZEUS_MESSAGE(LLSTRING(ZeusCASDroneAdded));
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
