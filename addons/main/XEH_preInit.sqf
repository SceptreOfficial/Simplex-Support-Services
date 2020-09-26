#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

// Admin
[
	"SSS_setting_adminFullAccess",
	"CHECKBOX",
	[LSTRING(Setting_AdminFullAccess_DisplayName), LSTRING(Setting_AdminFullAccess_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryAdmin)],
	false, // _valueInfo
	false, // _isGlobal
	{}, //_script
	false // _needRestart
] call CBA_fnc_addSetting;

[
	"SSS_setting_adminLimitSide",
	"CHECKBOX",
	[LSTRING(Setting_AdminLimitSide_DisplayName), LSTRING(Setting_AdminLimitSide_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryAdmin)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

// Core
[
	"SSS_setting_GiveUAVTerminal",
	"CHECKBOX",
	[LSTRING(Setting_GiveUAVTerminal_DisplayName), LSTRING(Setting_GiveUAVTerminal_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_directActionRequirement",
	"CHECKBOX",
	[LSTRING(Setting_DirectActionRequirement_DisplayName), LSTRING(Setting_DirectActionRequirement_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryCore)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_removeSupportOnVehicleDeletion",
	"CHECKBOX",
	[LSTRING(Setting_RemoveSupportOnVehicleDeletion_DisplayName), LSTRING(Setting_RemoveSupportOnVehicleDeletion_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_deleteVehicleOnEntityRemoval",
	"CHECKBOX",
	[LSTRING(Setting_DeleteVehicleOnEntityRemoval_DisplayName), LSTRING(Setting_DeleteVehicleOnEntityRemoval_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryCore)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_cleanupCrew",
	"CHECKBOX",
	[LSTRING(Setting_CleanupCrew_DisplayName), LSTRING(Setting_CleanupCrew_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_resetVehicleOnRTB",
	"CHECKBOX",
	[LSTRING(Setting_ResetVehicleOnRTB_DisplayName), LSTRING(Setting_ResetVehicleOnRTB_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_restoreCrewOnRTB",
	"CHECKBOX",
	[LSTRING(Setting_RestoreCrewOnRTB_DisplayName), LSTRING(Setting_RestoreCrewOnRTB_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

// Sling Loading
[
	"SSS_setting_slingLoadWhitelist",
	"EDITBOX",
	[LSTRING(Setting_SlingLoadWhitelist_DisplayName), LSTRING(Setting_SlingLoadWhitelist_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategorySlingLoading)],
	"",
	true,
	{missionNamespace setVariable["SSS_slingLoadWhitelist",(([_this] call CBA_fnc_removeWhitespace) splitString ",") apply {toLower _x},true]},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_slingLoadSearchRadius",
	"SLIDER",
	[LSTRING(Setting_SlingLoadSearchRadius_DisplayName), LSTRING(Setting_SlingLoadSearchRadius_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategorySlingLoading)],
	[10,200,100,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

// Milsim mode
[
	"SSS_setting_milsimModeArtillery",
	"CHECKBOX",
	[LSTRING(Setting_MilsimModeArtillery_DisplayName), LSTRING(Setting_MilsimModeArtillery_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryMilsimMode)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_milsimModeCAS",
	"CHECKBOX",
	[LSTRING(Setting_MilsimModeCAS_DisplayName), LSTRING(Setting_MilsimModeCAS_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryMilsimMode)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_milsimModeTransport",
	"CHECKBOX",
	[LSTRING(Setting_MilsimModeTransport_DisplayName), LSTRING(Setting_MilsimModeTransport_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryMilsimMode)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_milsimModeLogistics",
	"CHECKBOX",
	[LSTRING(Setting_MilsimModeLogistics_DisplayName), LSTRING(Setting_MilsimModeLogistics_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryMilsimMode)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	"SSS_setting_milsimHideMarkers",
	"CHECKBOX",
	[LSTRING(Setting_MilsimHideMarkers_DisplayName), LSTRING(Setting_MilsimHideMarkers_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryMilsimMode)],
	false,
	true,
	{},
	true
] call CBA_fnc_addSetting;

// Personal
[
	"SSS_setting_useChatNotifications",
	"CHECKBOX",
	[LSTRING(Setting_UseChatNotifications_DisplayName), LSTRING(Setting_UseChatNotifications_Description)],
	[LSTRING(SimplexSupportServices),LSTRING(Setting_CategoryPersonal)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

// Master array
SSS_entities = [];

// Transport action
["SSS_commissioned",{
	params ["_vehicle"];

	private _entity = _vehicle getVariable ["SSS_parentEntity",objNull];

	if (!alive _vehicle || isNull _entity || {(_entity getVariable "SSS_service") != "Transport"}) exitWith {};

	private _action = ["SSS_transport","Transport",ICON_TRANSPORT,{},
		EFUNC(interaction,transportVehicleActionCondition),
		EFUNC(interaction,transportVehicleActionChildren)
	] call ace_interact_menu_fnc_createAction;

	[_vehicle,0,["ACE_MainActions"],_action] call ace_interact_menu_fnc_addActionToObject;
	[_vehicle,1,["ACE_SelfActions"],_action] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;

["SSS_logisticsStationBooth",{
	params ["_entity","_booth"];

	if (isNull _entity) exitWith {};

	private _assignedStations = _booth getVariable ["SSS_assignedStations",[]];
	private _index = _assignedStations pushBack _entity;
	_booth setVariable ["SSS_assignedStations",_assignedStations];

	private _action = ["SSS_logisticsStations:" + str _index,_entity getVariable "SSS_callsign",ICON_BOX,{
		_this call EFUNC(support,requestLogisticsStation)
	},{
		params ["_target","_player","_entity"];

		if (SSS_setting_directActionRequirement && {!(_entity in ([_player,"logistics"] call EFUNC(interaction,availableEntities)))}) exitWith {false};
		
		!isNull _entity && SSS_showLogisticsStations && {(_entity getVariable "SSS_side") == side group _player}
	},{},_entity] call ace_interact_menu_fnc_createAction;

	[_booth,0,["ACE_MainActions"],_action] call ace_interact_menu_fnc_addActionToObject;
	[_booth,1,["ACE_SelfActions"],_action] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;

// Zeus handling
["ModuleCurator_F","init",{
	[_this # 0,"CuratorWaypointDeleted",{
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
	}] call CBA_fnc_addBISEventHandler;
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
	"SSS_showTransportVTOLs",
	"SSS_showLogistics",
	"SSS_showLogisticsAirdrops",
	"SSS_showLogisticsStations"
];

ADDON = true;
