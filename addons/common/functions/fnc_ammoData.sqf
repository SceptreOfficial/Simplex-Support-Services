#include "script_component.hpp"

params ["_weapon","_magazine"];

private _ammoCfg = configFile >> "CfgAmmo" >> getText (configFile >> "CfgMagazines" >> _magazine >> "ammo");
private _initSpeed = getNumber (configFile >> "CfgMagazines" >> _magazine >> "initSpeed");
private _simulation = toLower getText (_ammoCfg >> "simulation");
private _airFriction = getNumber (_ammoCfg >> "airFriction");
private _simStep = getNumber (_ammoCfg >> "simulationStep");

switch _simulation do {
	case "shotShell";
	case "shotbullet" : {
		private _weaponInitSpeed = getNumber (configFile >> "CfgWeapons" >> _weapon >> "initSpeed");
		if (_weaponInitSpeed < 0) then {_initSpeed = _initSpeed * -_weaponInitSpeed};
		if (_weaponInitSpeed > 0) then {_initSpeed = _weaponInitSpeed};
	};
	case "shotsubmunitions" : {
		_airFriction = 0;
	};
	case "shotmissile";
	case "shotrocket" : {
		_initSpeed = _initSpeed + getNumber (_ammoCfg >> "thrust") * getNumber (_ammoCfg >> "thrustTime");

		if (_initSpeed > 0) then {
			_airFriction = _airFriction * -0.0035;
		} else {
			_airFriction = 0;
		};
	};
};

private _ammoData = [
	_initSpeed,
	_airFriction,
	getNumber (_ammoCfg >> "timeToLive"),
	_simStep,
	_simulation,
	getNumber (configFile >> "CfgWeapons" >> _weapon >> "canLock") > 0,
	getNumber (_ammoCfg >> "irLock") + getNumber (_ammoCfg >> "laserLock") + getNumber (_ammoCfg >> "nvLock") > 0,
	getNumber (_ammoCfg >> "airLock") > 0,
	getNumber (_ammoCfg >> "laserLock") > 0
];

DEBUG_3("%1:%2 ammo data requested: %3",_weapon,_magazine,_ammoData);

_ammoData
