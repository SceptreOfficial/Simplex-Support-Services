#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(canSlingLoad),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_cargo",objNull,[objNull]],
	["_massOverride",false,[false]]
];

private _maxMass = getNumber (configOf _vehicle >> "slingLoadMaxCargoMass") max 1;
private _cargoMass = getMass _cargo;

alive _vehicle &&
!isNull _cargo &&
_vehicle != _cargo &&
simulationEnabled _cargo &&
!isSimpleObject _cargo &&
_cargoMass > 0 &&
{_cargoMass < _maxMass || _massOverride} &&
{[side _vehicle,side _cargo] call BIS_fnc_sideIsFriendly} &&
{!(_cargo isKindOf "Man") && !(_cargo isKindOf "Air" && isEngineOn _cargo)} &&
{GVAR(slingLoadConditions) findIf {[_vehicle,_cargo] call _x} == -1}
