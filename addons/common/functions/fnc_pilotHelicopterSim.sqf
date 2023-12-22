#include "script_component.hpp"

_thisArgs params [
	"_vehicle",
	"_endASL",
	"_endRotation",
	"_complete",
	"_lastPos",
	"_startTime",
	"_controlTime",
	"_posList",
	"_dirList",
	"_upList",
	"_endDirUp",
	"_lastTime"
];

if (!alive _vehicle ||
	!alive driver _vehicle ||
	isPlayer driver _vehicle ||
	!canMove _vehicle ||
	!local _vehicle
) exitWith {
	//diag_log format ["pilotHelicopter sim end (failed): %1",[CBA_missionTime,alive _vehicle,alive driver _vehicle,isPlayer driver _vehicle,canMove _vehicle,local _vehicle]];
	removeMissionEventHandler [_thisEvent,_thisEventHandler];

	_vehicle setVariable [QGVAR(pilotHelicopter),nil,true];
	_vehicle setVariable [QGVAR(pilotHelicopterCancel),nil,true];
	
	if (_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
		private _velocity = velocity _vehicle;
		_vehicle setVelocity [_velocity # 0,_velocity # 1,1];
	};
	
	_vehicle flyInHeight ((_vehicle getVariable [QPVAR(entity),objNull]) getVariable [QPVAR(altitudeATL),100]);
	_vehicle doFollow _vehicle;

	// PUBLIC EVENT
	[QGVAR(pilotHelicopterCancelled),[_vehicle]] call CBA_fnc_globalEvent;
};

private _progress = (CBA_missionTime - _startTime) / _controlTime;
private _delta = CBA_missionTime - _lastTime max 0.000001;
_thisArgs set [11,CBA_missionTime];

if (_progress > 1) exitWith {
	_endRotation params ["_endDir","_endPitch","_endBank"];
	_complete params ["_completeCondition","_completeArgs"];

	if (_completeArgs call _completeCondition) then {
		//diag_log format ["pilotHelicopter sim end (successful): %1",[CBA_missionTime,alive _vehicle,alive driver _vehicle,isPlayer driver _vehicle,canMove _vehicle,local _vehicle]];
		removeMissionEventHandler [_thisEvent,_thisEventHandler];

		_vehicle setVariable [QGVAR(pilotHelicopter),nil,true];
		_vehicle setVariable [QGVAR(pilotHelicopterCompleted),true,true];
		_vehicle flyInHeight 100;
		_vehicle doFollow _vehicle;

		// PUBLIC EVENT
		[QGVAR(pilotHelicopterCompleted),[_vehicle]] call CBA_fnc_globalEvent;
	};

	if !(_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
		//diag_log format ["pilotHelicopter sim reached: %1",CBA_missionTime];
		_vehicle setVariable [QGVAR(pilotHelicopterReached),true,true];

		// PUBLIC EVENT
		[QGVAR(pilotHelicopterReached),[_vehicle]] call CBA_fnc_globalEvent;
	};
};

private _pos = _progress bezierInterpolation _posList;
private _dir = _progress bezierInterpolation _dirList;
private _up = _progress bezierInterpolation _upList;
private _velocity = _pos vectorDiff _lastPos vectorMultiply 1 / _delta;
_thisArgs set [4,_pos];

_vehicle setVelocityTransformation [_pos,_pos,_velocity,_velocity,_dir,_dir,_up,_up,_progress];
_vehicle setVelocity _velocity;

if (_delta >= 0.5 && {!isNull (_vehicle getVariable [QGVAR(slingloadCargo),objNull])}) then {
	LOG("Frame drop detected. Moving slingloaded cargo.");
	_vehicle setVariable [QGVAR(frameDrop),true,true];
	[FUNC(slingload),[_vehicle,_vehicle getVariable QGVAR(slingloadCargo),true,true]] call CBA_fnc_execNextFrame;
};

//diag_log format ["pilotHelicopter sim: %1",[_progress,_velocity,vectorMagnitude _velocity,_delta]];
