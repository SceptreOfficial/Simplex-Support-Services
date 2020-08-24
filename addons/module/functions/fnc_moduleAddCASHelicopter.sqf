#include "script_component.hpp"

[{
	params ["_logic","_synced"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;

		if (!alive _object || !(_object isKindOf "Helicopter")) exitWith {};

		[localize LSTRING(AddCASHelicopter),[
			["EDITBOX",[localize LSTRING(CallsignName),localize LSTRING(CallsignDescription)],getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName")],
			["EDITBOX",[localize LSTRING(RespawnTimeName),localize LSTRING(RespawnTimeDescription)],str DEFAULT_RESPAWN_TIME],
			["EDITBOX",[localize LSTRING(CustomInitName),localize LSTRING(CustomInitDescription)],""],
			["EDITBOX",[localize LSTRING(AccessItemsName),localize LSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[localize LSTRING(AccessConditionName),localize LSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[localize LSTRING(RequestApprovalConditionName),localize LSTRING(RequestApprovalConditionDescription)],"true"]
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

			ZEUS_MESSAGE(localize LSTRING(ZeusCASHelicopterAdded));
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
