#include "\x\cba\addons\main\script_macros_common.hpp"

#define SSS_LOG(MESSAGE) 										private _logMessage = format ["SSS %1",MESSAGE]; diag_log _logMessage; systemChat _logMessage;
#define SSS_ERROR(MESSAGE) 										SSS_LOG(FORMAT_1("Error: %1",MESSAGE))
#define SSS_ERROR_1(MESSAGE,ARG1) 								SSS_ERROR(FORMAT_1(MESSAGE,ARG1))
#define SSS_ERROR_2(MESSAGE,ARG1,ARG2) 							SSS_ERROR(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SSS_ERROR_3(MESSAGE,ARG1,ARG2,ARG3) 					SSS_ERROR(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SSS_ERROR_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 				SSS_ERROR(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SSS_ERROR_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			SSS_ERROR(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define SSS_WARNING(MESSAGE) 									SSS_LOG(FORMAT_1("Warning: %1",MESSAGE))
#define SSS_WARNING_1(MESSAGE,ARG1) 							SSS_ERROR(FORMAT_1(MESSAGE,ARG1))
#define SSS_WARNING_2(MESSAGE,ARG1,ARG2) 						SSS_ERROR(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SSS_WARNING_3(MESSAGE,ARG1,ARG2,ARG3) 					SSS_ERROR(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SSS_WARNING_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 				SSS_ERROR(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SSS_WARNING_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 		SSS_ERROR(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))

#define NOTIFY_LOCAL(VEH,MESSAGE) 								[VEH,MESSAGE] call SSS_fnc_notify;
#define NOTIFY_LOCAL_1(VEH,MESSAGE,ARG1) 					 	NOTIFY_LOCAL(VEH,FORMAT_1(MESSAGE,ARG1))
#define NOTIFY_LOCAL_2(VEH,MESSAGE,ARG1,ARG2) 			 		NOTIFY_LOCAL(VEH,FORMAT_2(MESSAGE,ARG1,ARG2))
#define NOTIFY_LOCAL_3(VEH,MESSAGE,ARG1,ARG2,ARG3) 		 		NOTIFY_LOCAL(VEH,FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define NOTIFY_LOCAL_4(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4) 		NOTIFY_LOCAL(VEH,FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define NOTIFY_LOCAL_5(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 	NOTIFY_LOCAL(VEH,FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define NOTIFY(VEH,MESSAGE) 									[VEH,MESSAGE] remoteExecCall ["SSS_fnc_notify",0];
#define NOTIFY_1(VEH,MESSAGE,ARG1) 								NOTIFY(VEH,FORMAT_1(MESSAGE,ARG1))
#define NOTIFY_2(VEH,MESSAGE,ARG1,ARG2) 						NOTIFY(VEH,FORMAT_2(MESSAGE,ARG1,ARG2))
#define NOTIFY_3(VEH,MESSAGE,ARG1,ARG2,ARG3) 					NOTIFY(VEH,FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define NOTIFY_4(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4) 				NOTIFY(VEH,FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define NOTIFY_5(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			NOTIFY(VEH,FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))

#define ZEUS_MESSAGE(MESSAGE) [objNull,MESSAGE] call BIS_fnc_showCuratorFeedbackMessage;
#define ZEUS_ERROR(MESSAGE) ZEUS_MESSAGE(MESSAGE) playSound "SSS_failure";

#define ICON_SUPPORT_SERVICES "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"
#define ICON_ARTILLERY "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\artillery_ca.paa"
#define ICON_CAS "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa"
#define ICON_TRANSPORT "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa"

#define ICON_CARGO "SSS\ui\icons\cargo.paa"
#define ICON_CARGO_YELLOW "SSS\ui\icons\cargo_yellow.paa"
#define ICON_DRONE "SSS\ui\icons\drone.paa"
#define ICON_DRONE_GREEN "SSS\ui\icons\drone_green.paa"
#define ICON_DRONE_YELLOW "SSS\ui\icons\drone_yellow.paa"
#define ICON_GUNSHIP "SSS\ui\icons\gunship.paa"
#define ICON_GUNSHIP_GREEN "SSS\ui\icons\gunship_green.paa"
#define ICON_GUNSHIP_YELLOW "SSS\ui\icons\gunship_yellow.paa"
#define ICON_HELI "SSS\ui\icons\heli.paa"
#define ICON_HELI_YELLOW "SSS\ui\icons\heli_yellow.paa"
#define ICON_MORTAR "SSS\ui\icons\mortar.paa"
#define ICON_MORTAR_YELLOW "SSS\ui\icons\mortar_yellow.paa"
#define ICON_PLANE "SSS\ui\icons\plane.paa"
#define ICON_PLANE_YELLOW "SSS\ui\icons\plane_yellow.paa"
#define ICON_SELF_PROPELLED "SSS\ui\icons\self_propelled.paa"
#define ICON_SELF_PROPELLED_YELLOW "SSS\ui\icons\self_propelled_yellow.paa"

#define ICON_HOME "SSS\ui\icons\home.paa"
#define ICON_MOVE "SSS\ui\icons\move.paa"
#define ICON_ROPE "SSS\ui\icons\rope.paa"
#define ICON_LAND "SSS\ui\icons\land.paa"
#define ICON_LAND_ENG_OFF "SSS\ui\icons\land_eng_off.paa"
#define ICON_LAND_GREEN "SSS\ui\icons\land_green.paa"
#define ICON_SEARCH_YELLOW "SSS\ui\icons\search_yellow.paa"
#define ICON_LOITER "SSS\ui\icons\loiter.paa"
#define ICON_GEAR "SSS\ui\icons\gear.paa"

