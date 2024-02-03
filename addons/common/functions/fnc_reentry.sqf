#include "..\script_component.hpp"
	
if (_this isEqualTypeParams [objNull,""]) exitWith {
	// GetOut
	params ["_vehicle","_role","_unit","_turret"];

	private _entity = _vehicle getVariable [QPVAR(entity),objNull];
	private _group = _entity getVariable [QPVAR(group),grpNull];

	if (isNull _group) exitWith {};

	private _cache = _vehicle getVariable ["sss_crewCache",createHashMap];
	private _crewmate = _cache getOrDefault [[_role,_turret],objNull];

	if (_unit in units _group) then {
		if (alive _crewmate) exitWith {};

		_cache set [[_role,_turret],_unit];
		_vehicle setVariable ["sss_crewCache",_cache,true];
	} else {
		if (!alive _crewmate) exitWith {};

		switch (toUpper _role) do {
			case "DRIVER" : {_crewmate assignAsDriver _vehicle};
			case "COMMANDER" : {_crewmate assignAsCommander _vehicle};
			case "GUNNER" : {_crewmate assignAsGunner _vehicle};
			default {
				if (_turret isEqualTo []) then {
					_crewmate assignAsCargo _vehicle;
				} else {
					_crewmate assignAsTurret [_vehicle,_turret];
				};
			};
		};

		["sss_common_orderGetIn",[[_crewmate],true],_crewmate] call CBA_fnc_targetEvent;
	};
};

if (_this isEqualTypeParams [objNull,objNull]) exitWith {
	// SeatSwitched
	params ["_vehicle","_unit1","_unit2"];

	private _entity = _vehicle getVariable [QPVAR(entity),objNull];
	private _group = _entity getVariable [QPVAR(group),grpNull];

	if (isNull _group) exitWith {};

	private _cache = _vehicle getVariable ["sss_crewCache",createHashMap];
	
	if (_unit1 in units _group) then {
		private _crewmate = _cache getOrDefault [[assignedVehicleRole _unit1 param [0,""],_vehicle unitTurret _unit1],objNull];

		if (alive _crewmate) exitWith {};

		_cache set [[assignedVehicleRole _unit2 param [0,""],_vehicle unitTurret _unit2],_unit1];
		_vehicle setVariable ["sss_crewCache",_cache,true];
	};

	if (_unit2 in units _group) then {
		private _crewmate = _cache getOrDefault [[assignedVehicleRole _unit2 param [0,""],_vehicle unitTurret _unit2],objNull];

		if (alive _crewmate) exitWith {};

		_cache set [[assignedVehicleRole _unit1 param [0,""],_vehicle unitTurret _unit1],_unit2];
		_vehicle setVariable ["sss_crewCache",_cache,true];
	};
};
