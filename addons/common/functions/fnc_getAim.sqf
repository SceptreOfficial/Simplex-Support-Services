#include "script_component.hpp"

params ["_vehicle","_turret","_target","_ammoData",["_spread",0],["_velocityStep",0],["_aimOffset",0]];

private _sourceASL = [_vehicle,_turret] call FUNC(turretSource);
private _sourceVelocity = velocity _vehicle;
if (vectorMagnitude _sourceVelocity < 2) then {_sourceVelocity = [0,0,0]};

_sourceASL = _sourceASL vectorAdd (_sourceVelocity vectorMultiply _velocityStep);

private _targetASL = [_sourceASL,_target,_ammoData # 0] call FUNC(getTargetPos);

if (_spread > 0) then {
	_targetASL = _targetASL vectorAdd ((call CBA_fnc_randomVector3D) vectorMultiply random [0,_spread,0]);
};

// If terrain is in the way just aim at the target directly
if (terrainIntersectASL [_sourceASL,_targetASL] && {terrainIntersectASL [_sourceASL,_targetASL vectorAdd [0,0,25]]}) exitWith {
	_targetASL vectorAdd [0,0,_aimOffset] 
};

_sourceASL vectorAdd ([_ammoData,_sourceASL,_sourceVelocity,_targetASL,[2.5,4] select (_vehicle isKindOf "Air")] call FUNC(getAimSim)) vectorAdd [0,0,_aimOffset];
