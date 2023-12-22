#include "script_component.hpp"
#define INDEX_FIRE_START 15
#define INDEX_REL_VEL 12
#define INDEX_ROTATIONS 17
#define INDEX_PATH 18

_ammoData # _weaponIndex params ["_initSpeed","_airFriction","_timeToLive","_simStep","_simulation","_canLock","_sensorLock","_airLock","_laserLock"];
_relVel params ["_xRelVel","_yRelVel","_zRelVel"];
_rotations params ["_dir","_pitch","_bank"];

private _rate = 8;
private _G = GRAVITY;
private _pos = _lastPos;
private _velPos = _pos vectorAdd (_lastVelocity vectorMultiply 0.5);
private _ammoSpeed = _yRelVel + _initSpeed;
private _targetASL = [_velPos,_target,_ammoSpeed] call FUNC(getTargetPos);

// Abort height
if ((_pos vectorAdd (_lastVelocity vectorMultiply 2)) # 2 < _abortHeight + getTerrainHeightASL _velPos) exitWith {_abort = true};

// Update linear spread
private _strafeDir = _velPos getDir _targetASL;
private _strafeStart = _targetASL getPos [-_spread,_strafeDir];
_strafeStart set [2,_targetASL # 2];

if (_fireStart > 0) then {
	_targetASL = _strafeStart getPos [0 max (_spread * 2 * ((CBA_missionTime - _fireStart + 1) / (_durations param [_weaponIndex,1]))) min (_spread * 2),_strafeDir];
	_targetASL set [2,_strafeStart # 2];

	private _dummy = _vehicle getVariable [QGVAR(targetDummy),objNull];

	if (isNull _dummy) then {
		if (_laserLock) then {
			_dummy = (["LaserTargetE","LaserTargetW"] select ([side group _vehicle,west] call BIS_fnc_sideIsFriendly)) createVehicle [0,0,0];
		} else {
			_dummy = (createGroup [sideLogic,true]) createUnit ["Logic",[0,0,0],[],0,"CAN_COLLIDE"];
		};

		_vehicle setVariable [QGVAR(targetDummy),_dummy];

		if (_target isEqualType objNull) then {
			_dummy attachTo [_target,[0,0,0.1]];
		};
	};

	if (_target isEqualType []) then {
		_dummy setPosASL _targetASL;
	};
} else {
	_targetASL = _strafeStart;
};

//private _helper = "Sign_Arrow_F" createVehicle [0,0,0]; _helper setPosASL _targetASL;

private _dirDiff = (_strafeDir - _dir) call CBA_fnc_simplifyAngle;
_dirDiff = [_dirDiff,_dirDiff - 360] select (_dirDiff > 180);
_dir = _dir + (-_rate max _dirDiff min _rate);

private _bankDiff = (-80 max (_dirDiff * 3) min 80) - _bank;
_bank = _bank + (-_rate max _bankDiff min _rate);

private _distance = _velPos distance2D _targetASL;
private "_pitchDiff";

// If out of range keep flying ahead, otherwise aim at the target
if (_distance > (0.9 * (_ammoSpeed * sqrt (2 * _G * (_velPos # 2 - _targetASL # 2)) / _G)) min _aimRange) then {
	_pitchDiff = -1 - _pitch;
	_pitch = _pitch + (-_rate max _pitchDiff min _rate);
} else {
	private _elevOffset = _elevOffsets param [_weaponIndex,0];

	_pitchDiff = if (_initSpeed <= 0 || (_canLock && (_sensorLock || _airLock))) then {
		private _elevation = (_ammoSpeed^2 - sqrt (_ammoSpeed^4 - _G * (_G * _distance^2 + 2 * (_targetASL # 2 - _velPos # 2) * _ammoSpeed^2))) atan2 (_G * _distance);
		if (!finite _elevation) then {_elevation = asin ((_velPos vectorFromTo _targetASL) # 2)};

		_elevOffset + _elevation - _pitch
	} else {
		private _aim = [[_ammoSpeed,_airFriction,_timeToLive,_simStep,_simulation],_velPos,[0,0,0],_targetASL,linearConversion [6000,2500,_distance,7,3.5,true]] call FUNC(getAimSim);
		_aim = [_aim,(_aim # 0) atan2 (_aim # 1)] call FUNC(rotateVector2D);

		_elevOffset + ((_aim # 2) atan2 (_aim # 1)) - _pitch
	};

	_pitch = _pitch + (-_rate max _pitchDiff min _rate);

	if (abs _dirDiff < 2 && abs _pitchDiff < 2 && _fireStart == 0) then {
		_thisArgs set [INDEX_FIRE_START,CBA_missionTime + 3.2];
		[QGVAR(strafeFireReady),[_vehicle,CBA_missionTime + 3.2]] call CBA_fnc_localEvent;
	};
};

if (_pitch < -89) exitWith {_abort = true};

_rate = 0.2;

_relVel = [
	_xRelVel * 0.95 - (-_rate max _dirDiff min _rate),
	_yRelVel,
	_zRelVel * 0.95 - ((abs _bankDiff / 2) min _rate) + (-_rate max _pitchDiff min _rate)
];

_thisArgs set [INDEX_REL_VEL,_relVel];
_thisArgs set [INDEX_ROTATIONS,[_dir,_pitch,_bank]];
_thisArgs set [INDEX_PATH,[[
	_pos,
	_velPos,
	_pos vectorAdd ([_relVel,_dir,_pitch,_bank] call FUNC(modelToWorld))
],[
	vectorDir _vehicle,
	[[0,cos _pitch,sin _pitch],-_dir] call FUNC(rotateVector2D)
],[
	vectorUp _vehicle,
	[[sin _bank,0,cos _bank],-_dir] call FUNC(rotateVector2D)
],_lastTime]];

_vehicle setVariable [QGVAR(relativeVelocity),_relVel];
