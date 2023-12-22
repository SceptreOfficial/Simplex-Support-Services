#include "script_component.hpp"
//#define HELPER_TIMEOUT 5

PERFORMANCE_TRACKING_INIT

params ["_ammoData","_sourceASL","_sourceVelocity","_targetASL",["_tolerance",3],["_maxIterations",10]];
_ammoData params ["_initSpeed","_airFriction","_timeToLive","_simStep","_simulation"];

_timeToLive = _timeToLive min 15;

if (_simulation isEqualTo "shotbullet") then {
	_initSpeed = _initSpeed + _initSpeed * _simStep * 0.9;
};

if (_simulation isEqualTo "shotshell") then {
	_initSpeed = _initSpeed + _initSpeed * _simStep * 0.1;
};

// Exit if the target is very close
private _distance = _sourceASL distance2D _targetASL;

if (_distance < 200) exitWith {
	DEBUG("getAimSim: Target close; aiming directly.");
	_targetASL vectorDiff _sourceASL
};

// Exit if the target is out of range (game can crash without this if invalid weapon is used!)
private _maxRange = _initSpeed^2 / GRAVITY;

if (_distance >= _maxRange / log _maxRange) exitWith {
	DEBUG("getAimSim: Out of range.");
	_targetASL vectorDiff _sourceASL
};

private ["_simASL","_prevSimASL","_velocity"];
private _G = GRAVITY;
private _GV = [0,0,-_G];
private _iterations = 0;
private _targetZ = _targetASL # 2;
private _estElev = (_initSpeed^2 - sqrt (_initSpeed^4 - _G * (_G * _distance^2 + 2 * (_targetZ - _sourceASL # 2) * _initSpeed^2))) atan2 (_G * _distance);
private _deltaASL = if (finite _estElev) then {
	private _pos = _sourceASL getPos [_distance,_sourceASL getDir _targetASL];
	_pos set [2,_sourceASL # 2 + tan _estElev * _distance];
	_pos
} else {
	_targetASL
};

if (_sourceASL # 2 - _targetZ > 100) then {
	[{_simASL # 2 < _targetZ},{
		_deltaASL = _targetASL vectorDiff _simASL vectorMultiply (1 max ((_targetASL vectorDistance _simASL) / 50) min 2) vectorAdd _deltaASL;
		_iterations = _iterations + 1;
		_iterations < _maxIterations
	}]
} else {
	[{_simASL # 2 < getTerrainHeightASL _simASL},{
		private _simDist = _simASL distance2D _targetASL;

		if (_simDist <= _tolerance || _distance <= _simDist) then {
			_deltaASL = _targetASL vectorDiff _simASL vectorAdd _deltaASL;
		} else {
			_deltaASL = _targetASL vectorDiff _simASL vectorAdd _deltaASL vectorAdd [0,0,_simDist];
			_deltaASL = _sourceASL vectorFromTo _deltaASL vectorMultiply (
				(_targetASL vectorDiff _sourceASL) vectorDotProduct (_sourceASL vectorFromTo _targetASL)
			) vectorAdd _sourceASL;
		};

		_iterations = _iterations + 1;
		_iterations < _maxIterations
	}]
} params ["_zEval","_deltaEval"];

while {
	_simASL = _sourceASL;
	_velocity = _sourceASL vectorFromTo _deltaASL vectorMultiply _initSpeed vectorAdd _sourceVelocity;

	for "_i" from 0 to _timeToLive step _simStep do {
		_prevSimASL = _simASL;
		_velocity = _velocity vectorMultiply vectorMagnitude _velocity vectorMultiply _airFriction vectorAdd _GV vectorMultiply _simStep vectorAdd _velocity;
		_simASL = _velocity vectorMultiply _simStep vectorAdd _simASL;
		
		if (_prevSimASL vectorDistanceSqr _targetASL < _simASL vectorDistanceSqr _targetASL || _zEval) exitWith {
			#ifdef HELPER_TIMEOUT
			private _helper = "Sign_Sphere200cm_F" createVehicle [0,0,0]; _helper setPosASL _simASL;
			[{deleteVehicle _this},_helper,HELPER_TIMEOUT] call CBA_fnc_waitAndExecute;
			#endif

			_simASL = _prevSimASL vectorFromTo _simASL vectorMultiply -((_prevSimASL vectorDistance _simASL) / 2) max (
				(_targetASL vectorDiff _prevSimASL) vectorDotProduct (_prevSimASL vectorFromTo _simASL)
			) min (_prevSimASL vectorDistance _simASL) vectorAdd _prevSimASL;
		};
	};

	#ifdef HELPER_TIMEOUT
	private _helper = "Sign_Arrow_Large_Yellow_F" createVehicle [0,0,0]; _helper setPosASL _deltaASL;
	[{deleteVehicle _this},_helper,HELPER_TIMEOUT] call CBA_fnc_waitAndExecute;
	private _helper = "Sign_Arrow_Large_Blue_F" createVehicle [0,0,0]; _helper setPosASL _prevSimASL;
	[{deleteVehicle _this},_helper,HELPER_TIMEOUT] call CBA_fnc_waitAndExecute;
	private _helper = "Sign_Arrow_Large_F" createVehicle [0,0,0]; _helper setPosASL _simASL;
	[{deleteVehicle _this},_helper,HELPER_TIMEOUT] call CBA_fnc_waitAndExecute;
	#endif

	_targetASL vectorDistance _simASL > _tolerance && _deltaEval
} do {};

PERFORMANCE_TRACKING_END

#ifdef HELPER_TIMEOUT
DEBUG_2("getAimSim: Iterations: %1. Final distance: %2",_iterations,_targetASL vectorDistance _simASL);
private _helper = "Sign_Arrow_Cyan_F" createVehicle [0,0,0]; _helper setPosASL _deltaASL;
[{deleteVehicle _this},_helper,HELPER_TIMEOUT] call CBA_fnc_waitAndExecute;
#endif

_deltaASL vectorDiff _sourceASL
//_sourceASL vectorFromTo _deltaASL vectorMultiply _distance 
