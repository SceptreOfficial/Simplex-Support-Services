#include "script_component.hpp"
#define LOOP_TIMEOUT 90
#define ABORT_TIMEOUT 5

if (canSuspend) exitWith {
	[FUNC(fireAtTarget),_this] call CBA_fnc_directCall;
};

params [
	["_vehicle",objNull,[objNull]],
	["_target",objNull,[objNull,[]]],
	["_weapon","",["",[]]],
	["_quantity",[10,true],[0,[]]],
	["_triggerDelay",0,[0]],
	["_burst",[2,2]],
	["_spread",0],
	["_aimOffset",0]
];

if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,FUNC(fireAtTarget)],_vehicle] call CBA_fnc_targetEvent;
};

private _targetASL = if (_target isEqualType objNull) then {getPosASL _target} else {_target};

// Abort previous function
if (!alive _vehicle || _targetASL isEqualTo [0,0,0]) exitWith {
	_vehicle setVariable [QGVAR(abortFiring),true,true];
};

if (_vehicle getVariable [QGVAR(firing),false]) exitWith {
	_vehicle setVariable [QGVAR(abortFiring),true,true];
	
	[{
		params ["_vehicle"];
		!(_vehicle getVariable [QGVAR(firing),false])
	},FUNC(fireAtTarget),_this,ABORT_TIMEOUT,{
		params ["_vehicle"];
		_vehicle setVariable [QGVAR(firing),nil];
		{_x setVariable [QGVAR(firing),nil]} forEach crew _vehicle;
		[FUNC(fireAtTarget),_this] call CBA_fnc_execNextFrame;
	}] call CBA_fnc_waitUntilAndExecute;
};

// Get valid gunner info
_weapon params [["_weapon",""],["_magazine",""]];
private _validTurrets = [_vehicle,[],true,true,[_weapon,_magazine],true] call FUNC(turretWeapons);

//if (_checkView) then {
//	_validTurrets = [_vehicle,_targetASL,_validTurrets] call FUNC(turretsInView);
//};

private _turret = _validTurrets param [0,[]];
private _unit = _vehicle turretUnit _turret;

if (!alive _unit) exitWith {
	DEBUG_3("fireAtTarget: Invalid gunner: %1 %2 %3",typeOf _vehicle,_turret,_weapon);
};

// Execute where gunner is local
if (!local _unit) exitWith {
	[QGVAR(execute),[_this,FUNC(fireAtTarget)],_unit] call CBA_fnc_targetEvent;
};

if (_weapon isEqualTo "") then {
	_weapon = _vehicle currentWeaponTurret _turret;
};

LOG_3("fireAtTarget: %1 %2 %3",_target,_weapon,_turret);

// Get weapon info
weaponState [_vehicle,_turret,_weapon] params ["","_muzzle","_firemode","_loadedMag"];

if (_magazine != _loadedMag) then {
	_vehicle loadMagazine [_turret,_weapon,_magazine];
};

private _ammoData = [_weapon,_magazine] call FUNC(ammoData);
_triggerDelay = _triggerDelay max getNumber (configFile >> "CfgWeapons" >> _weapon >> _firemode >> "reloadTime");

if (_ammoData # 4 in ["shotmissile","shotrocket"]) then {
	_triggerDelay = _triggerDelay max 5;
};

// Create target dummy for missiles
private _dummy = if (_ammoData # 8) then {
	(["LaserTargetE","LaserTargetW"] select ([side group _vehicle,west] call BIS_fnc_sideIsFriendly)) createVehicle [0,0,0];
} else {
	(createGroup [sideLogic,true]) createUnit ["Logic",[0,0,0],[],0,"CAN_COLLIDE"];
};

_vehicle setVariable [QGVAR(targetDummy),_dummy,true];

if (_target isEqualType objNull) then {
	_dummy attachTo [_target,[0,0,0.1]];
} else {
	_dummy setPosASL (_targetASL vectorAdd [0,0,0.1]);
};

// Setup
_vehicle removeEventHandler ["Fired",_vehicle getVariable [QGVAR(firedEHID),-1]];
private _EHID = _vehicle addEventHandler ["Fired",FUNC(fired)];
_vehicle setVariable [QGVAR(firedEHID),_EHID];

_vehicle setVariable [QGVAR(firedCounts),nil];
_vehicle setVariable [QGVAR(abortFiring),nil];
_vehicle setVariable [QGVAR(firing),true,true];

_unit setVariable [QGVAR(firing),true,true];

_vehicle enableDirectionStabilization [true,_turret];
_vehicle setWeaponZeroing [_weapon,_muzzle,0];

// Run da op
private _fnc_reset = {
	params [
		"_vehicle",
		"",
		"",
		"",
		"",
		"",
		"",
		"_turret",
		"_unit",
		"",
		"",
		"_dummy"
	];

	_vehicle removeEventHandler ["Fired",_vehicle getVariable [QGVAR(firedEHID),-1]];
	_vehicle setVariable [QGVAR(firedEHID),nil];

	_vehicle setVariable [QGVAR(abortFiring),nil];
	_vehicle setVariable [QGVAR(firing),nil,true];
	_vehicle setVariable [QGVAR(targetDummy),nil,true];

	_unit setVariable [QGVAR(firing),nil,true];

	[{deleteVehicle _this},_dummy,10] call CBA_fnc_waitAndExecute;
	[{(_this # 0) lockCameraTo (_this # 1)},[_vehicle,[objNull,_turret,true]],1] call CBA_fnc_waitAndExecute;
};

[QGVAR(fireAtTargetStart),[
	_vehicle,
	_target,
	_weapon,
	_quantity,
	_burst,
	_spread,
	_aimOffset,
	_turret,
	_unit
]] call CBA_fnc_localEvent;

[FUNC(fireAtTargetLoop),_fnc_reset,[
	_vehicle,
	_target,
	_weapon,
	_quantity,
	_burst,
	_spread,
	_aimOffset,
	_turret,
	_unit,
	_ammoData,
	_triggerDelay,
	_dummy,
	0,// _startTime
	0,// _totalTime
	0,// _aimTick
	0,// _viewTick
	false,// _inView
	0,// _triggerTick,
	0// _burstStart
],LOOP_TIMEOUT,_fnc_reset] call CBA_fnc_waitUntilAndExecute;
