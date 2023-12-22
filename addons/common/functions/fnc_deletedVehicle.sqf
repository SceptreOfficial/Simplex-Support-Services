#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_vehicle",objNull,[objNull]]];

private _entity = _vehicle getVariable [QPVAR(entity),objNull];

if (isNull _entity) exitWith {
	//DEBUG_1("Vehicle deleted (null entity): %1",_vehicle);
};

//DEBUG_1("Vehicle deleted: %1",_vehicle);

if (OPTION(removeEntityOnVehicleDeletion) || _entity getVariable [QPVAR(respawnDelay),-1] < 0) then {
	_entity call FUNC(removeEntity);
} else {
	if (isNil {_entity getVariable QPVAR(base)}) exitWith {};
	_vehicle call FUNC(respawn);
};
