#include "script_component.hpp"

params [["_vehicle",objNull,["",configNull,objNull]],["_filter",{},[{}]]];

private _cfgWeapons = configFile >> "CfgWeapons";
private _cfgMagazines = configFile >> "CfgMagazines";
private _cfgAmmo = configFile >> "CfgAmmo";
private _pylons = [];
private _ignoredWeapons = missionNamespace getVariable [QGVAR(ignoredWeapons),[]];

if (_filter isEqualTo {}) then {
	_filter = {true};
};

if (_vehicle isEqualTypeAny ["",configNull]) exitWith {
	private _cfg = if (_vehicle isEqualType "") then {
		configFile >> "CfgVehicles" >> _vehicle
	} else {
		_vehicle
	};
	
	private _turrets = "true" configClasses (_cfg >> "turrets");
	//private _gunnerIndex = _turrets findIf {getNumber (_x >> "primaryGunner") == 1};
	//private _gunnerCfg = _turrets param [_gunnerIndex,configNull];

	private _fnc_mainWeapons = {
		params ["_weapons","_magazines","_turret"];

		{
			private _weapon = _x;

			if (_weapon == "SEARCHLIGHT" && {[_weapon,"FakeMagazine",_turret] call _filter}) then {
				_pylons pushBack [_weapon,"FakeMagazine",_turret];
				continue;
			};

			if (_ignoredWeapons findIf {_weapon isKindOf [_x,_cfgWeapons]} > -1) then {continue};
			
			if (getNumber (_cfgWeapons >> _weapon >> "laser") == 1 ||
				getText (_cfgWeapons >> _weapon >> "simulation") == "cmlauncher"
			) then {continue};
			
			private _compatMags = compatibleMagazines _weapon;
			
			{
				private _magazine = _x;

				if (!(_magazine in _compatMags) || {
					private _simulation = getText (_cfgAmmo >> getText (_cfgMagazines >> _magazine >> "ammo") >> "simulation");

					_simulation == "shotCM" || _simulation == "laserDesignate"
				}) then {continue};

				if ([_weapon,_magazine,_turret] call _filter) then {
					_pylons pushBack [_weapon,_magazine,_turret];
				};
			} forEach _magazines;
		} forEach _weapons;
	};

	[getArray (_cfg >> "weapons"),getArray (_cfg >> "magazines"),[-1]] call _fnc_mainWeapons;
	{[getArray (_x >> "weapons"),getArray (_x >> "magazines"),[_forEachIndex]] call _fnc_mainWeapons} forEach _turrets;
	//[getArray (_gunnerCfg >> "weapons"),getArray (_gunnerCfg >> "magazines"),[_gunnerIndex]] call _fnc_mainWeapons;
	
	{
		private _magazine = getText (_x >> "attachment");
		private _turret = getArray (_x >> "turret");
		
		if (_magazine isEqualTo "") then {
			_pylons pushBack "";
			continue;
		};
		
		private _simulation = getText (_cfgAmmo >> getText (_cfgMagazines >> _magazine >> "ammo") >> "simulation");

		if (_simulation == "shotCM" || _simulation == "laserDesignate") then {continue};

		private _weapon = getText (_cfgMagazines >> _magazine >> "pylonWeapon");
		
		if (_ignoredWeapons findIf {_weapon isKindOf [_x,_cfgWeapons]} > -1) then {continue};

		if (_turret isEqualTo []) then {_turret = [-1]};
		
		if ([_weapon,_magazine,_turret] call _filter) then {
			_pylons pushBack [_weapon,_magazine,_turret];
		};
	} forEach configProperties [_cfg >> "Components" >> "TransportPylonsComponent" >> "pylons","isClass _x"];

	_pylons
};

private _realPylons = [];

{
	_x params ["_pylonIndex","_pylonName","_turret","_magazine","_ammoCount","_id"];
	
	if (_magazine isEqualTo "") then {
		_realPylons pushBack "";
		continue;
	};

	private _weapon = getText (_cfgMagazines >> _magazine >> "pylonWeapon");

	if (_ignoredWeapons findIf {_weapon isKindOf [_x,_cfgWeapons]} > -1) then {continue};

	private _simulation = getText (_cfgAmmo >> getText (_cfgMagazines >> _magazine >> "ammo") >> "simulation");

	if (getNumber (_cfgWeapons >> _weapon >> "laser") == 1 ||
		getText (_cfgWeapons >> _weapon >> "simulation") == "cmlauncher" ||
		_simulation == "shotCM" || _simulation == "laserDesignate"
	) then {continue};
	
	if ([_weapon,_magazine,_turret] call _filter) then {
		_realPylons pushBack [_weapon,_magazine,_turret];
	};
} forEach getAllPylonsInfo _vehicle;

{
	_x params ["_magazine","_turret","_ammoCount"];

	if (_ammoCount <= 0) then {continue};

	private _simulation = getText (_cfgAmmo >> getText (_cfgMagazines >> _magazine >> "ammo") >> "simulation");

	if (_simulation == "shotCM" || _simulation == "laserDesignate") then {continue};

	{
		private _weapon = _x;

		if (_weapon == "SEARCHLIGHT" && {[_weapon,"FakeMagazine",_turret] call _filter}) then {
			_pylons pushBack [_weapon,"FakeMagazine",_turret];
			continue;
		};

		if (_ignoredWeapons findIf {_weapon isKindOf [_x,_cfgWeapons]} > -1) then {continue};

		if (!(_magazine in compatibleMagazines _weapon) || [_weapon,_magazine,_turret] in _realPylons) then {continue};

		if (getNumber (_cfgWeapons >> _weapon >> "laser") == 1 ||
			getText (_cfgWeapons >> _weapon >> "simulation") == "cmlauncher"
		) then {continue};
		
		if ([_weapon,_magazine,_turret] call _filter) then {
			_pylons pushBack [_weapon,_magazine,_turret];
		};
	} forEach (_vehicle weaponsTurret _turret);
} forEach magazinesAllTurrets _vehicle;

_pylons append _realPylons;

_pylons
