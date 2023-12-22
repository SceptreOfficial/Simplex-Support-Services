#include "script_component.hpp"
/*
	Authors: Sceptre
	Gets an ETA from strike data

	Parameters:
	0: Artillery <OBJECT>
	1: Target (ASL) <OBJECT | POSITION(ASL)>
	2: Magazine (Optional) <STRING>

	Returns:
	ETA <SCALAR>
*/
params [
	["_vehicle",objNull,[objNull]],
	["_target",[0,0,0],[objNull,[]]],
	["_magazine","",["",[]]]
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

if (!alive _gunner || _target distance2D [0,0,0] < 0.1) exitWith {-1};

if (_magazine isEqualType []) then {
	_magazine = _magazine param [0,"",[""]];
};

if (_magazine isEqualTo "") exitWith {-1};

// Handle VLS
if (_vehicle isKindOf "B_Ship_MRLS_01_base_F") exitWith {
	// ETA formula credit: Kex (from ZEN)
	private _maxSpeed = getNumber (configfile >> "CfgAmmo" >> getText (configfile >> "CfgMagazines" >> _magazine >> "ammo") >> "maxSpeed");
	round (10 + (((_target distance _vehicle) - 900) max 0) / (0.94 * _maxSpeed))
};

private _instruction = [_vehicle,_target,_magazine,true] call FUNC(calculate);

if (_instruction isEqualTo []) exitWith {-1};

_instruction # 0
