#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(pilotHelicopter),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_endASL",[0,0,0],[[],objNull],3],
	["_endRotation",[],[[],0]],
	["_altitude",50,[0]],
	["_approachDistance",150,[0]],
	["_maxDropSpeed",-9.5,[0]],
	["_complete",{true},[{},[]]]
];

if (!alive _vehicle || !alive driver _vehicle || isPlayer driver _vehicle || !canMove _vehicle) exitWith {};

// Run locally
if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(pilotHelicopter)],_vehicle] call CBA_fnc_targetEvent;
};

// Cancel previous plan
if (_vehicle getVariable [QGVAR(pilotHelicopter),false]) then {
	removeMissionEventHandler ["EachFrame",_vehicle getVariable [QGVAR(pilotHelicopterEFID),-1]];
	_vehicle setVariable [QGVAR(pilotHelicopterEFID),nil];

	if (_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
		private _velocity = velocity _vehicle;
		_vehicle setVelocity [_velocity # 0,_velocity # 1,1.5];
	};

	_vehicle flyInHeight ((_vehicle getVariable [QPVAR(entity),objNull]) getVariable [QPVAR(altitudeATL),100]);
	_vehicle doFollow _vehicle;

	// PUBLIC EVENT
	[QGVAR(pilotHelicopterCancelled),[_vehicle]] call CBA_fnc_localEvent;
};

if (_endASL isEqualType objNull) then {_endASL = getPosASL _endASL};

// Stop here if null pos
if (_endASL isEqualTo [0,0,0]) exitWith {_vehicle setVariable [QGVAR(pilotHelicopter),nil,true]};

private _vtol = _vehicle isKindOf "VTOL_Base_F" || _vehicle getVariable [QPVAR(vtol),false];

// Validate input
_endRotation params [["_endDir",-1,[0]],["_endPitch",0,[0]],["_endBank",0,[0]]];
_endRotation = [_endDir,-89.9 max _endPitch min 89.9,-179.9 max _endBank min 179.9];
_complete params [["_completeCondition",{true},[{}]],["_completeArgs",[]]];
_complete = [_completeCondition,_completeArgs];
_altitude = _altitude max ([10,115] select _vtol);
_approachDistance = _approachDistance max 10;
if (_endDir >= 0) then {_endDir = _endDir call CBA_fnc_simplifyAngle};

// Create a path to follow
private _startASL = getPosASL _vehicle;
private _velocity = velocity _vehicle;
private _maxSpeed = (getNumber (configOf _vehicle >> "maxSpeed")) / 3.6;
private _seaHeight = linearConversion [0,1,waves,0,getNumber (configFile >> "CfgWorlds" >> worldName >> "Sea" >> "maxTide")] - getNumber (configOf _vehicle >> "maxFordingDepth");
private _posList = [_startASL,_startASL vectorAdd _velocity];
private _dirList = [vectorDir _vehicle,vectorDir _vehicle];
private _upList = [vectorUp _vehicle,vectorUp _vehicle];
private _pos = _posList # 1;
private _dir = getDir _vehicle;
if (_dir % 90 isEqualTo 0) then {_dir = _dir - 0.0001};
private _endZ = _endASL # 2;

[
	[1100,2.5,6,70,70,5.5,6.5,10,60],
	[3500,3,12,40,40,4.5,4.5,1,30]
] select _vtol params [
	"_maxVelDist",
	"_accelMin",
	"_accelMax",
	"_pitchLimit",
	"_bankLimit",
	"_pitchCoef",
	"_bankCoef",
	"_yawSlow",
	"_yawFast"
];

private _fnc_height = {
	params ["_pos","_height"];
	private _ix = lineIntersectsSurfaces [_pos vectorAdd [0,0,2],_pos vectorAdd [0,0,-_height],_vehicle,objNull,true,1,"GEOM","FIRE"];
	if (_ix isNotEqualTo []) then {_height = _pos # 2 - _ix # 0 # 0 # 2};
	_height
};

private [
	"_yVel",
	"_distance2D",
	"_targetVelocity",
	"_targetPos",
	"_minHeight",
	"_height",
	"_acceleration",
	"_velocityChange",
	"_pitch",
	"_bank",
	"_targetDir",
	"_yawLimit",
	"_relDir"
];

// Debug
//private _perfStart = diag_tickTime;

while {
	// How fast should the helicopter go
	_yVel = ([_velocity,-_dir] call FUNC(rotateVector2D)) # 1;
	_distance2D = _pos distance2D _endASL;
	_targetVelocity = (_pos vectorFromTo _endASL) vectorMultiply ([
		0.8,
		_maxSpeed,
		linearConversion [0,_maxVelDist,_distance2D,0,1,true],
		1.5
	] call BIS_fnc_easeOut);
	_targetPos = _pos vectorAdd _targetVelocity;
	
	// Handle Z axis
	if (_distance2D < _approachDistance) then {
		_minHeight = linearConversion [2,8,_distance2D,0,8,true];
		_height = [_targetPos,10] call _fnc_height;

		if (_height < _minHeight) then {
			_targetVelocity set [2,_maxDropSpeed max (_minHeight - _height) min 15];
		} else {
			_targetVelocity set [2,_maxDropSpeed max (_endZ + _minHeight - _pos # 2) min 15];
		};
		
		_acceleration = linearConversion [0,80,vectorMagnitude _velocity,_accelMin,_accelMax];
		_velocityChange = (_targetVelocity vectorDiff _velocity) apply {_x / _acceleration};
		_targetPos = _pos vectorAdd (_velocity vectorAdd _velocityChange);
		_targetPos set [2,(_targetPos # 2) max (getTerrainHeightASL _targetPos) max _seaHeight];
		_velocity = _targetPos vectorDiff _pos;

		[_velocityChange,-_dir,2] call BIS_fnc_rotateVector3D
	} else {
		_height = [_targetPos,_altitude + 10] call _fnc_height;
		_targetVelocity set [2,_maxDropSpeed max (_altitude - _height) min 15];

		_acceleration = linearConversion [0,80,vectorMagnitude _velocity,_accelMin + 2,_accelMax];
		_velocityChange = (_targetVelocity vectorDiff _velocity) apply {_x / _acceleration};
		_targetPos = _pos vectorAdd (_velocity vectorAdd _velocityChange);
		_targetPos set [2,(_targetPos # 2) max (((getTerrainHeightASL _targetPos) max _seaHeight) + 5)];
		_velocity = _targetPos vectorDiff _pos;

		[_velocityChange,-_dir,2] call BIS_fnc_rotateVector3D
	} params ["_xVelChange","_yVelChange"];

	// Wanted pitch and roll
	_pitch = -_pitchLimit max (-_yVelChange * _pitchCoef) min _pitchLimit;
	_bank = -_bankLimit max (_xVelChange * _bankCoef) min _bankLimit;

	// Wanted direction
	_targetDir = switch true do {
		case (_endDir >= 0 && {_pos distance _endASL < 15}) : {_endDir};
		case (_distance2D < 15) : {_dir};
		default {_pos getDir _endASL};
	};

	// Limit yaw at fast speeds
	_yawLimit = linearConversion [0,60,abs _yVel,_yawFast,_yawSlow,true];

	// Commit
	_dirList pushBack ([[0,cos _pitch,sin _pitch],360-_dir] call FUNC(rotateVector2D));
	_upList pushBack ([[sin _bank,0,cos _bank],360-_dir] call FUNC(rotateVector2D));

	_relDir = (_targetDir - _dir) call CBA_fnc_simplifyAngle;
	_dir = (_dir + (-_yawLimit max ([_relDir,_relDir - 360] select (_relDir > 180)) min _yawLimit)) call CBA_fnc_simplifyAngle;
	if (_dir % 90 isEqualTo 0) then {_dir = _dir - 0.0001};
	
	_pos = _pos vectorAdd _velocity;
	_pos set [2,(_pos # 2) max ((getTerrainHeightASL _pos) max _seaHeight)];
	_posList pushBack _pos;

	_endASL distance _pos > 2 && count _posList < 300
} do {};

_posList pushBack (_endASL vectorAdd [0,0,0.4]);
_posList pushBack _endASL;

if (_endDir >= 0) then {
	_dirList pushBack ([[0,cos _endPitch,sin _endPitch],360-_endDir] call FUNC(rotateVector2D));
	_upList pushBack ([[sin _endBank,0,cos _endBank],360-_endDir] call FUNC(rotateVector2D));
} else {
	_dirList pushBack ([[0,cos _endPitch,sin _endPitch],360-_dir] call FUNC(rotateVector2D));
	_upList pushBack ([[sin _endBank,0,cos _endBank],360-_dir] call FUNC(rotateVector2D));
};

// Debug
//private _perfTotal = (diag_tickTime - _perfStart) * 1000;
//{
//	private _helper = "Sign_Arrow_Large_Yellow_F" createVehicle [0,0,0];
//	_helper setPosASL _x;
//	_helper setVectorDirAndUp [_dirList param [_forEachIndex,[0,1,0]],_upList param [_forEachIndex,[0,0,1]]];
//} forEach _posList;
//diag_log format ["pilotHelicopter debug dump 1/2: %1",[["exec ms",_perfTotal],_vehicle,_endASL,_endRotation,_startASL,CBA_missionTime,count _posList,_altitude,_approachDistance,_maxDropSpeed]];
//diag_log format ["pilotHelicopter debug dump 2/2: %1",[_posList,_dirList,_upList]];

// Begin control
_vehicle engineOn true;
doStop _vehicle;
_vehicle setVariable [QGVAR(pilotHelicopter),true,true];
_vehicle setVariable [QGVAR(pilotHelicopterReached),false,true];
_vehicle setVariable [QGVAR(pilotHelicopterCompleted),false,true];

//diag_log format ["pilotHelicopter sim start: %1",CBA_missionTime];
private _EFID = addMissionEventHandler ["EachFrame",{call FUNC(pilotHelicopterSim)},[
	_vehicle,
	_endASL,
	_endRotation,
	_complete,
	_startASL,
	CBA_missionTime,
	count _posList,
	_posList,
	_dirList,
	_upList,
	[_dirList # -1,_upList # -1],
	CBA_missionTime
]];

_vehicle setVariable [QGVAR(pilotHelicopterEFID),_EFID];

// PUBLIC EVENT
[QGVAR(pilotHelicopterSim),_this] call CBA_fnc_localEvent;
