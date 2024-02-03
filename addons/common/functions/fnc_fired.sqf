#include "..\script_component.hpp"

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
_vehicle getVariable [QGVAR(dummies),[]] params [["_laserDummy",objNull],"_targetDummy"];

if (isNull _laserDummy) exitWith {};

_projectile setMissileTargetPos getPosATL _laserDummy;

if !(_projectile setMissileTarget _laserDummy) then {
	_projectile setMissileTarget _targetDummy;
};
