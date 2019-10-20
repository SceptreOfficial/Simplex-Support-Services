#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;
		private _classname = "B_T_VTOL_01_armed_F";
		private _callsign = "Blackfish";

		if (_object isKindOf "Plane") then {
			_classname = typeOf _object;
			_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
		};

		["Add CAS Gunship",[
			["EDITBOX","Classname",_classname],
			["EDITBOX",["Turret path","Turret path to gunner"],"[1]"],
			["EDITBOX","Callsign",_callsign],
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_GUNSHIPS_STR],
			["EDITBOX","Loiter time",SSS_DEFAULT_LOITER_TIME_GUNSHIPS_STR],
			["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""]
		],{
			params ["_values"];
			_values params ["_classname","_turretPath","_callsign","_sideSelection","_cooldown","_loiterTime"];

			[
				[],
				_classname,
				parseSimpleArray _turretPath,
				_callsign,
				[west,east,independent] # _sideSelection,
				parseNumber _cooldown,
				parseNumber _loiterTime
			] call EFUNC(support,addCASGunship);

			ZEUS_MESSAGE("CAS Gunship added");
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
			_logic getVariable ["Classname","B_T_VTOL_01_armed_F"],
			parseSimpleArray (_logic getVariable ["TurretPath","[1]"]),
			_logic getVariable ["Callsign",""],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			parseNumber (_logic getVariable ["Cooldown",SSS_DEFAULT_COOLDOWN_GUNSHIPS_STR]),
			parseNumber (_logic getVariable ["LoiterTime",SSS_DEFAULT_LOITER_TIME_GUNSHIPS_STR]),
			_logic getVariable ["CustomInit",""]
		] call EFUNC(support,addCASGunship);

		{_x setVariable ["SSS_entitiesToAssign",(_x getVariable ["SSS_entitiesToAssign",[]]) + [_entity],true]} forEach _requesterModules;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
