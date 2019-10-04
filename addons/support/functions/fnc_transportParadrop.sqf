#include "script_component.hpp"

params ["_entity","_vehicle","_jumpDelay","_AIOpeningHeight"];

private _unit = selectRandom ((crew _vehicle) - (units group _vehicle));

if (isNil "_unit") exitWith {};

[{
	params ["_entity","_vehicle","_unit"];
	isNull _entity || !alive _vehicle || !alive _unit
},{
	params ["_entity","_vehicle","_unit","_jumpDelay","_AIOpeningHeight"];

	if (isNull _entity || !alive _vehicle) exitWith {};

	[_entity,_vehicle,_jumpDelay,_AIOpeningHeight] call FUNC(transportParadrop);
},[_entity,_vehicle,_unit,_jumpDelay,_AIOpeningHeight],_jumpDelay,{
	params ["_entity","_vehicle","_unit","_jumpDelay","_AIOpeningHeight"];

	moveOut _unit;
	[_unit,_AIOpeningHeight] remoteExecCall [QFUNC(transportDoParadrop),_unit];
	[_entity,_vehicle,_jumpDelay,_AIOpeningHeight] call FUNC(transportParadrop);
}] call CBA_fnc_waitUntilAndExecute;
