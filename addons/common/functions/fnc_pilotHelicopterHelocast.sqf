#include "script_component.hpp"

params ["_hold","_hoverHeight","_hoverSpeed","_helocastPos"];

if !(_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
	doStop _vehicle;
};

private _holdProgress = if (_hold >= 0) then {
	(CBA_missionTime - (_startTime + _controlTime)) / (_hold max 1);
} else {0};

if (_holdProgress > 0.9) then {_vehicle flyInHeight ((_vehicle getVariable [QPVAR(entity),objNull]) getVariable [QPVAR(altitudeATL),100])};
if (_holdProgress > 1) exitWith {
	_vehicle setVelocity [0,0,1.5];
	true
};

if (_helocastPos isEqualTo []) then {
	_helocastPos = _endASL getPos [_hoverSpeed * (_hold max 0),getDirVisual _vehicle];
	_helocastPos set [2,_endASL # 2];
	_this set [3,_helocastPos];
};

_vehicle setVelocityTransformation [
	_endASL,
	_helocastPos,
	[0,0,0],
	[0,0,1.5],
	_endDirUp # 0,
	_endDirUp # 0,
	_endDirUp # 1,
	_endDirUp # 1,
	[0,1,_holdProgress,1.4] call BIS_fnc_easeInOut
];

false
