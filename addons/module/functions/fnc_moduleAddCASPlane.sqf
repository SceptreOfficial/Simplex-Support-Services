#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;
		private _classname = "B_Plane_CAS_01_F";
		private _callsign = "";
		private _weaponSet = str ["Gatling_30mm_Plane_CAS_01_F","Rocket_04_HE_Plane_CAS_01_F","Bomb_04_Plane_CAS_01_F"];

		if (_object isKindOf "Plane") then {
			_classname = typeOf _object;
			_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
			_weaponSet = str ((weapons _object) select {
				toLower ((_x call BIS_fnc_itemType) # 1) in ["machinegun","rocketlauncher","missilelauncher","bomblauncher"]
			});
		};

		["Add CAS Plane",[
			["EDITBOX","Classname",_classname],
			["EDITBOX","Callsign",_callsign],
			["EDITBOX",["Weapon set","Array of weapon classnames or array of [weapon,magazine] arrays. Empty array for vehicle defaults"],_weaponSet],
			["EDITBOX","Cooldown",str DEFAULT_COOLDOWN_PLANES],
			["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""],
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",["Access items","Item classes that permit usage of support. \nSeparate with commas (eg. itemRadio,itemMap)"],"itemMap"],
			["EDITBOX",["Access condition","Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];"],"true"],
			["EDITBOX",["Request approval condition","Code evaluated on a requester's client that must return true for requests to be fulfilled. \n\nPassed arguments: \n0: Position <ARRAY> \n\nAccepted return values: \n0: Approval <BOOL> \n1: Denial reason <STRING>"],"true"]
		],{
			params ["_values"];
			_values params ["_classname","_callsign","_weaponSet","_cooldown","_customInit","_sideSelection","_accessItems","_accessCondition","_requestCondition"];

			[
				_classname,
				_callsign,
				_weaponSet call EFUNC(common,parseSimpleArray),
				parseNumber _cooldown,
				_customInit,
				[west,east,independent] # _sideSelection,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition,
				_requestCondition
			] call EFUNC(support,addCASPlane);

			ZEUS_MESSAGE("CAS Plane added");
		}] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		[
			_logic getVariable ["Classname",""],
			_logic getVariable ["Callsign",""],
			(_logic getVariable ["WeaponSet","[]"]) call EFUNC(common,parseSimpleArray),
			parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_PLANES]),
			_logic getVariable ["CustomInit",""],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			STR_TO_ARRAY_LOWER(_logic getVariable [ARR_2("AccessItems","itemRadio")]),
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestApprovalCondition","true"]
		] call EFUNC(support,addCASPlane);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
