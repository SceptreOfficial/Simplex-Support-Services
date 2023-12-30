#include "script_component.hpp"

params ["_hold","_engine"];

if !(_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
	doStop _vehicle;
	_vehicle flyInHeight 0;
	_vehicle action ["LandGear",_vehicle];

	if (_vehicle isKindOf "VTOL_base_F") then {
		private _posASL = +_endASL;
		private _ix = lineIntersectsSurfaces [_endASL,_endASL vectorAdd [0,0,-10],_vehicle,objNull,true,1,"GEOM","FIRE"];
		if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};
		
		private _pad = "Land_HelipadEmpty_F" createVehicle [0,0,0];
		_pad setPosASL _posASL;
		[{deleteVehicle _this},_pad,10] call CBA_fnc_waitAndExecute;
		
		[{
			if (_this getVariable [QGVAR(pilotHelicopter),false]) then {
				_this land "GET IN";
			};
		},_vehicle,0.2] call CBA_fnc_waitAndExecute;
	};
};

private _holdProgress = if (_hold >= 0) then {
	(CBA_missionTime - (_startTime + _controlTime)) / (_hold max 1);
} else {0};

(_vehicle call BIS_fnc_getPitchBank) params ["_pitch","_bank"];

if (abs _pitch > 30 || abs _bank > 30 || _holdProgress > 1 || _vehicle distance2D _endASL > 20) exitWith {true};

private _vel = velocity _vehicle;
	
if (isTouchingGround _vehicle) then {
	if (_engine && !isEngineOn _vehicle) then {_vehicle engineOn true};
	if (!_engine && isEngineOn _vehicle) then {_vehicle engineOn false};

	_vehicle setVelocity [_vel # 0 * 0.7,_vel # 1 * 0.7,(_vel # 2 * 0.99) min -0.1];
} else {
	_vehicle setVelocity [_vel # 0,_vel # 1,(_vel # 2 - 0.015) max -1];
};

false