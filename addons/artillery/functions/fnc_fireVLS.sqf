#include "script_component.hpp"
/*
	Authors: Sceptre
	Makes an artillery unit fire on target location

	Parameters:
	0: Artillery <OBJECT>
	1: Target <OBJECT | ARRAY>
	2: Magazines (Optional) <ARRAY | STRING>
	3: Rounds to fire (Optional) <SCALAR>
	5: Firing delay (Minimum delay between each round) (Optional) <ARRAY>

	Returns:
	Success <BOOL>

	CBA Events:
	QGVAR(firing) 		params ["_vehicle","_area","_magazine","_rounds","_firingDelay","_ETA"];
	QGVAR(complete) 	params ["_vehicle","_area","_magazine","_rounds","_firingDelay"];
	QGVAR(splash)  		params ["_vehicle","_area","_magazine","_rounds","_firingDelay"];
*/

if (canSuspend) exitWith {
	[FUNC(fire),_this] call CBA_fnc_directCall;
};

params [
	["_vehicle",objNull,[objNull]],
	["_target",[0,0,0],[objNull,[]]],
	["_magazines","",["",[]]],
	["_rounds",4,[0]],
	["_firingDelay",0,[0,[]],2]
];

if (!local _vehicle) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(fireVLS)],_vehicle] call CBA_fnc_targetEvent;
};

private "_area";
private _gunner = gunner _vehicle;
private _targeting = "AREA";

switch true do {
	case (_target isEqualType objNull) : {
		_target = getPosASL _target;
		_area = [_target,0,0,0,false];
	};
	case (_target isEqualTypeArray [0,0,0]) : {
		_area = [_target,0,0,0,false];
	};
	case (_target isEqualTypeArray [[],0,0,0,false]) : {
		_area = _target;
		_target = _target # 0;

		if (_target isEqualType objNull) then {
			_target = getPosASL _target;
			_area set [0,_target];
		};
	};
	case (_target isEqualTypeParams [[]]) : {
		_target params ["_tArea",["_creeping",false,[false]],["_random",false,[false]]];
		_area = _tArea;
		_target = _tArea # 0;

		if (_target isEqualType objNull) then {
			_target = getPosASL _target;
			_area set [0,_target];
		};

		_targeting = switch true do { 
			case (_creeping && _random) : {"CREEPING_RANDOM"};
			case _creeping : {"CREEPING_UNIFORM"};
			default {"AREA"};
		};
	};
};

// Validation
if (!alive _gunner || isPlayer _gunner || _target isEqualTo [0,0,0] || _rounds <= 0 || isNil "_area" || _magazines isEqualTo []) exitWith {false};

// Check if busy
if (_vehicle getVariable [QGVAR(firing),false] && !(_vehicle getVariable [QGVAR(recursive),false])) exitWith {false};

// Format firing delay
if (_firingDelay isEqualType 0) then {_firingDelay = [_firingDelay,_firingDelay]};

// Get mag
if (_magazines isEqualType "") then {_magazines = [_magazines]};

private _magazine = _magazines # (_vehicle getVariable [QGVAR(magIndex),0]);
private _turretPath = _vehicle unitTurret _gunner;
private _weapon = (_vehicle weaponsTurret _turretPath) # 0;

if (_magazine isEqualTo "") then {
	_magazine = _vehicle currentMagazineTurret _turretPath;
};

// Force load
{_vehicle removeMagazine _x} forEach magazines _vehicle;
{_vehicle removeWeapon _x} forEach weapons _vehicle;
_vehicle addMagazine _magazine;
_vehicle addWeapon _weapon;

// Get firing target
private _canFire = switch _targeting do {
	case "AREA" : {
		for "_i" from 1 to 5 do {
			_target = [_area] call CBA_fnc_randPosArea;

			if (_target distance _vehicle > 50) exitWith {true};
			false
		};
	};
	case "CREEPING_UNIFORM" : {
		_area params ["_center","_width","_height","_dir","_isRect"];
		_width = _width max 1;
		_height = _height max 1;

		private _spacing = (_height / _rounds) * 2;
		_target = ATLtoASL (_vehicle getVariable [QGVAR(creepingTarget),_target getPos [_height - _spacing/2,_dir - 180]]);
		_vehicle setVariable [QGVAR(creepingTarget),_target getPos [_spacing,_dir]];
		
		if (_target distance _vehicle > 50) exitWith {true};
		false
	};
	case "CREEPING_RANDOM" : {
		_area params ["_center","_width","_height","_dir","_isRect"];
		_width = _width max 1;
		_height = _height max 1;

		private _spacing = (_height / _rounds) * 2;
		private _creepingTarget = _vehicle getVariable [QGVAR(creepingTarget),_target getPos [_height - _spacing/2,_dir - 180]];
		private _creepArea = [_creepingTarget,_width,_spacing,_dir,true];

		_vehicle setVariable [QGVAR(creepingTarget),_creepingTarget getPos [_spacing,_dir]];

		private _canFire = for "_i" from 1 to 5 do {
			while {
				_target = [_creepArea] call CBA_fnc_randPosArea;
				!(_target inArea _area)
			} do {};

			if (_target distance _vehicle > 50) exitWith {true};
			false
		};

		_canFire
	};
};

