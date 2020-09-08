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

#define NOTIFY_LOCAL(ENTITY,MESSAGE) 								[ENTITY,MESSAGE] call EFUNC(common,notify)
#define NOTIFY_LOCAL_1(ENTITY,MESSAGE,ARG1) 					 	NOTIFY_LOCAL(ENTITY,FORMAT_1(MESSAGE,ARG1))
#define NOTIFY_LOCAL_2(ENTITY,MESSAGE,ARG1,ARG2) 			 		NOTIFY_LOCAL(ENTITY,FORMAT_2(MESSAGE,ARG1,ARG2))
#define NOTIFY_LOCAL_3(ENTITY,MESSAGE,ARG1,ARG2,ARG3) 		 		NOTIFY_LOCAL(ENTITY,FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define NOTIFY_LOCAL_4(ENTITY,MESSAGE,ARG1,ARG2,ARG3,ARG4) 			NOTIFY_LOCAL(ENTITY,FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define NOTIFY_LOCAL_5(ENTITY,MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 	NOTIFY_LOCAL(ENTITY,FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define NOTIFY(ENTITY,MESSAGE) 										[ENTITY,MESSAGE] remoteExecCall [QEFUNC(common,notify),0]
#define NOTIFY_1(ENTITY,MESSAGE,ARG1) 								NOTIFY(ENTITY,FORMAT_1(MESSAGE,ARG1))
#define NOTIFY_2(ENTITY,MESSAGE,ARG1,ARG2) 							NOTIFY(ENTITY,FORMAT_2(MESSAGE,ARG1,ARG2))
#define NOTIFY_3(ENTITY,MESSAGE,ARG1,ARG2,ARG3) 					NOTIFY(ENTITY,FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define NOTIFY_4(ENTITY,MESSAGE,ARG1,ARG2,ARG3,ARG4) 				NOTIFY(ENTITY,FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define NOTIFY_5(ENTITY,MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			NOTIFY(ENTITY,FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))

#define ZEUS_MESSAGE(MESSAGE) [objNull,MESSAGE] call BIS_fnc_showCuratorFeedbackMessage
#define ZEUS_ERROR(MESSAGE) \
	ZEUS_MESSAGE(MESSAGE); \
	playSound "SSS_failure"

