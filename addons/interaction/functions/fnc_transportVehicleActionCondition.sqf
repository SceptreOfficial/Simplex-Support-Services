#include "script_component.hpp"

params ["_vehicle","_player"];

if (!alive _vehicle || !alive driver _vehicle || {side _vehicle getFriend side _player < 0.6}) exitWith {false};

private _entity = _vehicle getVariable ["SSS_parentEntity",objNull];

if (isNull _entity) exitWith {false};
	
if (SSS_setting_vehicleActionRequirement && !(_entity in ([_player,"transport"] call FUNC(availableEntities)))) exitWith {};

private _showSupport = switch (_entity getVariable "SSS_supportType") do {
	case "transportHelicopter" : {SSS_showTransportHelicopters};
	case "transportLandVehicle" : {SSS_showTransportLandVehicles};
	case "transportMaritime" : {SSS_showTransportMaritime};
	case "transportPlane" : {SSS_showTransportPlanes};
	case "transportVTOL" : {SSS_showTransportVTOLs};
	default {false};
};

SSS_showTransport && _showSupport
