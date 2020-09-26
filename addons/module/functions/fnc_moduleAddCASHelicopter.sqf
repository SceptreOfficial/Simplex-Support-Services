#include "script_component.hpp"

[{
	params ["_logic","_synced"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;

		if (!alive _object || !(_object isKindOf "Helicopter")) exitWith {};

		[LLSTRING(AddCASHelicopter),[
			["EDITBOX",[LLSTRING(CallsignName),LLSTRING(CallsignDescription)],getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
			["EDITBOX",[LLSTRING(RespawnTimeName),LLSTRING(RespawnTimeDescription)],str DEFAULT_RESPAWN_TIME],
			["EDITBOX",[LLSTRING(CustomInitName),LLSTRING(CustomInitDescription)],""],
			["EDITBOX",[LLSTRING(AccessItemsName),LLSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[LLSTRING(AccessConditionName),LLSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[LLSTRING(RequestApprovalConditionName),LLSTRING(RequestApprovalConditionDescription)],"true"]
		],{
			params ["_values","_object"];
			_values params ["_callsign","_respawnTime","_customInit","_accessItems","_accessCondition","_requestCondition"];

			[
				_object,
				_callsign,
				parseNumber _respawnTime,
				_customInit,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition,
				_requestCondition
			] call EFUNC(support,addCASHelicopter);

			ZEUS_MESSAGE(LLSTRING(ZeusCASHelicopterAdded));
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
					_logic getVariable ["AccessCondition","true"],
					_logic getVariable ["RequestApprovalCondition","true"]
				] call EFUNC(support,addCASHelicopter);
			};
		} forEach synchronizedObjects _logic;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