#define ICON_ARTILLERY "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\artillery_ca.paa"
#define ICON_BOAT "z\SSS\addons\main\ui\icons\boat.paa"
#define ICON_BOAT_GREEN "z\SSS\addons\main\ui\icons\boat_green.paa"
#define ICON_BOAT_YELLOW "z\SSS\addons\main\ui\icons\boat_yellow.paa"
#define ICON_BOX "z\SSS\addons\main\ui\icons\box.paa"
#define ICON_CAR "z\SSS\addons\main\ui\icons\car.paa"
#define ICON_CAR_GREEN "z\SSS\addons\main\ui\icons\car_green.paa"
#define ICON_CAR_YELLOW "z\SSS\addons\main\ui\icons\car_yellow.paa"
#define ICON_CAS "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa"
#define ICON_CLOCKWISE "\A3\3DEN\Data\Attributes\LoiterDirection\cw_ca.paa"
#define ICON_COUNTER_CLOCKWISE "\A3\3DEN\Data\Attributes\LoiterDirection\ccw_ca.paa"
#define ICON_DRONE "z\SSS\addons\main\ui\icons\drone.paa"
#define ICON_DRONE_GREEN "z\SSS\addons\main\ui\icons\drone_green.paa"
#define ICON_DRONE_YELLOW "z\SSS\addons\main\ui\icons\drone_yellow.paa"
#define ICON_GEAR "z\SSS\addons\main\ui\icons\gear.paa"
#define ICON_GROUND_SUPPORT "z\SSS\addons\main\ui\icons\ground_support.paa"
#define ICON_GUNSHIP "z\SSS\addons\main\ui\icons\gunship.paa"
#define ICON_GUNSHIP_GREEN "z\SSS\addons\main\ui\icons\gunship_green.paa"
#define ICON_GUNSHIP_YELLOW "z\SSS\addons\main\ui\icons\gunship_yellow.paa"
#define ICON_HELI "z\SSS\addons\main\ui\icons\heli.paa"
#define ICON_HELI_GREEN "z\SSS\addons\main\ui\icons\heli_green.paa"
#define ICON_HELI_YELLOW "z\SSS\addons\main\ui\icons\heli_yellow.paa"
#define ICON_HOME "z\SSS\addons\main\ui\icons\home.paa"
#define ICON_LAND "z\SSS\addons\main\ui\icons\land.paa"
#define ICON_LAND_ENG_OFF "z\SSS\addons\main\ui\icons\land_eng_off.paa"
#define ICON_LAND_GREEN "z\SSS\addons\main\ui\icons\land_green.paa"
#define ICON_LOCK "z\SSS\addons\main\ui\icons\lock.paa"
#define ICON_LOITER "z\SSS\addons\main\ui\icons\loiter.paa"
#define ICON_MAP "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa"
#define ICON_MISSILE "z\SSS\addons\main\ui\icons\missile.paa"
#define ICON_MISSILE_GREEN "z\SSS\addons\main\ui\icons\missile_green.paa"
#define ICON_MISSILE_YELLOW "z\SSS\addons\main\ui\icons\missile_yellow.paa"
#define ICON_MORTAR "z\SSS\addons\main\ui\icons\mortar.paa"
#define ICON_MORTAR_YELLOW "z\SSS\addons\main\ui\icons\mortar_yellow.paa"
#define ICON_MOVE "z\SSS\addons\main\ui\icons\move.paa"
#define ICON_MOVE_ENG_OFF "z\SSS\addons\main\ui\icons\move_eng_off.paa"
#define ICON_PARACHUTE "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\supplydrop_ca.paa"
#define ICON_PLANE "z\SSS\addons\main\ui\icons\plane.paa"
#define ICON_PLANE_GREEN "z\SSS\addons\main\ui\icons\plane_green.paa"
#define ICON_PLANE_YELLOW "z\SSS\addons\main\ui\icons\plane_yellow.paa"
#define ICON_ROPE "z\SSS\addons\main\ui\icons\rope.paa"
#define ICON_SEARCH_YELLOW "z\SSS\addons\main\ui\icons\search_yellow.paa"
#define ICON_SELF_PROPELLED "z\SSS\addons\main\ui\icons\self_propelled.paa"
#define ICON_SELF_PROPELLED_YELLOW "z\SSS\addons\main\ui\icons\self_propelled_yellow.paa"
#define ICON_SITREP "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\intel_ca.paa"
#define ICON_SLINGLOAD "z\SSS\addons\main\ui\icons\slingLoad.paa"
#define ICON_SMOKE "z\SSS\addons\main\ui\icons\smoke.paa"
#define ICON_STOP_VEHICLE "z\SSS\addons\main\ui\icons\stop_vehicle.paa"
#define ICON_STROBE "z\SSS\addons\main\ui\icons\strobe.paa"
#define ICON_SUPPORT_SERVICES "z\SSS\addons\main\ui\icons\sss.paa"
#define ICON_TARGET "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa"
#define ICON_TRANSPORT "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa"
#define ICON_TRASH "\A3\3DEN\Data\cfg3den\history\deleteitems_ca.paa"
#define ICON_UNLOCK "z\SSS\addons\main\ui\icons\unlock.paa"
#define ICON_VTOL "z\SSS\addons\main\ui\icons\vtol.paa"
#define ICON_VTOL_GREEN "z\SSS\addons\main\ui\icons\vtol_green.paa"
#define ICON_VTOL_YELLOW "z\SSS\addons\main\ui\icons\vtol_yellow.paa"

#define HEX_YELLOW "#f5ca00"
#define HEX_GREEN "#20ca24"
#define RGBA_RED [0.9,0,0,1]
#define RGBA_ORANGE [0.85,0.4,0,1]
#define RGBA_YELLOW [0.85,0.85,0,1]
#define RGBA_GREEN [0,0.8,0,1]
#define RGBA_BLUE [0,0,1,1]
#define RGBA_PURPLE [0.75,0.15,0.75,1]

#define DEFAULT_ARTILLERY_COORDINATION_DISTANCE 100
#define DEFAULT_ARTILLERY_MAX_ROUNDS 10
#define DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT 500
#define DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY 30
#define DEFAULT_RESPAWN_TIME 60
#define DEFAULT_COOLDOWN_ARTILLERY_MIN 90
#define DEFAULT_COOLDOWN_ARTILLERY_ROUND 8
#define DEFAULT_COOLDOWN_DRONES 600
#define DEFAULT_COOLDOWN_GUNSHIPS 900
#define DEFAULT_COOLDOWN_LOGISTICS_AIRDROP 300
#define DEFAULT_COOLDOWN_PLANES 300
#define DEFAULT_LOITER_TIME_DRONES 300
#define DEFAULT_LOITER_TIME_GUNSHIPS 300

