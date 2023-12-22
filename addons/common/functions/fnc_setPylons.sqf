#include "script_component.hpp"

params ["_vehicle","_pylons"];

private _cfgWeapons = configFile >> "CfgWeapons";
private _cfgMagazines = configFile >> "CfgMagazines";
private _cfgAmmo = configFile >> "CfgAmmo";

{
	_x params ["_magazine","_turret"];

	private _simulation = getText (_cfgAmmo >> getText (_cfgMagazines >> _magazine >> "ammo") >> "simulation");

	if (_simulation != "shotCM" && _simulation != "laserDesignate") then {
		{
			if (_magazine in compatibleMagazines _x &&
				{getNumber (_cfgWeapons >> _x >> "laser") != 1} &&
				{getText (_cfgWeapons >> _x >> "simulation") != "cmlauncher"}
			) then {
    			_vehicle removeWeaponTurret [_x,_turret];
				_vehicle removeMagazinesTurret [_magazine,_turret];
			};
		} forEach (_vehicle weaponsTurret _turret);
	};
} forEach magazinesAllTurrets _vehicle;

{
	_x params ["_pylonIndex","","_turret","_magazine"];
	_vehicle setPylonLoadout [_pylonIndex,""];
} forEach getAllPylonsInfo _vehicle;

//{_vehicle removeMagazine _x} forEach magazines _vehicle;
//{_vehicle removeWeapon _x} forEach weapons _vehicle;

private _pylonIndex = 1;
private _pylonsCount = count getAllPylonsInfo _vehicle;
private _turretWeapons = [];

{
	_x params [["_weapon",""],["_magazine",""],["_turret",[-1]]];

	if (!isClass (_cfgWeapons >> _weapon)) then {
		_magazine = _weapon;
		_weapon = getText (_cfgMagazines >> _weapon >> "pylonWeapon");
		//if (_weapon isEqualTo "") then {continue};
	};

	if (_magazine isEqualTo "") then {
		_magazine = compatibleMagazines _weapon param [0,""];
		//if (_magazine isEqualTo "") then {continue};
	} else {
		if (!isClass (_cfgMagazines >> _magazine)) then {continue};
	};

	if (getText (_cfgMagazines >> _magazine >> "pylonWeapon") == _weapon && _pylonIndex < _pylonsCount) then {
		if (_turret isEqualTo [-1]) then {_turret = []};
		_vehicle setPylonLoadout [_pylonIndex,_magazine,true,_turret];
		_pylonIndex = _pylonIndex + 1;
		continue;
	};

	if (_weapon isEqualTo "" || _magazine isEqualTo "") then {continue};
	
	_vehicle addMagazineTurret [_magazine,_turret];

	if !([_weapon,_turret] in _turretWeapons) then {
		_vehicle addWeaponTurret [_weapon,_turret];
		_vehicle loadMagazine [_turret,_weapon,_magazine];
		_turretWeapons pushBack [_weapon,_turret];
	};
} forEach _pylons;
