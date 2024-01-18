#include "script_component.hpp"
#define AIM_TICK 0.4
#define VIEW_TICK 0.5

params [
	"_vehicle",
	"_target",
	"_weapon",
	"_quantity",
	"_burst",
	"_spread",
	"_aimOffset",
	"_turret",
	"_unit",
	"_ammoData",
	"_triggerDelay",
	"_dummies",
	"_startTime",
	"_totalTime",
	"_aimTick",
	"_viewTick",
	"_inView",
	"_triggerTick",
	"_burstStart"
];

if (!alive _vehicle || !alive _unit || _vehicle getVariable [QGVAR(abortFiring),false] || _unit call FUNC(isRemoteControlled)) exitWith {true};

_quantity params [["_quantity",10],["_isDuration",false]];

_totalTime = CBA_missionTime - _startTime;
_this set [13,_totalTime];

if (_isDuration && _totalTime > _quantity && _burstStart != 0 || {
	!_isDuration && {_vehicle getVariable [QGVAR(firedCounts),createHashMap] getOrDefault [_weapon,0] >= _quantity}
}) exitWith {true};

// Aim the turret at the target
if (_aimTick <= CBA_missionTime) then {
	_ammoData params ["","","","","_simulation","_canLock","_sensorLock","_airLock"];

	// Make camera aim at target
	private _aimASL = if (_simulation in ["shotmissile","shotrocket"] && (_canLock || _sensorLock || _airLock)) then {
		if (_target isEqualType objNull) then {getPosASL _target} else {_target}
	} else {
		[_vehicle,_turret,_target,_ammoData,_spread,0.5,_aimOffset] call FUNC(getAim)
	};

	_vehicle lockCameraTo [_aimASL,_turret,false];

	// Declare start time when initially aimed
	if (_inView && _burstStart == 0 && {[_vehicle,_turret,_aimASL] call FUNC(isAimed)}) then {
		_startTime = CBA_missionTime + 0.8;
		_this set [12,_startTime];
		_burstStart = _startTime;
		_this set [18,_burstStart];
	};

	// Update target dummy if there's spread
	if (_spread > 0) then {
		if (_target isEqualType objNull) then {
			private _pos = [_target,(call CBA_fnc_randomVector3D) vectorMultiply random [0,_spread,0]];
			{_x attachTo _pos} forEach _dummies;
		} else {
			private _pos = _target vectorAdd ((call CBA_fnc_randomVector3D) vectorMultiply random [0,_spread,0]);
			{_x setPosASL _pos} forEach _dummies;
		};
	};

	_this set [14,CBA_missionTime + AIM_TICK];
};

// Check if target is in turret view
if (_viewTick <= CBA_missionTime) then {
	_inView = [_vehicle,_target,[_turret]] call FUNC(turretsInView) isNotEqualTo [];
	_this set [15,CBA_missionTime + VIEW_TICK];
	_this set [16,_inView];
};

if (_startTime == 0 || !_inView || _triggerTick > CBA_missionTime || _burstStart > CBA_missionTime) exitWith {false};

// Fire
weaponState [_vehicle,_turret,_weapon] params ["","_muzzle","_firemode"];
_vehicle setWeaponReloadingTime [_unit,_muzzle,0];
_unit forceWeaponFire [_muzzle,_firemode];
_this set [17,CBA_missionTime + _triggerDelay];

// Update burst
_burst params [["_burstDuration",_quantity],["_burstInterval",0]];

if (_burstStart + _burstDuration <= CBA_missionTime) then {
	_this set [18,CBA_missionTime + _burstInterval];
};

_target isEqualType objNull && {!alive _target}
