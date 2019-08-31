#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
ADDON = true;

SSS_markers = [];

// Service enabling
SSS_artilleryEnabled = true;
SSS_CASEnabled = true;
SSS_CASDronesEnabled = true;
SSS_CASGunshipsEnabled = true;
SSS_CASHelisEnabled = true;
SSS_CASPlanesEnabled = true;
SSS_transportEnabled = true;

//-----------------------------------------------------------------------------------------------//

["SSS_setting_GiveUAVTerminal","CHECKBOX",
	["Give UAV Terminal on drone request","Gives CAS Drone requesters a UAV terminal if they don't have one"],
	"Simplex Support Services",
	true, // _valueInfo
	true, // _isGlobal
	{},
	false // _needRestart
] call CBA_fnc_addSetting;

["SSS_setting_useChatNotifications","CHECKBOX",
	["Use chat notifications","Disables custom notification system"],
	"Simplex Support Services",
	false, // _valueInfo
	false, // _isGlobal
	{},
	false // _needRestart
] call CBA_fnc_addSetting;

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

// Transport vehicle actions
["SSS_supportVehicleAdded",{
	params ["_vehicle"];

	if (!alive _vehicle || {(_vehicle getVariable "SSS_service") != "transport"}) exitWith {};

	private _transportAction = ["SSS_transport","Transport",ICON_TRANSPORT,{},{
		alive (_this # 0) && alive driver (_this # 0)
	},{
		_this call EFUNC(service,childActionsTransport);
	},_vehicle] call ace_interact_menu_fnc_createAction;

	[_vehicle,1,["ACE_SelfActions"],_transportAction] call ace_interact_menu_fnc_addActionToObject;
	[_vehicle,0,["ACE_MainActions"],_transportAction] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;

["SSS_supportVehicleRemoved",{
	params ["_vehicle"];

	if (!alive _vehicle) exitWith {};

	[_vehicle,1,["ACE_SelfActions","SSS_transport"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_vehicle,0,["ACE_MainActions","SSS_transport"]] call ace_interact_menu_fnc_removeActionFromObject;
}] call CBA_fnc_addEventHandler;
