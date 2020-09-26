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

		[LLSTRING(AddCASPlane),[
			["EDITBOX",[LLSTRING(ClassnameName),LLSTRING(ClassnameCASPlaneDescription)],_classname],
			["EDITBOX",[LLSTRING(CallsignName),LLSTRING(CallsignDescription)],_callsign],
			["EDITBOX",[LLSTRING(WeaponSetName),LLSTRING(WeaponSetDescription)],_weaponSet],
			["EDITBOX",[LLSTRING(CooldownName),LLSTRING(CooldownCASDescription)],str DEFAULT_COOLDOWN_PLANES],
			["EDITBOX",[LLSTRING(CustomInitName),LLSTRING(CustomInitDescription)],""],
			["COMBOBOX",[LLSTRING(SideName),LLSTRING(SideDescription)],[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",[LLSTRING(AccessItemsName),LLSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[LLSTRING(AccessConditionName),LLSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[LLSTRING(RequestApprovalConditionName),LLSTRING(RequestApprovalConditionDescription)],"true"]
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

			ZEUS_MESSAGE(LLSTRING(ZeusCASPlaneAdded));
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