#define ADMIN_ACCESS_CONDITION SSS_setting_adminFullAccess && {serverCommandAvailable "#kick" || !isMultiplayer}
#define ACTION_DEFAULTS [0,0,0],4,[false,false,false,false,false]
#define PRIMARY_CREW(VEH) ((crew VEH) arrayIntersect (units group VEH))
#define WP_DONE ["true","(vehicle this) setVariable ['SSS_WPDone',true];"]
#define PROPER_TIME(SECONDS) SECONDS call EFUNC(common,properTime)
#define PROPER_COOLDOWN(ENTITY) PROPER_TIME(ENTITY getVariable "SSS_cooldown")

#define CREATE_TASK_MARKER(ENTITY,CALLSIGN,MARKER_ICON,STRING) [ENTITY,CALLSIGN,MARKER_ICON,STRING] call EFUNC(common,createMarker)
#define BASE_TRAITS(ENTITY,CLASSNAME,CALLSIGN,SUPPORT_SIDE,ICON,CUSTOM_INIT,SERVICE,SUPPORT_TYPE,ACCESS_ITEMS,ACCESS_CONDITION,REQUEST_CONDITION) \
	ENTITY setVariable ["SSS_classname",CLASSNAME,true]; \
	ENTITY setVariable ["SSS_callsign",CALLSIGN,true]; \
	ENTITY setVariable ["SSS_side",SUPPORT_SIDE,true]; \
	ENTITY setVariable ["SSS_icon",ICON,true]; \
	ENTITY setVariable ["SSS_iconYellow",[ICON,HEX_YELLOW],true]; \
	ENTITY setVariable ["SSS_iconGreen",[ICON,HEX_GREEN],true]; \
	ENTITY setVariable ["SSS_customInit",CUSTOM_INIT,true]; \
	ENTITY setVariable ["SSS_service",SERVICE,true]; \
	ENTITY setVariable ["SSS_supportType",SUPPORT_TYPE,true]; \
	ENTITY setVariable ["SSS_accessItems",ACCESS_ITEMS apply {toLower _x},true]; \
	ENTITY setVariable ["SSS_accessCondition",ACCESS_CONDITION,true]; \
	ENTITY setVariable ["SSS_requestCondition",REQUEST_CONDITION,true]

#define PHYSICAL_TRAITS(ENTITY,VEH,GRP,BASE,RESPAWN_TIME) \
	VEH setVariable ["SSS_parentEntity",ENTITY,true]; \
	ENTITY setVariable ["SSS_vehicle",VEH,true]; \
	ENTITY setVariable ["SSS_base",BASE,true]; \
	ENTITY setVariable ["SSS_baseDir",getDirVisual VEH,true]; \
	ENTITY setVariable ["SSS_respawnDir",getDir VEH,true]; \
	ENTITY setVariable ["SSS_respawnTime",RESPAWN_TIME,true]; \
	ENTITY setVariable ["SSS_respawning",false,true]; \
	GRP setVariable ["SSS_protectWaypoints",true,true]

#define BEGIN_ORDER(ENTITY,POS,MESSAGE) \
	ENTITY setVariable ["SSS_onTask",true,true]; \
	ENTITY setVariable ["SSS_awayFromBase",true,true]; \
	[ENTITY,true,POS] call EFUNC(common,updateMarker); \
	NOTIFY(ENTITY,MESSAGE)

#define END_ORDER(ENTITY,MESSAGE) \
	ENTITY setVariable ["SSS_onTask",false,true]; \
	[ENTITY,false] call EFUNC(common,updateMarker); \
	NOTIFY(ENTITY,MESSAGE)

#define CANCEL_ORDER(ENTITY) \
	ENTITY setVariable ["SSS_interrupt",false]; \
	ENTITY setVariable ["SSS_onTask",false,true]; \
	[ENTITY,false] call EFUNC(common,updateMarker)

#define INTERRUPT(ENTITY,VEH) \
	if (ENTITY getVariable "SSS_onTask") then { \
		ENTITY setVariable ["SSS_interrupt",true,true]; \
		[{ \
			params ["_entity","_vehicle"]; \
			!(_entity getVariable "SSS_onTask") || !local _vehicle || !alive _vehicle \
		},{},[ENTITY,VEH],8,{ \
			params ["_entity","_vehicle"]; \
			CANCEL_ORDER(_entity); \
			_vehicle doFollow _vehicle; \
			_vehicle land "NONE"; \
		}] call CBA_fnc_waitUntilAndExecute; \
	}

#define CANCEL_CONDITION isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle}}

#define WAIT_UNTIL_WPDONE params ["_entity","_vehicle"]; \
	isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || {_vehicle getVariable "SSS_WPDone"}}}

