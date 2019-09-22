#include "\x\cba\addons\main\script_macros_common.hpp"
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#ifdef DISABLE_COMPILE_CACHE
	#undef PREP
	#define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
	#undef PREP
	#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

// Custom macros

#define SSS_LOG(MESSAGE) \
	private _logMessage = format ["SSS - %1",MESSAGE]; \
	diag_log _logMessage;

#define SSS_LOG_FULL(MESSAGE) \
	private _logMessage = format ["SSS - %1",MESSAGE]; \
	diag_log _logMessage; \
	systemChat _logMessage

#define SSS_LOG_1(MESSAGE,ARG1) 								SSS_LOG(FORMAT_1(MESSAGE,ARG1))
#define SSS_LOG_2(MESSAGE,ARG1,ARG2) 							SSS_LOG(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SSS_LOG_3(MESSAGE,ARG1,ARG2,ARG3) 						SSS_LOG(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SSS_LOG_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 					SSS_LOG(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SSS_LOG_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			SSS_LOG(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define SSS_LOG_FULL_1(MESSAGE,ARG1) 							SSS_LOG_FULL(FORMAT_1(MESSAGE,ARG1))
#define SSS_LOG_FULL_2(MESSAGE,ARG1,ARG2) 						SSS_LOG_FULL(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SSS_LOG_FULL_3(MESSAGE,ARG1,ARG2,ARG3) 					SSS_LOG_FULL(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SSS_LOG_FULL_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 			SSS_LOG_FULL(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SSS_LOG_FULL_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 		SSS_LOG_FULL(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define SSS_ERROR(MESSAGE) 										SSS_LOG_FULL(FORMAT_1("Error: %1",MESSAGE))
#define SSS_ERROR_1(MESSAGE,ARG1) 								SSS_ERROR(FORMAT_1(MESSAGE,ARG1))
#define SSS_ERROR_2(MESSAGE,ARG1,ARG2) 							SSS_ERROR(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SSS_ERROR_3(MESSAGE,ARG1,ARG2,ARG3) 					SSS_ERROR(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SSS_ERROR_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 				SSS_ERROR(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SSS_ERROR_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			SSS_ERROR(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define SSS_WARNING(MESSAGE) 									SSS_LOG_FULL(FORMAT_1("Warning: %1",MESSAGE))
#define SSS_WARNING_1(MESSAGE,ARG1) 							SSS_ERROR(FORMAT_1(MESSAGE,ARG1))
#define SSS_WARNING_2(MESSAGE,ARG1,ARG2) 						SSS_ERROR(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SSS_WARNING_3(MESSAGE,ARG1,ARG2,ARG3) 					SSS_ERROR(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SSS_WARNING_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 				SSS_ERROR(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SSS_WARNING_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 		SSS_ERROR(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))

#define NOTIFY_LOCAL(VEH,MESSAGE) 								[VEH,MESSAGE] call FUNC(notify)
#define NOTIFY_LOCAL_1(VEH,MESSAGE,ARG1) 					 	NOTIFY_LOCAL(VEH,FORMAT_1(MESSAGE,ARG1))
#define NOTIFY_LOCAL_2(VEH,MESSAGE,ARG1,ARG2) 			 		NOTIFY_LOCAL(VEH,FORMAT_2(MESSAGE,ARG1,ARG2))
#define NOTIFY_LOCAL_3(VEH,MESSAGE,ARG1,ARG2,ARG3) 		 		NOTIFY_LOCAL(VEH,FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define NOTIFY_LOCAL_4(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4) 		NOTIFY_LOCAL(VEH,FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define NOTIFY_LOCAL_5(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 	NOTIFY_LOCAL(VEH,FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define NOTIFY(VEH,MESSAGE) 									[VEH,MESSAGE] remoteExecCall [QFUNC(notify),0]
#define NOTIFY_1(VEH,MESSAGE,ARG1) 								NOTIFY(VEH,FORMAT_1(MESSAGE,ARG1))
#define NOTIFY_2(VEH,MESSAGE,ARG1,ARG2) 						NOTIFY(VEH,FORMAT_2(MESSAGE,ARG1,ARG2))
#define NOTIFY_3(VEH,MESSAGE,ARG1,ARG2,ARG3) 					NOTIFY(VEH,FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define NOTIFY_4(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4) 				NOTIFY(VEH,FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define NOTIFY_5(VEH,MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			NOTIFY(VEH,FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))

