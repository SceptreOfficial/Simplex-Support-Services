#include "script_component.hpp"

params ["_vehicle",["_magazine",""]];

private _velocityOverride = _vehicle getVariable [QGVAR(velocityOverride),false];
private _cache = uiNamespace getVariable [format ["%1%2:%3",QGVAR(cache_),typeOf _vehicle,_velocityOverride],["",[]]];
private _turretPath = _vehicle unitTurret gunner _vehicle;
private _weapon = (_vehicle weaponsTurret _turretPath) # 0;

if (_cache # 0 == _weapon) exitWith {+(_cache # 1)};

if (_magazine isEqualTo "") then {
	_magazine = _vehicle currentMagazineTurret _turretPath;
};

private _turretCfg = [_vehicle,_turretPath] call BIS_fnc_turretConfig;
private _initSpeed = getNumber (configFile >> "CfgMagazines" >> _magazine >> "initSpeed");

///////////////////////////////////////////////////////////////////////////////////////////////
// From "ace_vehicletables_fnc_interactMenuOpened"
// https://github.com/acemod/ACE3/blob/master/addons/artillerytables/functions/fnc_interactMenuOpened.sqf
// Author: PabstMirror
// Some turrets (MK6) have a neutralX rotation that we need to add to min/max config elevation to get actual limits
private _turretAnimBody = getText (_turretCfg >> "animationSourceBody");
private _turretAnimGun = getText (_turretCfg >> "animationSourceGun");
private _currentElevRad = _vehicle animationSourcePhase _turretAnimGun;
if (isNil "_currentElevRad") then {_currentElevRad = _vehicle animationPhase _turretAnimGun};
private _currentTraverseRad = _vehicle animationSourcePhase _turretAnimBody;
if (isNil "_currentTraverseRad") then {_currentTraverseRad = _vehicle animationPhase _turretAnimBody};
private _turretRot = [vectorDir _vehicle,vectorUp _vehicle,deg _currentTraverseRad] call CBA_fnc_vectRotate3D;
private _neutralX = (acos ((_turretRot vectorCos (_vehicle weaponDirection _weapon)) min 1)) - (deg _currentElevRad);
_neutralX = (round (_neutralX * 10)) / 10;
///////////////////////////////////////////////////////////////////////////////////////////////

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
private _modes = (getArray (_weaponCfg >> "modes")) apply {toLower _x};
private _firingOptions = [];
private _minVelocity = 1e39;
private _maxVelocity = 0;

{
	private _mode = toLower configName _x;
	private _charge = getNumber (_x >> "artilleryCharge");
	private _velocity = _charge * _initSpeed;

	if (_mode in _modes && _mode select [0,5] != "Burst" && _charge > 0) then {
		_minVelocity = _minVelocity min _velocity;
		_maxVelocity = _maxVelocity max _velocity;
		_firingOptions pushBack [_mode,_modes find _mode,_charge];
	} else {
		if (!_velocityOverride) exitWith {};
		_minVelocity = _minVelocity min _velocity;
		_maxVelocity = _maxVelocity max _velocity;
	};
} forEach configProperties [_weaponCfg,"isClass _x && isNumber (_x >> 'artilleryCharge')"];

private _cacheData = [
	_neutralX + getNumber (_turretCfg >> "minElev"),
	_neutralX + getNumber (_turretCfg >> "maxElev"),
	_firingOptions,
	_minVelocity min _maxVelocity,
	_maxVelocity
];

uiNamespace setVariable [format ["%1%2:%3",QGVAR(cache_),typeOf _vehicle,_velocityOverride],[_weapon,_cacheData]];

_cacheData
