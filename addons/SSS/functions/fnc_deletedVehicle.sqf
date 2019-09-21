#include "script_component.hpp"

if (!isServer) exitWith {};

params [["_vehicle",objNull,[objNull]]];

private _entity = _vehicle getVariable ["SSS_parentEntity",objNull];

if (isNull _entity) exitWith {};

if (!SSS_setting_removeSupportOnVehicleDeletion && (_entity getVariable "SSS_respawnTime") >= 0) then {
	_vehicle call FUNC(respawn);
} else {
	deleteVehicle _entity;
};