#define ZEUS_MESSAGE(MESSAGE) [objNull,MESSAGE] call BIS_fnc_showCuratorFeedbackMessage
#define ZEUS_ERROR(MESSAGE) \
	ZEUS_MESSAGE(MESSAGE); \
	playSound "SSS_failure"

#define ICON_ARTILLERY "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\artillery_ca.paa"
#define ICON_ASSIGN_REQUESTERS "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa"
#define ICON_BOAT "z\SSS\addons\SSS\ui\icons\boat.paa"
#define ICON_BOAT_GREEN "z\SSS\addons\SSS\ui\icons\boat_green.paa"
#define ICON_BOAT_YELLOW "z\SSS\addons\SSS\ui\icons\boat_yellow.paa"
#define ICON_CAR "z\SSS\addons\SSS\ui\icons\car.paa"
#define ICON_CAR_GREEN "z\SSS\addons\SSS\ui\icons\car_green.paa"
#define ICON_CAR_YELLOW "z\SSS\addons\SSS\ui\icons\car_yellow.paa"
#define ICON_CAS "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa"
#define ICON_CLOCKWISE "\A3\3DEN\Data\Attributes\LoiterDirection\cw_ca.paa"
#define ICON_COUNTER_CLOCKWISE "\A3\3DEN\Data\Attributes\LoiterDirection\ccw_ca.paa"
#define ICON_DRONE "z\SSS\addons\SSS\ui\icons\drone.paa"
#define ICON_DRONE_GREEN "z\SSS\addons\SSS\ui\icons\drone_green.paa"
#define ICON_DRONE_YELLOW "z\SSS\addons\SSS\ui\icons\drone_yellow.paa"
#define ICON_GEAR "z\SSS\addons\SSS\ui\icons\gear.paa"
#define ICON_GROUND_SUPPORT "z\SSS\addons\SSS\ui\icons\ground_support.paa"
#define ICON_GUNSHIP "z\SSS\addons\SSS\ui\icons\gunship.paa"
#define ICON_GUNSHIP_GREEN "z\SSS\addons\SSS\ui\icons\gunship_green.paa"
#define ICON_GUNSHIP_YELLOW "z\SSS\addons\SSS\ui\icons\gunship_yellow.paa"
#define ICON_HELI "z\SSS\addons\SSS\ui\icons\heli.paa"
#define ICON_HELI_GREEN "z\SSS\addons\SSS\ui\icons\heli_green.paa"
#define ICON_HELI_YELLOW "z\SSS\addons\SSS\ui\icons\heli_yellow.paa"
#define ICON_HOME "z\SSS\addons\SSS\ui\icons\home.paa"
#define ICON_LAND "z\SSS\addons\SSS\ui\icons\land.paa"
#define ICON_LAND_ENG_OFF "z\SSS\addons\SSS\ui\icons\land_eng_off.paa"
#define ICON_LAND_GREEN "z\SSS\addons\SSS\ui\icons\land_green.paa"
#define ICON_LOITER "z\SSS\addons\SSS\ui\icons\loiter.paa"
#define ICON_MAP "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa"
#define ICON_MISSILE "z\SSS\addons\SSS\ui\icons\missile.paa"
#define ICON_MISSILE_GREEN "z\SSS\addons\SSS\ui\icons\missile_green.paa"
#define ICON_MISSILE_YELLOW "z\SSS\addons\SSS\ui\icons\missile_yellow.paa"
#define ICON_MORTAR "z\SSS\addons\SSS\ui\icons\mortar.paa"
#define ICON_MORTAR_YELLOW "z\SSS\addons\SSS\ui\icons\mortar_yellow.paa"
#define ICON_MOVE "z\SSS\addons\SSS\ui\icons\move.paa"
#define ICON_MOVE_ENG_OFF "z\SSS\addons\SSS\ui\icons\move_eng_off.paa"
#define ICON_PLANE "z\SSS\addons\SSS\ui\icons\plane.paa"
#define ICON_PLANE_YELLOW "z\SSS\addons\SSS\ui\icons\plane_yellow.paa"
#define ICON_ROPE "z\SSS\addons\SSS\ui\icons\rope.paa"
#define ICON_SEARCH_YELLOW "z\SSS\addons\SSS\ui\icons\search_yellow.paa"
#define ICON_SELF_PROPELLED "z\SSS\addons\SSS\ui\icons\self_propelled.paa"
#define ICON_SELF_PROPELLED_YELLOW "z\SSS\addons\SSS\ui\icons\self_propelled_yellow.paa"
#define ICON_SMOKE "z\SSS\addons\SSS\ui\icons\smoke.paa"
#define ICON_STROBE "z\SSS\addons\SSS\ui\icons\strobe.paa"
#define ICON_SUPPORT_SERVICES "z\SSS\addons\SSS\ui\icons\sss.paa"
#define ICON_TARGET "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa"
#define ICON_TRANSPORT "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa"
#define ICON_TRASH "\A3\3DEN\Data\cfg3den\history\deleteitems_ca.paa"

