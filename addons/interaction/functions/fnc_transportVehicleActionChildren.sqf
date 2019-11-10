#include "script_component.hpp"

params ["_vehicle","_player"];

private _entity = _vehicle getVariable ["SSS_parentEntity",objNull];

if (isNull _entity) exitWith {};

switch (_entity getVariable "SSS_supportType") do {
	case "transportHelicopter" : {[_vehicle,_player,_entity] call FUNC(childActionsTransportHelicopter)};
	case "transportLandVehicle" : {[_vehicle,_player,_entity] call FUNC(childActionsTransportLandVehicle)};
	case "transportMaritime" : {[_vehicle,_player,_entity] call FUNC(childActionsTransportMaritime)};
	case "transportPlane" : {[_vehicle,_player,_entity] call FUNC(childActionsTransportPlane)};
	case "transportVTOL" : {[_vehicle,_player,_entity] call FUNC(childActionsTransportVTOL)};
	default {[]};
}