if (!_canFire) exitWith {
	_vehicle setVariable [QGVAR(recursive),nil];
	false
};

private _maxSpeed = getNumber (configfile >> "CfgAmmo" >> getText (configfile >> "CfgMagazines" >> _magazine >> "ammo") >> "maxSpeed");
private _ETA = round (10 + (((_target distance _vehicle) - 900) max 0) / (0.94 * _maxSpeed));
private _reloadTime = getNumber (configFile >> "cfgWeapons" >> _weapon >> "reloadTime");

_vehicle setVariable [QGVAR(firing),true];
_vehicle setVariable [QGVAR(target),_target];
_vehicle setVariable [QGVAR(ETA),_ETA];

if (_vehicle getVariable [QGVAR(recursive),false]) exitWith {
	_vehicle setVariable [QGVAR(recursive),nil];
	true
};

// Firing event
[QGVAR(firing),[_vehicle,_area,_magazines,_rounds,_firingDelay,_ETA]] call CBA_fnc_globalEvent;

_gunner setVariable [QGVAR(fired),0];

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_gunner","_area","_magazines","_rounds","_firingDelay","_targeting","_reloadTime","_weapon"];

	private _fnc_cleanup = {
		_PFHID call CBA_fnc_removePerFrameHandler;
		
		_gunner removeEventHandler ["FiredMan",_gunner getVariable [QGVAR(EHID),-1]];
		_gunner setVariable [QGVAR(hold),nil,true];

		_vehicle setVariable [QGVAR(firing),nil,true];
		_vehicle setVariable [QGVAR(recursive),nil,true];
		_vehicle setVariable [QGVAR(creepingTarget),nil,true];
		_vehicle setVariable [QGVAR(magIndex),nil,true];
		_vehicle setVariable [QGVAR(abort),nil,true];

		if (!alive _vehicle) exitWith {};

		//_vehicle setVehicleAmmoDef 1;

		// Complete event
		[QGVAR(complete),[_vehicle,_area,_magazines,_rounds,_firingDelay]] call CBA_fnc_globalEvent;
	};

	if (!alive _gunner ||
		isNull objectParent _gunner ||
		_gunner getVariable [QGVAR(fired),0] >= _rounds ||
		_vehicle getVariable [QGVAR(abort),false]
	) exitWith _fnc_cleanup;

	if (_gunner getVariable [QGVAR(hold),false]) exitWith {};

	private _target = _vehicle getVariable [QGVAR(target),[0,0,0]];
	private _ETA = _vehicle getVariable [QGVAR(ETA),0];

	// VLS needs a dummy target
	_target set [2,1];
	private _dummy = createGroup [sideLogic,true] createUnit ["Logic",_target,[],0,"CAN_COLLIDE"];
	[{deleteVehicle _this},_dummy,((1.3 * _ETA) max 15) + _reloadTime] call CBA_fnc_waitAndExecute;
	
	// LAUNCH
	if (isNull (_vehicle getVariable [QPVAR(entity),objNull])) then {
		_vehicle setVehicleAmmo 1;
	};

	_vehicle setWeaponReloadingTime [_gunner,_weapon,0];
	(side _gunner) reportRemoteTarget [_dummy,_ETA + 60];
	_vehicle fireAtTarget [_dummy,_weapon];

	private _fired = (_gunner getVariable [QGVAR(fired),0]) + 1;
	_gunner setVariable [QGVAR(fired),_fired];

	// Splash event
	if (_fired == 1) then {
		[{
			if (!alive (_this # 0)) exitWith {};
			[QGVAR(splash),_this] call CBA_fnc_globalEvent;
		},[_vehicle,_area,_magazines,_rounds,_firingDelay],_ETA - 5] call CBA_fnc_waitAndExecute;
	};

	if (_fired >= _rounds) exitWith _fnc_cleanup;

	private _newTarget = [_area,[_area,true,_targeting isEqualTo "CREEPING_RANDOM"]] select (_targeting in ["CREEPING_UNIFORM","CREEPING_RANDOM"]);

	if (count _magazines > 1) then {
		private _magIndex = (_vehicle getVariable [QGVAR(magIndex),0]) + 1;

		if (_magIndex >= count _magazines) then {
			_vehicle setVariable [QGVAR(magIndex),0];
		} else {
			_vehicle setVariable [QGVAR(magIndex),_magIndex];
		};
	};

	[{
		(_this # 0) setVariable [QGVAR(recursive),true];
		_this call FUNC(fire);
	},[_vehicle,_newTarget,_magazines,_rounds],_firingDelay call EFUNC(common,randomMinMax)] call CBA_fnc_waitAndExecute;
},_reloadTime,[_vehicle,_gunner,_area,_magazines,_rounds,_firingDelay,_targeting,_reloadTime,_weapon]] call CBA_fnc_addPerFrameHandler;

true