#define RGBA_RED [0.9,0,0,1]
#define RGBA_ORANGE [0.85,0.4,0,1]
#define RGBA_YELLOW [0.85,0.85,0,1]
#define RGBA_GREEN [0,0.8,0,1]
#define RGBA_BLUE [0,0,1,1]
#define RGBA_PURPLE [0.75,0.15,0.75,1]

#define SSS_DEFAULT_ARTILLERY_MAX_ROUNDS 10
#define SSS_DEFAULT_ARTILLERY_MAX_ROUNDS_STR "10"
#define SSS_DEFAULT_RESPAWN_TIME 60
#define SSS_DEFAULT_RESPAWN_TIME_STR "60"
#define SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN 90
#define SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN_STR "90"
#define SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND 8
#define SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND_STR "8"
#define SSS_DEFAULT_COOLDOWN_DRONES 600
#define SSS_DEFAULT_COOLDOWN_DRONES_STR "600"
#define SSS_DEFAULT_COOLDOWN_GUNSHIPS 900
#define SSS_DEFAULT_COOLDOWN_GUNSHIPS_STR "900"
#define SSS_DEFAULT_COOLDOWN_PLANES 300
#define SSS_DEFAULT_COOLDOWN_PLANES_STR "300"
#define SSS_DEFAULT_LOITER_TIME_DRONES 300
#define SSS_DEFAULT_LOITER_TIME_DRONES_STR "300"
#define SSS_DEFAULT_LOITER_TIME_GUNSHIPS 300
#define SSS_DEFAULT_LOITER_TIME_GUNSHIPS_STR "300"

#define ADMIN_ACCESS_CONDITION SSS_setting_adminFullAccess && {serverCommandAvailable "#kick" || !isMultiplayer}
#define ACTION_DEFAULTS [0,0,0],4,[false,false,false,false,false]

#define PRIMARY_CREW(VEH) ((crew VEH) arrayIntersect (units group VEH))

#define BASE_TRAITS(ENTITY,CLASSNAME,CALLSIGN,SUPPORT_SIDE,ICON,ICON_YELLOW,ICON_GREEN,SERVICE,SUPPORT_TYPE) \
	ENTITY setVariable ["SSS_classname",CLASSNAME,true]; \
	ENTITY setVariable ["SSS_callsign",CALLSIGN,true]; \
	ENTITY setVariable ["SSS_side",SUPPORT_SIDE,true]; \
	ENTITY setVariable ["SSS_icon",ICON,true]; \
	ENTITY setVariable ["SSS_iconYellow",ICON_YELLOW,true]; \
	ENTITY setVariable ["SSS_iconGreen",ICON_GREEN,true]; \
	ENTITY setVariable ["SSS_service",SERVICE,true]; \
	ENTITY setVariable ["SSS_supportType",SUPPORT_TYPE,true]

