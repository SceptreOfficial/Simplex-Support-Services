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
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]]
		],{
			params ["_values","_spawnPosASL"];
			_values params ["_spawnDir","_callsign","_listFnc","_universalInitFnc","_sideSelection"];

			[
				[],
				_spawnPosASL,
				parseNumber _spawnDir,
				_callsign,
				_listFnc,
				_universalInitFnc,
				[west,east,independent] # _sideSelection
			] call EFUNC(support,addLogisticsStation);

			ZEUS_MESSAGE("Logistics station added");
		},{},getPosASL _logic] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		private _requesterModules = [];
		private _requesters = [];
		private _booths = [];

		{
			if (typeOf _x == QGVAR(AssignRequesters)) then {
				_requesterModules pushBack _x;
				_requesters append ((synchronizedObjects _x) select {!(_x isKindOf "Logic")});
			} else {
				_booths pushBack _x;
			};
		} forEach synchronizedObjects _logic;

		private _entity = [
			_requesters,
			getPosASL _logic,
			getDir _logic,
			_logic getVariable ["Callsign",""],
			_logic getVariable ["ListFunction","[]"],
			_logic getVariable ["UniversalInitCode",""],
			[west,east,independent] # (_logic getVariable ["Side",0])
		] call EFUNC(support,addLogisticsStation);

		{_x setVariable ["SSS_entitiesToAssign",(_x getVariable ["SSS_entitiesToAssign",[]]) + [_entity],true]} forEach _requesterModules;

		{
			private _ID = ["SSS_logisticsStationBooth",[_entity,_x]] call CBA_fnc_globalEventJIP;
			[_ID,_x] call CBA_fnc_removeGlobalEventJIP;
		} forEach _booths;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
