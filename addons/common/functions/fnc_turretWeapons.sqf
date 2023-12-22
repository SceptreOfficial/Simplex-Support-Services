#include "script_component.hpp"

if (canSuspend) exitWith {
	[FUNC(turretWeapons),_this] call CBA_fnc_directCall;
};

params [
	["_vehicle",objNull,[objNull]],
	["_turret",[],[[],objNull]],
	["_checkMags",true,[false]],
	["_checkOccupied",true,[false]],
	["_weaponFilter","",["",[]]],
	["_returnTurretsOnly",false,[false]]
];

if (_turret isEqualType objNull) then {
	_turret = _vehicle unitTurret _turret;
};

private _allTurrets = if (_turret isEqualTo []) then {
	[[-1]] + allTurrets _vehicle
} else {
	[_turret]
};

_weaponFilter params [["_weaponFilter",""],["_magazineFilter",""]];

_checkMags = [{true},{compatibleMagazines _x arrayIntersect _magazines isNotEqualTo []}] select _checkMags;
private _checkWeapon = [{true},{_x == _weaponFilter}] select (_weaponFilter isNotEqualTo "");
private _checkMagazine = [{true},{_x == _magazineFilter}] select (_magazineFilter isNotEqualTo "");
private _cfgWeapons = configFile >> "CfgWeapons";
private _return = [];

{
	if (_checkOccupied && {
		private _unit = _vehicle turretUnit _x;
		!alive _unit || _unit call FUNC(isRemoteControlled)
	}) then {continue};

	private _magazines = (_vehicle magazinesTurret [_x,false]) select _checkMagazine;
	private _weapons = (_vehicle weaponsTurret _x) select {
		getText (_cfgWeapons >> _x >> "simulation") != "cmlauncher" &&
		getNumber (_cfgWeapons >> _x >> "laser") != 1 &&
		_checkWeapon &&
		_checkMags
	};

	if (_weapons isEqualTo []) then {continue};

	if (_returnTurretsOnly) then {
		_return pushBack _x
	} else {
		_return pushBack [_x,_weapons,_magazines];
	};
} forEach _allTurrets;

_return
