#include "script_component.hpp"
#define FALSE_RETURN [false,[false,-1]] select _returnETA
/*
	Authors: Sceptre
	Checks if artillery vehicle can fire at target

	Parameters:
	0: Artillery <OBJECT>
	1: Target (ASL) <OBJECT | POSITION(ASL)>
	2: Magazine (Optional) <STRING>
	3: Return ETA (Optional, default: false) <BOOL>

	Returns:
	_canFire OR [_canFire,_ETA] <BOOL | ARRAY>
*/
params [
	["_vehicle",objNull,[objNull]],
	["_target",[0,0,0],[objNull,[]]],
	["_magazine","",["",[]]],
	["_returnETA",false,[false]]
];

switch true do {
	case (_target isEqualType objNull) : {
		_target = getPosASL _target;
	};
	case (_target isEqualTypeArray [0,0,0]) : {};
	case (_target isEqualTypeArray [[],0,0,0,false]) : {
		_target = _target # 0;

		if (_target isEqualType objNull) then {
			_target = getPosASL _target;
		};
	};
	case (_target isEqualTypeParams [[],true]) : {
		_target = _target # 0 # 0;

		if (_target isEqualType objNull) then {
			_target = getPosASL _target;
		};
	};
};

private _gunner = gunner _vehicle;

if (!alive _gunner || isPlayer _gunner || _target distance2D [0,0,0] < 0.1 || !unitReady _vehicle || _gunner call EFUNC(common,isRemoteControlled)) exitWith {FALSE_RETURN};

if (_vehicle getVariable [QGVAR(firing),false] && !(_vehicle getVariable [QGVAR(recursive),false])) exitWith {FALSE_RETURN};

if (_magazine isEqualType []) then {
	_magazine = _magazine param [0,"",[""]];
};

if (_magazine isEqualTo "") exitWith {FALSE_RETURN};
//if (_magazine isEqualTo "") then {
//	_magazine = _vehicle currentMagazineTurret (_vehicle unitTurret _gunner);
//};

// Handle VLS
if (_vehicle isKindOf "B_Ship_MRLS_01_base_F") exitWith {
	if (_target distance _vehicle < 50) exitWith {FALSE_RETURN};

	// ETA formula credit: Kex (from ZEN)
	private _maxSpeed = getNumber (configfile >> "CfgAmmo" >> getText (configfile >> "CfgMagazines" >> _magazine >> "ammo") >> "maxSpeed");
	[true,[true,round (10 + (((_target distance _vehicle) - 900) max 0) / (0.94 * _maxSpeed))]] select _returnETA
};

private _instruction = [_vehicle,_target,_magazine,true] call FUNC(calculate);

if (_instruction isEqualTo []) exitWith {FALSE_RETURN};

[true,[true,_instruction # 0]] select _returnETA
