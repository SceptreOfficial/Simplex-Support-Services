#include "..\script_component.hpp"
/*
	Authors: Sceptre
	Compiles artillery config data and calculates firing instruction

	Parameters:
	0: Artillery <OBJECT>
	1: Target (ASL) <OBJECT | POSITION>
	2: Magazine <STRING>
	3: Sorting <BOOL>

	Returns:
	[_ETA,_mode,_modeIndex,_angle,_charge] <ARRAY>
*/
params ["_vehicle","_target","_magazine",["_sort",true,[false]]];

([_vehicle,_magazine] call FUNC(calculateData)) params ["_minElev","_maxElev","_firingOptions","_minVelocity","_maxVelocity"];

// Calculate firing instructions
_target = _target vectorAdd [0,0,-1]; // Compensate for slight overshoot in some cases
private _initSpeed = getNumber (configFile >> "CfgMagazines" >> _magazine >> "initSpeed");
private _G = GRAVITY;
private _startASL = getPosWorld _vehicle;
private _distance = _startASL distance2D _target;
private _height = _target # 2 - _startASL # 2;
private _fireOption = _vehicle getVariable QGVAR(fireOption);
private _instructions = [];


if (_vehicle getVariable [QGVAR(velocityOverride),false]) then {
	private _checkASL1 = _startASL getPos [_distance/2,_startASL getDir _target];
	private _checkASL2 = [_target # 0,_target # 1,0 max (getTerrainHeightASL _target) + 0.2];

	if (isNil "_fireOption") then {
		for "_angle" from _maxElev to _minElev step -2 do {
			private _velocity = sqrt ((_distance ^ 2 * _G) / (_distance * sin (2 * _angle) - 2 * _height * cos _angle ^ 2));
			private _ETA = round (2 * _velocity * sin _angle / _G);

			if (!finite _ETA) then {continue};

			_checkASL1 set [2,((_velocity * sin _angle) ^ 2 / (2 * _G)) - 2];
			if (terrainIntersectASL [_startASL,_checkASL1] || terrainIntersectASL [_checkASL1,_checkASL2]) exitWith {};

			if (_velocity >= _minVelocity && _velocity <= _maxVelocity) then {
				if ((_instructions pushBack [_ETA,"",-1,_angle,_velocity]) >= 5) then {break};
			};
		};

		if (_instructions isEqualTo []) exitWith {};

		private _ETAs = _instructions apply {_x # 0};
		private _avg = [0,_ETAs call BIS_fnc_arithmeticMean];
		private _distances = _ETAs apply {_avg distance2D [0,_x]};
		_instructions = [_instructions # (_distances find selectMin _distances)];
	} else {
		private _angle = _fireOption # 3;

		private _velocity = sqrt ((_distance ^ 2 * _G) / (_distance * sin (2 * _angle) - 2 * _height * cos _angle ^ 2));
		private _ETA = round (2 * _velocity * sin _angle / _G);

		if (!finite _ETA) exitWith {};

		_checkASL1 set [2,((_velocity ^ 2 * sin _angle ^ 2) / (2 * _G)) - 2];
		if (terrainIntersectASL [_startASL,_checkASL1] || terrainIntersectASL [_checkASL1,_checkASL2]) exitWith {};

		if (_velocity >= _minVelocity && _velocity <= _maxVelocity && finite _ETA) then {
			_instructions pushBack [_ETA,"",-1,_angle,_velocity];
		};
	};
} else {
	if (isNil "_fireOption") then {
		{
			private _velocity = _x # 2 * _initSpeed;
			private _angle = atan ((_velocity^2 + sqrt (_velocity^4 - _G * ((_G * _distance^2) + (2 * _height * _velocity^2)))) / (_G * _distance));
			private _ETA = round (2 * _velocity * sin _angle / _G);

			if (_angle >= _minElev && _angle <= _maxElev && finite _ETA) then {
				_instructions pushBack [_ETA,_x # 0,_x # 1,_angle,_x # 2];
			};
		} forEach _firingOptions;
	} else {
		private _velocity = _fireOption # 2 * _initSpeed;
		private _angle = atan ((_velocity^2 + sqrt (_velocity^4 - _G * ((_G * _distance^2) + (2 * _height * _velocity^2)))) / (_G * _distance));
		private _ETA = round (2 * _velocity * sin _angle / _G);

		if (finite _ETA) then {
			_instructions pushBack [_ETA,_fireOption # 0,_fireOption # 1,_angle,_fireOption # 2];
		};
	};
};	

if (_instructions isEqualTo []) exitWith {[]};

_instructions sort _sort;
_instructions # 0