#define PHYSICAL_TRAITS(ENTITY,VEH,GRP,BASE,RESPAWN_TIME,CUSTOM_INIT) \
	VEH setVariable ["SSS_parentEntity",ENTITY,true]; \
	ENTITY setVariable ["SSS_vehicle",VEH,true]; \
	ENTITY setVariable ["SSS_base",BASE,true]; \
	ENTITY setVariable ["SSS_respawnDir",getDir VEH,true]; \
	ENTITY setVariable ["SSS_respawnTime",RESPAWN_TIME,true]; \
	ENTITY setVariable ["SSS_respawning",false,true]; \
	ENTITY setVariable ["SSS_customInit",CUSTOM_INIT,true]; \
	GRP setVariable ["SSS_protectWaypoints",true,true]

#define CREATE_TASK_MARKER(ENTITY,CALLSIGN,MARKER_ICON,STRING) \
	private _marker = createMarker [format ["SSS_%1_%2",ENTITY,CBA_missionTime],[0,0,0]]; \
	_marker setMarkerShape "ICON"; \
	_marker setMarkerType MARKER_ICON; \
	_marker setMarkerColor "ColorGrey"; \
	_marker setMarkerText format ["%1 - %2",STRING,CALLSIGN]; \
	_marker setMarkerAlpha 0; \
	ENTITY setVariable ["SSS_marker",_marker,true]

#define BEGIN_ORDER(ENTITY,POS,MESSAGE) \
	ENTITY setVariable ["SSS_onTask",true,true]; \
	ENTITY setVariable ["SSS_awayFromBase",true,true]; \
	[ENTITY,true,POS] call FUNC(updateMarker); \
	NOTIFY(ENTITY,MESSAGE)

#define END_ORDER(ENTITY,MESSAGE) \
	ENTITY setVariable ["SSS_onTask",false,true]; \
	[ENTITY,false] call FUNC(updateMarker); \
	NOTIFY(ENTITY,MESSAGE)

#define WP_DONE ["true","(vehicle this) setVariable ['SSS_WPDone',true,true];"]

#define CANCEL_ORDER(ENTITY,TASK) \
	ENTITY setVariable ["SSS_interrupt",false]; \
	ENTITY setVariable ["SSS_onTask",false,true]; \
	ENTITY setVariable ["SSS_interruptedTask",TASK,true]; \
	[ENTITY,false] call FUNC(updateMarker)

#define INTERRUPT(ENTITY,VEH) \
	if (ENTITY getVariable "SSS_onTask") then { \
		ENTITY setVariable ["SSS_interrupt",true,true]; \
		[{ \
			params ["_entity","_vehicle"]; \
			!(_entity getVariable "SSS_onTask") || !local _vehicle || !alive _vehicle \
		},{},[ENTITY,VEH],8,{ \
			params ["_entity","_vehicle"]; \
			CANCEL_ORDER(_entity,""); \
			_vehicle doFollow _vehicle; \
			_vehicle land "NONE"; \
		}] call CBA_fnc_waitUntilAndExecute; \
	}

#define CANCEL_CONDITION isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle}}

#define WAIT_UNTIL_WPDONE params ["_entity","_vehicle"]; \
	isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || _vehicle getVariable "SSS_WPDone"}}

#define WAIT_UNTIL_LAND params ["_entity","_vehicle"]; \
	isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || (getPos _vehicle) select 2 < 1}}

#define REQUEST_CANCELLED \
	titleText ["Request Cancelled","PLAIN",0.5]; \
	[{titleFadeOut 0.5;},[],1] call CBA_fnc_waitAndExecute

#define PROPER_TIME(SECONDS) SECONDS call FUNC(properTime)
#define PROPER_COOLDOWN(ENTITY) PROPER_TIME(ENTITY getVariable "SSS_cooldown")
