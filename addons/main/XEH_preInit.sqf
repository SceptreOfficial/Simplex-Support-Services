#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

// Addon Options
["SSS_setting_useChatNotifications","CHECKBOX",
	["Use chat notifications","Disables custom notification system"],
	["Simplex Support Services","Personal"],
	false, // _valueInfo
	false, // _isGlobal
	{}, //_script
	false // _needRestart
] call CBA_fnc_addSetting;

["SSS_setting_GiveUAVTerminal","CHECKBOX",
	["Give UAV Terminal on drone request","Gives CAS Drone requesters a UAV terminal if they don't have one"],
	["Simplex Support Services","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SSS_setting_removeSupportOnVehicleDeletion","CHECKBOX",
	["Remove support on vehicle deletion","If disabled, any physical support vehicles capable of respawning will simply respawn"],
	["Simplex Support Services","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SSS_setting_deleteVehicleOnEntityRemoval","CHECKBOX",
	["Delete vehicle on entity removal","When a support entity is deleted/removed, its physical vehicle will be deleted"],
	["Simplex Support Services","Core"],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SSS_setting_cleanupCrew","CHECKBOX",
	["Delete old vehicle crew on respawn","When a vehicle is no longer usable, the crew will de-spawn instead of leaving the vehicle"],
	["Simplex Support Services","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SSS_setting_resetVehicleOnRTB","CHECKBOX",
	["Reset vehicle on RTB","When a vehicle arrives back at base, it is repaired, fuel is refilled, and ammo is restored."],
	["Simplex Support Services","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SSS_setting_restoreCrewOnRTB","CHECKBOX",
	["Restore vehicle crew on RTB","Restores health to all crew and revives any dead crew when a vehicle returns to base"],
	["Simplex Support Services","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SSS_setting_adminFullAccess","CHECKBOX",
	["Give admins access to all supports","Admins will be able to use every support available, even if services aren't shown/enabled"],
	["Simplex Support Services","Admin"],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

["SSS_setting_adminLimitSide","CHECKBOX",
	["Limit admin access to side","Limit the admin access to the current side of the admin"],
	["Simplex Support Services","Admin"],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

// Master array
SSS_entities = [];

// Zeus EH
["ModuleCurator_F","init",{
	params ["_zeus"];

	_zeus addEventHandler ["CuratorWaypointDeleted",{
		params ["_zeus","_group"];

		if (_group getVariable ["SSS_protectWaypoints",false]) then {
			private _vehicle = vehicle leader _group;
			private _entity = _vehicle getVariable ["SSS_parentEntity",objNull];

			if (isNull _entity) exitWith {};

			SSS_ERROR("Support vehicle waypoint was deleted!");

			switch (_entity getVariable "SSS_supportType") do {
				case "CASHelicopter";
				case "transportHelicopter";
				case "transportLandVehicle";
				case "transportMaritime";
				case "transportPlane";
				case "transportVTOL" : {
					[_entity,false] call EFUNC(common,updateMarker);
					INTERRUPT(_entity,_vehicle);
				};

				default {
					_vehicle setVariable ["SSS_WPDone",true,true];
				};
			};
		};
	}];
}] call CBA_fnc_addClassEventHandler;

// 'show' variables
{
	if (isNil _x) then {
		missionNamespace setVariable [_x,true];
	};
} forEach [
	"SSS_showArtillery",
	"SSS_showCAS",
	"SSS_showTransport",
	"SSS_showCASDrones",
	"SSS_showCASGunships",
	"SSS_showCASHelicopters",
	"SSS_showCASPlanes",
	"SSS_showTransportHelicopters",
	"SSS_showTransportLandVehicles",
	"SSS_showTransportMaritime",
	"SSS_showTransportPlanes",
	"SSS_showTransportVTOLs"
];

ADDON = true;
