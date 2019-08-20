#include "script_component.hpp"

SSS_markers = [];
SSS_postInitDone = false;

// Service enabling
SSS_artilleryEnabled = true;
SSS_CASEnabled = true;
SSS_CASDronesEnabled = true;
SSS_CASGunshipsEnabled = true;
SSS_CASHelisEnabled = true;
SSS_CASPlanesEnabled = true;
SSS_transportEnabled = true;

//-----------------------------------------------------------------------------------------------//
// Give UAV Terminal on CAS Drone request
SSS_setting_GiveUAVTerminal = true;

// Default respawn time for physical entities
SSS_setting_respawnTimeDefault = 60;

// Artillery cooldown between requests [minimum, extra time per round fired]
SSS_setting_artilleryCooldownDefault = [90,8];

// Virtual entity cooldowns between requests
SSS_setting_CASDronesCooldownDefault = 600;
SSS_setting_CASDronesLoiterTime = 300;
SSS_setting_CASGunshipsCooldownDefault = 720;
SSS_setting_CASGunshipsLoiterTime = 300;
SSS_setting_CASPlanesCooldownDefault = 300;
//-----------------------------------------------------------------------------------------------//
// Handle curator deletion of entities and waypoints
["ModuleCurator_F","init",{
	params ["_zeus"];

	_zeus addEventHandler ["CuratorWaypointDeleted",{
		params ["_zeus","_group"];

		if (_group getVariable ["SSS_protectWaypoints",false]) then {
			private _vehicle = vehicle leader _group;
			switch (_vehicle getVariable "SSS_service") do {
				case "transport" : {
					["SSS_transportRequest",[_vehicle,0],_vehicle] call CBA_fnc_targetEvent;
					SSS_WARNING_1("Support vehicle waypoint was deleted! %1 - RTB",_vehicle getVariable "SSS_displayName")
				};
				case "CASHelis" : {
					["SSS_CASRequest",[_vehicle,0],_vehicle] call CBA_fnc_targetEvent;
					SSS_WARNING_1("Support vehicle waypoint was deleted! %1 - RTB",_vehicle getVariable "SSS_displayName")
				};
				default {SSS_WARNING("Support vehicle waypoint was deleted!")};
			};
		};
	}];
}] call CBA_fnc_addClassEventHandler;
