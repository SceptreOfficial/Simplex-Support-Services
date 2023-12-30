#include "script_component.hpp"

params [["_cfg",configNull],["_pylons",[]]];

if (_pylons isEqualTo []) then {
	_pylons = _cfg call FUNC(getPylons);
};

if (_cfg isEqualType "") then {
	_cfg = configFile >> "CfgVehicles" >> _cfg;
};

if (_cfg isEqualType objNull) then {
	_cfg = configOf _cfg;
};

private _cfgWeapons = configFile >> "CfgWeapons";
private _cfgMagazines = configFile >> "CfgMagazines";
private _validPylons = [];
private _formatPylons = [];

{
	_x params [["_weapon",""],["_magazine",""],["_turret",[]]];
	
	if (!isClass (_cfgWeapons >> _weapon)) then {
		_magazine = _weapon;
		_weapon = getText (_cfgMagazines >> _weapon >> "pylonWeapon");
		if (_weapon isEqualTo "") then {continue};
	};
	
	if (_magazine isEqualTo "") then {
		_magazine = compatibleMagazines _weapon param [0,""];
		if (_magazine isEqualTo "") then {continue};
	} else {
		if (!isClass (_cfgMagazines >> _magazine)) then {continue};
	};

	//[_weapon,_magazine] call FUNC(ammoData) params ["","","","","","_canLock","_sensorLock","_airLock"];
	//if (_canLock && _airLock && !_sensorLock) then {continue};
	//if (_canLock && _airLock) then {continue};

	if (_turret isEqualTo []) then {
		_turret = [-1];
	};

	private _turretName = if (_turret isEqualTo [-1]) then {
		"Driver [-1]"
	} else {
		private _turretCfg = _cfg;

		{
			if (_x < 0) exitWith {_turretCfg = configNull};
			_turretCfg = ("true" configClasses (_turretCfg >> "turrets")) param [_x,configNull];
		} forEach _turret;

		if (isNull _turretCfg) then {continue};

		private _turretName = getText (_turretCfg >> "gunnerName");
		if (_turretName isEqualTo "") then {_turretName = configName _turretCfg};
			
		format ["%1 %2",_turretName,_turret]
	};

	_validPylons pushBack [_weapon,_magazine,_turret];
	_formatPylons pushBackUnique [
		[_weapon,_magazine,_turret],
		getText (_cfgWeapons >> _weapon >> "displayName"),
		getText (_cfgMagazines >> _magazine >> "displayName"),
		_turretName
	];
} forEach _pylons;

[_validPylons,_formatPylons]