#define ICON_MAP "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa"
#define ICON_SMOKE "SSS\ui\icons\smoke.paa"
#define ICON_STROBE "SSS\ui\icons\strobe.paa"
#define ICON_TARGET "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa"

#define RGBA_RED [0.9,0,0,1]
#define RGBA_ORANGE [0.85,0.4,0,1]
#define RGBA_YELLOW [0.85,0.85,0,1]
#define RGBA_GREEN [0,0.8,0,1]
#define RGBA_BLUE [0,0,1,1]
#define RGBA_PURPLE [0.75,0.15,0.75,1]

#define SET_VEHICLE_TRAITS(VEH,CLASS,VEH_SIDE,SERVICE,CALLSIGN) \
	VEH setVariable ["SSS_classname",CLASS,true]; \
	VEH setVariable ["SSS_side",VEH_SIDE,true]; \
	VEH setVariable ["SSS_service",SERVICE,true]; \
	VEH setVariable ["SSS_displayName",CALLSIGN,true];

#define SET_VEHICLE_TRAITS_PHYSICAL(VEH,GRP,BASE,VEH_SIDE,SERVICE,CALLSIGN,RESPAWN_TIME) \
	SET_VEHICLE_TRAITS(VEH,typeOf VEH,VEH_SIDE,SERVICE,CALLSIGN) \
	VEH setVariable ["SSS_base",BASE,true]; \
	VEH setVariable ["SSS_respawnTime",RESPAWN_TIME,true]; \
	VEH setDamage 0; \
	VEH setFuel 1; \
	VEH setVehicleAmmo 1; \
	VEH lockDriver true; \
	VEH allowFleeing 0; \
	{ \
		_x setSkill 1; \
		_x allowFleeing 0; \
		_x disableAI "SUPPRESSION"; \
		_x disableAI "COVER"; \
		_x disableAI "AUTOCOMBAT"; \
	} forEach units GRP; \
	GRP setBehaviour "CARELESS"; \
	GRP setCombatMode "YELLOW"; \
	GRP enableAttack true;

#define CREATE_TASK_MARKER(VEH,ICON,STRING,CALLSIGN) \
	private _marker = SSS_markers select (SSS_markers pushBack format ["SSS_%1",(count SSS_markers) + 1]); \
	publicVariable "SSS_markers"; \
	createMarker [_marker,[0,0,0]]; \
	_marker setMarkerShape "ICON"; \
	_marker setMarkerType ICON; \
	_marker setMarkerColor "ColorGrey"; \
	_marker setMarkerText format ["%1 - %2",STRING,CALLSIGN]; \
	_marker setMarkerAlpha 0; \
	VEH setVariable ["SSS_marker",_marker,true];

#define ADD_SUPPORT_VEHICLE(VEH,VEH_SIDE,SERVICE) \
	private _serviceString = format ["SSS_%1_%2",SERVICE,VEH_SIDE]; \
	private _serviceArray = missionNamespace getVariable [_serviceString,[]]; \
	_serviceArray pushBackUnique VEH; \
	missionNamespace setVariable [_serviceString,[_serviceArray,true,{_this getVariable "SSS_displayName"}] call SSS_fnc_sortBy,true]; \
	VEH addEventHandler ["Deleted",{_this call SSS_fnc_remove;}]; \
	NOTIFY(VEH,"New support ready for requests")

#define BEGIN_ORDER(VEH,POS,MESSAGE) \
	VEH setVariable ["SSS_onTask",true]; \
	VEH setVariable ["SSS_awayFromBase",true,true]; \
	[VEH,true,POS] call SSS_fnc_updateMarker; \
	NOTIFY(VEH,MESSAGE)

#define END_ORDER(VEH,MESSAGE) \
	VEH setVariable ["SSS_onTask",false]; \
	[VEH,false] call SSS_fnc_updateMarker; \
	NOTIFY(VEH,MESSAGE)

#define WP_DONE ["true","(vehicle this) setVariable ['SSS_WPDone',true];"]
#define INTERRUPT(VEH) if (VEH getVariable "SSS_onTask") then {VEH setVariable ["SSS_interrupt",true];};
#define CANCEL_ORDER(VEH,TASK) \
	VEH setVariable ["SSS_interrupt",false]; \
	VEH setVariable ["SSS_onTask",false]; \
	VEH setVariable ["SSS_interruptedTask",TASK,true]; \
	[VEH,false] call SSS_fnc_updateMarker;

#define CANCEL_CONDITION !alive _vehicle || !alive driver _vehicle || {_vehicle getVariable "SSS_interrupt"}
#define WAIT_CONDITION_BASE params ["_vehicle"]; CANCEL_CONDITION
#define WAIT_CONDITION_WPDONE WAIT_CONDITION_BASE || _vehicle getVariable "SSS_WPDone"
#define WAIT_CONDITION_LAND WAIT_CONDITION_BASE || (getPos _vehicle) select 2 < 1

#define REQUEST_CANCELLED \
	titleText ["Request Cancelled","PLAIN",0.5]; \
	[{titleFadeOut 0.5;},[],1] call CBA_fnc_waitAndExecute;

#define PROPER_COOLDOWN(VEH) (VEH getVariable "SSS_cooldown") call SSS_fnc_properTime

