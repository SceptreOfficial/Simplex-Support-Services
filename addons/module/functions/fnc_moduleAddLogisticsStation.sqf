#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		[localize LSTRING(AddLogisticsStation),[
			["EDITBOX",localize LSTRING(SpawnDirectionName),"0"],
			["EDITBOX",[localize LSTRING(CallsignName),localize LSTRING(CallsignDescription)],localize LSTRING(CallsignAddLogisticsStationDefaultValue)],
			["EDITBOX",[localize LSTRING(ListFunctionName),localize LSTRING(ListFunctionDescription)],"[]"],
			["EDITBOX",[localize LSTRING(UniversalInitCodeName),localize LSTRING(UniversalInitCodeDescription)],""],
			["COMBOBOX",[localize LSTRING(SideName),localize LSTRING(SideDescription)],[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",[localize LSTRING(AccessItemsName),localize LSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[localize LSTRING(AccessConditionName),localize LSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[localize LSTRING(RequestApprovalConditionName),localize LSTRING(RequestApprovalConditionDescription)],"true"]
		],{
			params ["_values","_spawnPosASL"];
			_values params ["_spawnDir","_callsign","_listFnc","_universalInitFnc","_sideSelection","_accessItems","_accessCondition","_requestCondition"];

			[
				_spawnPosASL,
				parseNumber _spawnDir,
				_callsign,
				_listFnc,
				_universalInitFnc,
				[west,east,independent] # _sideSelection,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition,
				_requestCondition
			] call EFUNC(support,addLogisticsStation);

			ZEUS_MESSAGE(localize LSTRING(ZeusLogisticsStationAdded));
		},{},getPosASL _logic] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		private _entity = [
			getPosASL _logic,
			getDir _logic,
			_logic getVariable ["Callsign",""],
			_logic getVariable ["ListFunction","[]"],
			_logic getVariable ["UniversalInitCode",""],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			STR_TO_ARRAY_LOWER(_logic getVariable [ARR_2("AccessItems","itemRadio")]),
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestApprovalCondition","true"]
		] call EFUNC(support,addLogisticsStation);

		{
			private _ID = ["SSS_logisticsStationBooth",[_entity,_x]] call CBA_fnc_globalEventJIP;
			[_ID,_x] call CBA_fnc_removeGlobalEventJIP;
		} forEach synchronizedObjects _logic;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
