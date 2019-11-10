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
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX","Cooldown",str DEFAULT_COOLDOWN_DRONES],
			["EDITBOX","Loiter time",str DEFAULT_LOITER_TIME_DRONES],
			["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""]
		],{
			params ["_values"];
			_values params ["_classname","_callsign","_sideSelection","_cooldown","_loiterTime"];

			[
				[],
				_classname,
				_callsign,
				[west,east,independent] # _sideSelection,
				parseNumber _cooldown,
				parseNumber _loiterTime
			] call EFUNC(support,addCASDrone);

			ZEUS_MESSAGE("CAS Drone added");
		}] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		private _requesterModules = [];
		private _requesters = [];

		{
			if (typeOf _x == QGVAR(AssignRequesters)) then {
				_requesterModules pushBack _x;
				_requesters append ((synchronizedObjects _x) select {!(_x isKindOf "Logic")});
			};
		} forEach synchronizedObjects _logic;

		private _entity = [
			_requesters,
			_logic getVariable ["Classname",""],
			_logic getVariable ["Callsign",""],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_DRONES]),
			parseNumber (_logic getVariable ["LoiterTime",str DEFAULT_LOITER_TIME_DRONES]),
			_logic getVariable ["CustomInit",""]
		] call EFUNC(support,addCASDrone);

		{_x setVariable ["SSS_entitiesToAssign",(_x getVariable ["SSS_entitiesToAssign",[]]) + [_entity],true]} forEach _requesterModules;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
