#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(planeTakeoff),_this] call CBA_fnc_directCall};

params ["_entity","_vehicle"];

_vehicle setFuel (_vehicle getVariable [QGVAR(fuel),1]);
_vehicle engineOn true;

private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];

if (_virtualRunway isNotEqualTo [0,0,0]) exitWith {
	_vehicle setDir (_entity getVariable [QPVAR(virtualRunwayDir),0]);
	_vehicle setVehiclePosition [_virtualRunway,[],0,"FLY"];
	_vehicle setVectorUp [0,0,1];
	_vehicle setVelocityModelSpace [0,getNumber (configOf _vehicle >> "maxSpeed") / 3.6,0];
};

_vehicle call EFUNC(common,nearestRunway) params ["_runwayPosASL","_runwayDir"];

//DEBUG_3("""%1"" Takeoff [%2,%3]",_entity getVariable QPVAR(callsign),_runwayPosASL,_runwayDir);

private _offsetASL = AGLtoASL (_runwayPosASL getPos [50,_runwayDir - 180]);
private _ix = lineIntersectsSurfaces [_runwayPosASL vectorAdd [0,0,2],_offsetASL vectorAdd [0,0,1],_vehicle,objNull,true,1,"GEOM","FIRE"];
if (_ix isNotEqualTo []) then {
	_offsetASL = _ix # 0 # 0;
};

[_vehicle,_offsetASL] call FUNC(placementSearch) params ["_safePos","_safeUp"];

_vehicle setDir _runwayDir;

if (!isNil "_safePos") then {
	_vehicle setPosASL _safePos;
	_vehicle setVectorUp _safeUp;
} else {
	_vehicle setPosASL _runwayPosASL;
	_vehicle setVectorUp surfaceNormal _runwayPosASL;
};

