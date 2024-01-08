#include "script_component.hpp"

params ["_vehicle","_turret","_aimASL",["_tolerance",20]];

private _aimingVector = ([_vehicle,_turret] call FUNC(turretSource)) vectorFromTo _aimASL vectorMultiply 400;
private _turretVector = ([_vehicle,_turret] call FUNC(turretDir)) vectorMultiply 400;

//private _source = [_vehicle,_turret] call FUNC(turretSource);
//[{drawLine3D _this},{},[ASLToAGL _source,ASLToAGL (_source vectorAdd _turretVector),[1,0,1,1]],5] call CBA_fnc_waitUntilAndExecute;
//[{drawLine3D _this},{},[ASLToAGL _source,ASLToAGL (_source vectorAdd _aimingVector),[0,1,0,1]],5] call CBA_fnc_waitUntilAndExecute;

_turretVector vectorDistanceSqr _aimingVector < _tolerance
