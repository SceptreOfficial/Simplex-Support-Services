#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(slingloadDropoff),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_posASL",[0,0,0],[[]]]
];

private _cargo = _vehicle getVariable [QGVAR(slingloadCargo),objNull];

if (isNull _cargo) exitWith {
	[_vehicle,objNull] call FUNC(slingload);
};

if (_posASL isEqualTo [0,0,0]) then {
	_posASL = getPosASL _vehicle;
	_posASL set [2,0];
	_posASL = AGLToASL _posASL;
};

private _ix = lineIntersectsSurfaces [_posASL vectorAdd [0,0,50],_posASL vectorAdd [0,0,-10],_vehicle,_cargo,true,1,"GEOM","FIRE"];
if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};

[
	_vehicle,
	_posASL vectorAdd [0,0,(_vehicle getVariable [QGVAR(slingloadRopeLength),12])],
	[],
	60,
	50,
	-9,
	[{
		[_vehicle,objNull] call FUNC(slingload);
		true
	}]
] call FUNC(pilotHelicopter);
