#include "script_component.hpp"
#define INDEX_LAST_POS 13
#define INDEX_LAST_VEL 14
#define INDEX_FIRE_START 15
#define INDEX_TRIGGER_TICK 16
#define INDEX_LAST_TIME 19
#define INDEX_WEAPON_INDEX 20

_thisArgs params [
	"_vehicle",
	"_target",
	"_weapons",
	"_infiniteAmmo",
	"_spread",
	"_quantities",
	"_intervals",
	"_aimRange",
	"_elevOffsets",
	"_magazines",
	"_ammoData",
	"_durations",
	"_relVel",
	"_lastPos",
	"_lastVelocity",
	"_fireStart",
	"_triggerTick",
	"_rotations",
	"_path",
	"_lastTime",
	"_weaponIndex",
	"_turrets",
	"_abortHeight"
];

_quantities param [_weaponIndex,[]] params [["_quantity",0],["_isDuration",false]];

private _magazine = _magazines param [_weaponIndex,""];

if (_isDuration && {_fireStart > 0 && (CBA_missionTime - _fireStart) >= _quantity} ||
	!_isDuration && {(_vehicle getVariable [QGVAR(firedCounts),createHashMap] getOrDefault [_magazine,0]) >= _quantity}
) then {
	_weaponIndex = _weaponIndex + 1;
	_quantity = _quantities param [_weaponIndex,[]] param [0,0];
	_isDuration = _quantities param [_weaponIndex,[]] param [1,false];
	_fireStart = CBA_missionTime + ([1.5,3] select (_ammoData param [_weaponIndex,[]] param [0,0] <= 0));
	_triggerTick = 0;
	_magazine = _magazines param [_weaponIndex,""];
	_thisArgs set [INDEX_WEAPON_INDEX,_weaponIndex];
	_thisArgs set [INDEX_FIRE_START,_fireStart];
	_thisArgs set [INDEX_TRIGGER_TICK,_triggerTick];
};

if (_quantity == 0) exitWith {true call FUNC(strafeCleanup)};

if (!alive _vehicle ||
	!canMove _vehicle ||
	!local _vehicle ||
	_vehicle getVariable [QGVAR(strafeCancel),false] ||
	{_target isEqualType objNull && {isNull _target}}
) exitWith {false call FUNC(strafeCleanup)};

private _progress = CBA_missionTime - (_path # 3);
private _delta = CBA_missionTime - _lastTime max 0.000001;
private _abort = false;

if (_progress >= 0.4) then {call FUNC(strafeUpdate)};

if (_abort) exitWith {true call FUNC(strafeCleanup)};

_path params ["_posList","_dirList","_upList"];

if (_posList isEqualTo []) exitWith {};

private _pos = _progress bezierInterpolation _posList;
private _dir = _progress bezierInterpolation _dirList;
private _up = _progress bezierInterpolation _upList;
private _velocity = _pos vectorDiff _lastPos vectorMultiply 1 / _delta;
_thisArgs set [INDEX_LAST_POS,_pos];
_thisArgs set [INDEX_LAST_VEL,_velocity];
_thisArgs set [INDEX_LAST_TIME,CBA_missionTime];

_vehicle setVelocityTransformation [_pos,_pos,_velocity,_velocity,_dir,_dir,_up,_up,_progress];
_vehicle setVelocity _velocity;

if (_fireStart > 0 && _fireStart <= CBA_missionTime && _triggerTick <= CBA_missionTime) then {
	private _weapon = _weapons param [_weaponIndex,""];
	private _turret = _turrets param [_weaponIndex,[]];
	private _unit = _vehicle turretUnit _turret;

	if (_weapon isEqualTo "" || !alive _unit) exitWith {_abort = true};

	if ((_vehicle currentWeaponTurret _turret) != _weapon) then {
		_vehicle selectWeaponTurret [_weapon,_turret];
	};

	weaponState [_vehicle,_turret,_weapon] params ["","_muzzle","_firemode","","_ammoCount"];

	if (_ammoCount <= 0) then {
		if (_infiniteAmmo) exitWith {
			_vehicle setVehicleAmmo 1;
			_ammoCount = 1;
		};

		if ([_magazine] arrayIntersect (_vehicle magazinesTurret [_turret,false]) isNotEqualTo []) exitWith {
			_vehicle loadMagazine [_turret,_weapon,_magazine];
			_ammoCount = 1;
		};
	};

	if (_ammoCount <= 0) exitWith {
		_thisArgs set [INDEX_WEAPON_INDEX,_weaponIndex + 1];
	};

	if (_infiniteAmmo) then {
		_vehicle setVehicleAmmo 1;
	};

	_vehicle lockCameraTo [_vehicle getVariable [QGVAR(targetDummy),objNull],_turret,false];
	_vehicle setWeaponReloadingTime [_unit,_muzzle,0];
	_unit forceWeaponFire [_muzzle,_firemode];
	_thisArgs set [INDEX_TRIGGER_TICK,_intervals # _weaponIndex + CBA_missionTime];

	//[QGVAR(strafeFireTrigger),[_vehicle,_weapon,(CBA_missionTime - _fireStart) / _duration]] call CBA_fnc_localEvent;
	//LOG_4("Strafe trigger pull - %3 (%4/1) %1:%2",_muzzle,_firemode,CBA_missionTime,(CBA_missionTime - _fireStart) / (_durations param [_weaponIndex,1]));
};

if (_abort) then {true call FUNC(strafeCleanup)};
