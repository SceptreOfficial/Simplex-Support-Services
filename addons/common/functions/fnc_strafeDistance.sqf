#include "script_component.hpp"

params [
	["_vehicle",objNull,[objNull]],
	["_pylonConfig",[],[[]]],// [[_weapon,_magazine,_turret],[_quantity,_isDuration],_interval]
	["_infiniteAmmo",true,[false]],
	["_altitude",500,[0]],
	["_aimRange",-1,[0]]
];

if (_aimRange < 0) then {_aimRange = [2600,1000] select (_vehicle isKindOf "Helicopter")};
_aimRange = _aimRange max 600;

private _totalDuration = 0;

{
	_x params [["_pylon","",["",[]]],["_quantity",0,[0,[]]],["_interval",0]];
	_quantity params [["_quantity",0],["_isDuration",false]];
	_pylon params [["_weapon",""],["_magazine",""],["_turret",[-1]]];

	if (_weapon isEqualTo "" || _quantity <= 0) then {continue};

	weaponState [_vehicle,_turret,_weapon] params ["","","_firemode","_loadedMag"];

	if (_magazine isEqualTo "") then {
		_magazine = compatibleMagazines _weapon arrayIntersect (_vehicle magazinesTurret [_turret,false]) param [0,""];

		if (_magazine isEqualTo "" && _infiniteAmmo) then {
			_magazine = compatibleMagazines _weapon param [0,""];
		};
	};

	if (_magazine isEqualTo "") then {continue};

	[_weapon,_magazine] call FUNC(ammoData) params ["_initSpeed","_airFriction","_timeToLive","_simStep","_simulation","_canLock","_otherLock","_airLock"];

	_interval = _interval max getNumber (configFile >> "CfgWeapons" >> _weapon >> _firemode >> "reloadTime");

	if (_simulation in ["shotmissile","shotrocket"] || _canLock) then {
		_interval = _interval max 0.1;
	};

	_totalDuration = _totalDuration + ([_quantity * _interval,_quantity] select _isDuration);
} forEach _pylonConfig;

private _maxSpeed = getNumber (configOf _vehicle >> "maxSpeed") / 3.6;
private _minSpeed = [getNumber (configOf _vehicle >> "stallSpeed") * 1.1 / 3.6,28 min (_maxSpeed / 3)] select (_vehicle isKindOf "Helicopter");
private _speed = (_maxSpeed * 0.6) min 160 max _minSpeed;
private _hBuffer = _altitude / 2;//getPosASL _vehicle # 2 / 2;
private _minDist = (_aimRange * 0.8) max (_speed * (_totalDuration + 0.5) + _hBuffer);
private _simDist = _aimRange max (_speed * (_totalDuration + 3) + _hBuffer);
private _prepDist = (_aimRange + 800) max (_maxSpeed * (_totalDuration + 6) + _hBuffer);// TODO: was 12, re-evaluate ETA and test vanilla aircraft

[_minDist,_simDist,_prepDist]
