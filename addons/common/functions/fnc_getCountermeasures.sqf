#include "script_component.hpp"

params ["_vehicle"];

private _cfgAmmo = configFile >> "CfgAmmo";
private _cfgMagazines = configFile >> "CfgMagazines";
private _countermeasures = [];

{
	_x params ["_magazine","_turret","_ammoCount"];

	if (_ammoCount <= 0 || {getText (_cfgAmmo >> getText (_cfgMagazines >> _magazine >> "ammo") >> "simulation") != "shotCM"}) then {continue};
	
	{
		if (_magazine in compatibleMagazines _x) then {
			_countermeasures pushBackUnique [_x,_magazine,_turret];
		};
	} forEach (_vehicle weaponsTurret _turret);
} forEach magazinesAllTurrets _vehicle;

_countermeasures
