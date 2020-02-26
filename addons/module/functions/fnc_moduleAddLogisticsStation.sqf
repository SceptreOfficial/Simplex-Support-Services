#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		["Add Logistics Station",[
			["EDITBOX","Spawn direction","0"],
			["EDITBOX","Callsign","Logistics Station"],
			["EDITBOX",["List function","Code that must return an array of items that can be requested"],"[]"],
			["EDITBOX",["Universal init code","Code executed when request object is spawned"],""],
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",["Access items","Item classes that permit usage of support. \nSeparate with commas (eg. itemRadio,itemMap)"],"itemRadio"],
			["EDITBOX",["Access condition","Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];"],"true"]
		],{
			params ["_values","_spawnPosASL"];
			_values params ["_spawnDir","_callsign","_listFnc","_universalInitFnc","_sideSelection","_accessItems","_accessCondition"];

			[
				_spawnPosASL,
				parseNumber _spawnDir,
				_callsign,
				_listFnc,
				_universalInitFnc,
				[west,east,independent] # _sideSelection,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition
			] call EFUNC(support,addLogisticsStation);

			ZEUS_MESSAGE("Logistics station added");
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
			_logic getVariable ["AccessCondition","true"]
		] call EFUNC(support,addLogisticsStation);

		{
			private _ID = ["SSS_logisticsStationBooth",[_entity,_x]] call CBA_fnc_globalEventJIP;
			[_ID,_x] call CBA_fnc_removeGlobalEventJIP;
		} forEach synchronizedObjects _logic;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
