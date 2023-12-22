#include "script_component.hpp"

params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];

// Update fired counts for quantity matching
private _counts = _vehicle getVariable [QGVAR(firedCounts),createHashMap];
_counts set [_weapon,(_counts getOrDefault [_weapon,0]) + 1];
_counts set [_magazine,(_counts getOrDefault [_magazine,0]) + 1];
_vehicle setVariable [QGVAR(firedCounts),_counts];

// Bomb trajectory simulation
if (_magazine in (_vehicle getVariable [QGVAR(bombMagazines),[]])) exitWith {
	call FUNC(firedBomb);
};

// Missile lock
private _dummy = _vehicle getVariable [QGVAR(targetDummy),objNull];

if (!isNull _dummy) then {
	_projectile setMissileTargetPos getPosATL _dummy;
	_projectile setMissileTarget _dummy;
	//if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "manualControl") > 0) then {
	//	_projectile setMissileTargetPos getPosATL _dummy;
	//} else {
	//	_projectile setMissileTarget _dummy;
	//};
};
