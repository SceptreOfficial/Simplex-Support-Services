#include "script_component.hpp"

params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];

[vectorDir _vehicle,vectorUp _vehicle] call FUNC(yawPitchBank) params ["_dir","_pitch","_bank"];

private _relVelY = (_vehicle getVariable [QGVAR(relativeVelocity),velocityModelSpace _vehicle]) # 1;
private _velocity = if (_vehicle getVariable [QGVAR(precisionBombing),true]) then {
	[[0,_relVelY,0],_dir,_pitch,_bank] call FUNC(modelToWorld)
} else {
	[[random 2 - 4,_relVelY + random 1.5 - 3,random 2 - 4],_dir,_pitch,_bank] call FUNC(modelToWorld)
};
private _pos = getPosASL _projectile;
private _posList = [_pos];
private _dirList = [vectorDir _projectile];
private _upList = [vectorUp _projectile];
private _GV = [0,0,-9.8];
private _pitchLimit = linearConversion [0,250,_relVelY,-90,_pitch,true];

while {
	_pitch = (_pitch - 8) max _pitchLimit;
	_bank = _bank * 0.9;
	//_dir = _dir + (((_pos getDir (_pos vectorAdd _velocity)) - _dir) / 2);

	_velocity = _velocity vectorAdd _GV;
	_pos = _pos vectorAdd _velocity;
	
	_posList pushBack _pos;
	_dirList pushBack ([[0,cos _pitch,sin _pitch],-_dir] call FUNC(rotateVector2D));
	_upList pushBack ([[sin _bank,0,cos _bank],-_dir] call FUNC(rotateVector2D));

	_pos # 2 > 0 && _pos # 2 > getTerrainHeightASL _pos
} do {};

private _triggerDistance = getNumber (configFile >> "CfgAmmo" >> _ammo >> "triggerDistance");
if (_triggerDistance > 0) then {DEBUG_2("%1 Trigger distance: %2",str _ammo,_triggerDistance)};
private _triggerTime = getNumber (configFile >> "CfgAmmo" >> _ammo >> "triggerTime");
if (_triggerTime > 0) then {DEBUG_2("%1 Trigger time: %2",str _ammo,_triggerTime)};

[{
	params ["_posList","_dirList","_upList","_totalTime","_startTime","_lastPos","_projectile","_triggerDistance","_lastTime"];

	private _progress = (CBA_missionTime - _startTime) / _totalTime;
	private _delta = CBA_missionTime - _lastTime max 0.000001;
	_this set [8,CBA_missionTime];

	if (!alive _projectile || _progress > 1) exitWith {true};

	private _pos = _progress bezierInterpolation _posList;
	private _dir = _progress bezierInterpolation _dirList;
	private _up = _progress bezierInterpolation _upList;
	private _velocity = _pos vectorDiff _lastPos vectorMultiply 1 / _delta;
	_this set [5,_pos];

	//private _helper = "Sign_Sphere25cm_F" createVehicle [0,0,0];
	//_helper setPosASL _pos;

	if (_triggerDistance > 0 && {_pos # 2 <= _triggerDistance + getTerrainHeightASL _pos}) exitWith {
		triggerAmmo _projectile;
		true
	};

	_projectile setVelocityTransformation [_pos,_pos,_velocity,_velocity,_dir,_dir,_up,_up,_progress];
	_projectile setVelocity _velocity;

	false
},{},[
	_posList,
	_dirList,
	_upList,
	count _posList,
	CBA_missionTime,
	getPosASL _projectile,
	_projectile,
	_triggerDistance,
	CBA_missionTime
]] call CBA_fnc_waitUntilAndExecute;