#define WAIT_UNTIL_LAND params ["_entity","_vehicle"]; \
	isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || {(getPos _vehicle) select 2 < 1}}}

#define WAIT_UNTIL_PLANE_LANDED params ["_entity","_vehicle"]; \
	isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || {(getPos _vehicle) select 2 < 1 && (vectorMagnitude velocityModelSpace _vehicle) < 10}}}

#define REQUEST_CANCELLED \
	titleText ["Request Cancelled","PLAIN",0.5]; \
	[{titleFadeOut 0.5},[],1] call CBA_fnc_waitAndExecute

#define PLANE_TAKEOFF(VEH) \
	private _worldCfg = configfile >> "CfgWorlds" >> worldName; \
	private _airportData = [[getArray (_worldCfg >> "ilsPosition"),getArray (_worldCfg >> "ilsTaxiIn"),getArray (_worldCfg >> "ilsDirection")]]; \
	private _secondaryData = "true" configClasses (_worldCfg >> "SecondaryAirports"); \
	 \
	if !(_secondaryData isEqualTo []) then { \
		_airportData append (_secondaryData apply { \
			private _cfg = _worldCfg >> "SecondaryAirports" >> configName _x; \
			[getArray (_cfg >> "ilsPosition"),getArray (_cfg >> "ilsTaxiIn"),getArray (_cfg >> "ilsDirection")] \
		}); \
	}; \
	 \
	_airportData = _airportData apply {[(_x select 0) distance2D _vehicle,_x]}; \
	_airportData sort true; \
	(_airportData select 0 select 1) params ["_position","_ilsTaxiIn","_ilsDirection"]; \
	 \
	if !(_ilsTaxiIn isEqualTo []) then { \
		_position = [_ilsTaxiIn select (count _ilsTaxiIn - 2),_ilsTaxiIn select (count _ilsTaxiIn - 1)]; \
	}; \
	 \
	_vehicle setDir (((_ilsDirection select 0) atan2 (_ilsDirection select 2)) - 180); \
	_vehicle setPos _position; \
	_vehicle setFuel 1; \
	_vehicle engineOn true

#define COMPILE_LOGISTICS_LISTS \
	private _listFnc = _entity getVariable "SSS_listFnc"; \
	private _list = []; \
	private _beautifiedList = []; \
	private _searchList = []; \
	private _cfgVehicles = configFile >> "CfgVehicles"; \
	{ \
		_x params [["_classname","",[""]],["_customName","",[""]],["_customIcon","",[""]],["_initFnc",{},[{}]]]; \
		private _cfg = _cfgVehicles >> _classname; \
		if (isClass _cfg) then { \
			private _text = if (_customName isEqualTo "") then { \
				getText (_cfg >> "displayName") \
			} else { \
				_customName \
			}; \
			private _icon = if (_customIcon isEqualTo "") then { \
				private _path = getText (_cfg >> "picture"); \
				if (_path == "picturething") then {_path = "";}; \
				_path \
			} else { \
				_customIcon \
			}; \
			_list pushBack [_classname,_text,_initFnc]; \
			_beautifiedList pushBack [[_text,_icon]]; \
			_searchList pushBack (toLower _text); \
		}; \
	} forEach ([] call _listFnc)

#define NOTIFY_LOCAL_NOT_READY_COOLDOWN(ENTITY) \
	private _string = [localize "STR_SSS_Main_MacroNotifyReadyColored",localize "STR_SSS_Main_MacroNotifyReady"] select SSS_setting_useChatNotifications; \
	NOTIFY_LOCAL_1(ENTITY,_string,PROPER_COOLDOWN(ENTITY))

#define NOTIFY_NOT_READY_COOLDOWN(ENTITY) \
	private _string = [localize "STR_SSS_Main_MacroNotifyReadyColored",localize "STR_SSS_Main_MacroNotifyReady"] select SSS_setting_useChatNotifications; \
	NOTIFY_1(ENTITY,_string,PROPER_COOLDOWN(ENTITY))

#define STR_TO_ARRAY_LOWER(STRING) (([STRING] call CBA_fnc_removeWhitespace) splitString ",") apply {toLower _x}

#define SHUP_UP_BUTTON_CODE { \
	params ["_entity"]; \
	private _vehicle = _entity getVariable "SSS_vehicle"; \
	{[_x,"NoVoice"] remoteExecCall ["setSpeaker",0]} forEach PRIMARY_CREW(_vehicle); \
	NOTIFY_LOCAL(_entity,localize "STR_SSS_Main_BeQuiet"); \
}
