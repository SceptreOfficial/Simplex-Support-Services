#include "\x\cba\addons\main\script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#ifdef DISABLE_COMPILE_CACHE
	#undef PREP
	#define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
	#undef PREP
	#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////

// Prefix variables
#define PVAR(VAR) DOUBLES(PREFIX,VAR)
#define QPVAR(VAR) QUOTE(PVAR(VAR))
#define QQPVAR(VAR) QUOTE(QPVAR(VAR))
#define OPTION(VAR) PVAR(option)##VAR
#define QOPTION(VAR) QUOTE(OPTION(VAR))

// Logging
#define LOG_PREFIX QUOTE(ADDON) + ": " + ((__FILE__ regexFind ["[a-z_]+\.sqf"]) select 0 select 0 select 0 regexReplace ["\.sqf",""]) + ": "
#define LOG_MESSAGE(MSG) (LOG_PREFIX + MSG) call EFUNC(common,log)

#define LOG_ERROR(MSG) 							LOG_MESSAGE("Error: " + MSG)
#define LOG_ERROR_1(MSG,N1) 					LOG_ERROR(FORMAT_1(MSG,N1))
#define LOG_ERROR_2(MSG,N1,N2) 					LOG_ERROR(FORMAT_2(MSG,N1,N2))
#define LOG_ERROR_3(MSG,N1,N2,N3) 				LOG_ERROR(FORMAT_3(MSG,N1,N2,N3))
#define LOG_ERROR_4(MSG,N1,N2,N3,N4) 			LOG_ERROR(FORMAT_4(MSG,N1,N2,N3,N4))
#define LOG_ERROR_5(MSG,N1,N2,N3,N4,N5) 		LOG_ERROR(FORMAT_5(MSG,N1,N2,N3,N4,N5))

#define LOG_WARNING(MSG) 						LOG_MESSAGE("Warning: " + MSG)
#define LOG_WARNING_1(MSG,N1) 					LOG_WARNING(FORMAT_1(MSG,N1))
#define LOG_WARNING_2(MSG,N1,N2) 				LOG_WARNING(FORMAT_2(MSG,N1,N2))
#define LOG_WARNING_3(MSG,N1,N2,N3) 			LOG_WARNING(FORMAT_3(MSG,N1,N2,N3))
#define LOG_WARNING_4(MSG,N1,N2,N3,N4) 			LOG_WARNING(FORMAT_4(MSG,N1,N2,N3,N4))
#define LOG_WARNING_5(MSG,N1,N2,N3,N4,N5) 		LOG_WARNING(FORMAT_5(MSG,N1,N2,N3,N4,N5))

#define DEBUG(MSG) 								if (OPTION(debug)) then {LOG_MESSAGE(MSG)}
#define DEBUG_1(MSG,A1) 						DEBUG(FORMAT_1(MSG,A1))
#define DEBUG_2(MSG,ARG1,ARG2) 					DEBUG(FORMAT_2(MSG,ARG1,ARG2))
#define DEBUG_3(MSG,ARG1,ARG2,ARG3) 			DEBUG(FORMAT_3(MSG,ARG1,ARG2,ARG3))
#define DEBUG_4(MSG,ARG1,ARG2,ARG3,ARG4) 		DEBUG(FORMAT_4(MSG,ARG1,ARG2,ARG3,ARG4))
#define DEBUG_5(MSG,ARG1,ARG2,ARG3,ARG4,ARG5) 	DEBUG(FORMAT_5(MSG,ARG1,ARG2,ARG3,ARG4,ARG5))

// Notifications
#define ZEUS_MESSAGE(MSG) [objNull,MSG] call BIS_fnc_showCuratorFeedbackMessage
#define ZEUS_ERROR(MSG) ZEUS_MESSAGE(MSG); playSound QPVAR(failure)

#define NOTIFY(ENTITY,MSG) 							[QEGVAR(common,notify),[ENTITY,MSG]] call CBA_fnc_globalEvent
#define NOTIFY_1(ENTITY,MSG,N1) 					[QEGVAR(common,notify),[ENTITY,MSG,[N1]]] call CBA_fnc_globalEvent
#define NOTIFY_2(ENTITY,MSG,N1,N2) 					[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2]]] call CBA_fnc_globalEvent
#define NOTIFY_3(ENTITY,MSG,N1,N2,N3) 				[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2,N3]]] call CBA_fnc_globalEvent
#define NOTIFY_4(ENTITY,MSG,N1,N2,N3,N4) 			[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2,N3,N4]]] call CBA_fnc_globalEvent
#define NOTIFY_5(ENTITY,MSG,N1,N2,N3,N4,N5) 		[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2,N3,N4,N5]]] call CBA_fnc_globalEvent
#define NOTIFY_LOCAL(ENTITY,MSG) 					[QEGVAR(common,notify),[ENTITY,MSG]] call CBA_fnc_localEvent
#define NOTIFY_LOCAL_1(ENTITY,MSG,N1) 				[QEGVAR(common,notify),[ENTITY,MSG,[N1]]] call CBA_fnc_localEvent
#define NOTIFY_LOCAL_2(ENTITY,MSG,N1,N2) 			[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2]]] call CBA_fnc_localEvent
#define NOTIFY_LOCAL_3(ENTITY,MSG,N1,N2,N3) 		[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2,N3]]] call CBA_fnc_localEvent
#define NOTIFY_LOCAL_4(ENTITY,MSG,N1,N2,N3,N4) 		[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2,N3,N4]]] call CBA_fnc_localEvent
#define NOTIFY_LOCAL_5(ENTITY,MSG,N1,N2,N3,N4,N5) 	[QEGVAR(common,notify),[ENTITY,MSG,[N1,N2,N3,N4,N5]]] call CBA_fnc_localEvent

// Icons
#define ICON_ARROW_LEFT QPATHTOEF(common,icons\arrow_left.paa)
#define ICON_ARROW_RIGHT QPATHTOEF(common,icons\arrow_right.paa)
#define ICON_BOAT QPATHTOEF(common,icons\boat.paa)
#define ICON_BOX QPATHTOEF(common,icons\box.paa)
#define ICON_CAR QPATHTOEF(common,icons\car.paa)
#define ICON_CAS "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa"
#define ICON_CAUTION "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\danger_ca.paa"
#define ICON_CHECKED "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa"
#define ICON_CHECKED2 "a3\3DEN\Data\Controls\ctrlCheckbox\textureChecked_ca.paa"
#define ICON_CLOCKWISE "\A3\3DEN\Data\Attributes\LoiterDirection\cw_ca.paa"
#define ICON_COMPOSITION "\a3\3DEN\Data\Displays\Display3DEN\panelright\side_custom_ca.paa"
#define ICON_COUNTER_CLOCKWISE "\A3\3DEN\Data\Attributes\LoiterDirection\ccw_ca.paa"
#define ICON_DESTROY "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\destroy_ca.paa"
#define ICON_DRONE QPATHTOEF(common,icons\drone.paa)
#define ICON_EAST "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_east_ca.paa"
#define ICON_FOLLOW "\a3\3DEN\Data\Cfgwaypoints\follow_ca.paa"
#define ICON_GEAR QPATHTOEF(common,icons\gear.paa)
#define ICON_GEAR2 "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa"
#define ICON_GET_OUT "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\getout_ca.paa"
#define ICON_GROUND_SUPPORT QPATHTOEF(common,icons\ground_support.paa)
#define ICON_GROUP "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa"
#define ICON_GUER "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_guer_ca.paa"
#define ICON_GUNSHIP QPATHTOEF(common,icons\gunship.paa)
#define ICON_HASH QPATHTOEF(common,icons\hash.paa)
#define ICON_HELI QPATHTOEF(common,icons\heli.paa)
#define ICON_HELOCAST QPATHTOEF(common,icons\helocast.paa)
#define ICON_HOME QPATHTOEF(common,icons\home.paa)
#define ICON_HOME_PATHING QPATHTOEF(common,icons\home_pathing.paa)
#define ICON_HOWITZER QPATHTOEF(common,icons\howitzer.paa)
#define ICON_INFINITE QPATHTOEF(common,icons\infinite.paa)
#define ICON_INTEL "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\intel_ca.paa"
#define ICON_KILL "\a3\Ui_f\data\IGUI\Cfg\simpleTasks\types\kill_ca.paa"
#define ICON_LAND QPATHTOEF(common,icons\land.paa)
#define ICON_LAND_ENG_OFF QPATHTOEF(common,icons\land_eng_off.paa)
#define ICON_LASER "\a3\ui_f\data\igui\rsccustominfo\sensors\targets\lasertarget_ca.paa"
#define ICON_LINK QPATHTOEF(common,icons\link.paa)
#define ICON_LOCK QPATHTOEF(common,icons\lock.paa)
#define ICON_LOITER QPATHTOEF(common,icons\loiter.paa)
#define ICON_MAP "\a3\Ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa"
#define ICON_MINUS QPATHTOEF(common,icons\minus.paa)
#define ICON_MISSILE QPATHTOEF(common,icons\missile.paa)
#define ICON_MORTAR QPATHTOEF(common,icons\mortar.paa)
#define ICON_HOVER QPATHTOEF(common,icons\hover.paa)
#define ICON_MOVE "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\move_ca.paa"
#define ICON_MOVE_ENG_OFF QPATHTOEF(common,icons\move_eng_off.paa)
#define ICON_MRLS QPATHTOEF(common,icons\mrls.paa)
#define ICON_MRLS_TRUCK QPATHTOEF(common,icons\mrls_truck.paa)
#define ICON_PARACHUTE "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\supplydrop_ca.paa"
#define ICON_PLANE QPATHTOEF(common,icons\plane.paa)
#define ICON_PLUS QPATHTOEF(common,icons\plus.paa)
#define ICON_RESUPPLY "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa"
#define ICON_ROPE QPATHTOEF(common,icons\rope.paa)
#define ICON_SEARCH "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\search_ca.paa"
#define ICON_SELF_PROPELLED QPATHTOEF(common,icons\self_propelled.paa)
#define ICON_SLINGLOAD QPATHTOEF(common,icons\slingLoad.paa)
#define ICON_SLINGLOAD_DROPOFF QPATHTOEF(common,icons\slingload_dropoff.paa)
#define ICON_SLINGLOAD_PICKUP QPATHTOEF(common,icons\slingload_pickup.paa)
#define ICON_SMOKE_GRENADE QPATHTOEF(common,icons\smoke_grenade.paa)
#define ICON_SORT_DOWN "\a3\3DEN\Data\Displays\Display3DENSave\sort_down_ca.paa"
#define ICON_SORT_NONE "\a3\3DEN\Data\Displays\Display3DENSave\sort_none_ca.paa"
#define ICON_SORT_UP "\a3\3DEN\Data\Displays\Display3DENSave\sort_up_ca.paa"
#define ICON_SSS QPATHTOEF(common,icons\sss.paa)
#define ICON_STOP_VEHICLE QPATHTOEF(common,icons\stop_vehicle.paa)
#define ICON_STROBE QPATHTOEF(common,icons\strobe.paa)
#define ICON_TARGET QPATHTOEF(common,icons\target.paa)
#define ICON_TARGET_EYE QPATHTOEF(common,icons\target_eye.paa)
#define ICON_TERMINAL QPATHTOEF(common,icons\terminal.paa)
#define ICON_TRASH "\A3\3DEN\Data\cfg3den\history\deleteitems_ca.paa"
#define ICON_TRIGGER_INTERVAL QPATHTOEF(common,icons\trigger_interval.paa)
#define ICON_UNCHECKED "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa"
#define ICON_UNCHECKED2 "a3\3DEN\Data\Controls\ctrlCheckbox\textureUnchecked_ca.paa"
#define ICON_UNLOCK QPATHTOEF(common,icons\unlock.paa)
#define ICON_VTOL QPATHTOEF(common,icons\vtol.paa)
#define ICON_WAIT QPATHTOEF(common,icons\wait.paa)
#define ICON_WAIT_CYCLE QPATHTOEF(common,icons\wait_cycle.paa)
#define ICON_WAIT_GEAR QPATHTOEF(common,icons\wait_gear.paa)
#define ICON_WEST "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_west_ca.paa"

#define ICON_SMOKE "\a3\Modules_F_Curator\Data\portraitsmokewhite_ca.paa"
#define ICON_IR "\a3\Modules_F_Curator\Data\portraitIRGrenade_ca.paa"
#define ICON_FLARE "\a3\Modules_F_Curator\Data\portraitflarewhite_ca.paa"
#define ICON_SMOKE_BLUE "\a3\Modules_F_Curator\Data\portraitSmokeBlue_ca.paa"
#define ICON_SMOKE_GREEN "\a3\Modules_F_Curator\Data\portraitSmokeGreen_ca.paa"
#define ICON_SMOKE_RED "\a3\Modules_F_Curator\Data\portraitSmokeRed_f_ca.paa"
#define ICON_SMOKE_YELLOW "\a3\Modules_F_Curator\Data\portraitSmokeYellow_ca.paa"
#define ICON_CHEM_BLUE "\a3\Modules_F_Curator\Data\portraitChemlightBlue_ca.paa"
#define ICON_CHEM_GREEN "\a3\Modules_F_Curator\Data\portraitChemlightGreen_ca.paa"
#define ICON_CHEM_RED "\a3\Modules_F_Curator\Data\portraitChemlightRed_ca.paa"
#define ICON_CHEM_YELLOW "\a3\Modules_F_Curator\Data\portraitChemlightYellow_ca.paa"
#define ICON_FLARE_GREEN "\a3\Modules_F_Curator\Data\portraitflaregreen_ca.paa"
#define ICON_FLARE_RED "\a3\Modules_F_Curator\Data\portraitflarered_ca.paa"
#define ICON_FLARE_YELLOW "\a3\Modules_F_Curator\Data\portraitflareyellow_ca.paa"

// Colors
#define HEX_YELLOW "#f5ca00"
#define HEX_GREEN "#20ca24"
#define HEX_BLUE "#0000ff"
#define HEX_RED "#ff0000"
#define RGBA_RED [0.9,0,0,1]
#define RGBA_ORANGE [0.85,0.4,0,1]
#define RGBA_YELLOW [0.85,0.85,0,1]
#define RGBA_GREEN [0,0.8,0,1]
#define RGBA_BLUE [0,0,1,1]
#define RGBA_PURPLE [0.75,0.15,0.75,1]

// Misc constants
#define GRAVITY 9.8066
#define HELO_PILOT_DISTANCE 650
#define VTOL_PILOT_DISTANCE 800
#define WAYPOINT_SLEEP 0.5

// Command macros
#define IMG_STR(PATH) (format ["<img image='%1'/>",PATH])
#define GEN_STR(VAR) (str [VAR,systemTimeUTC,random 99])
#define PRIMARY_CREW(VEH) (crew VEH arrayIntersect units group VEH)
#define SECONDARY_CREW(VEH) (crew VEH - units group VEH)
#define DELETE_GUI_MARKERS {deleteMarkerLocal _x} forEach PVAR(guiMarkers); PVAR(guiMarkers) = []

// Performance debug
#define PERF_WARNING_INIT private _PTT = diag_tickTime;
#define PERF_WARNING_END if (OPTION(debugPerf) && diag_tickTime - _PTT > 0.001) then {systemChat format ["%2: %1ms",(diag_tickTime - _PTT) * 1000,__FILE__ select [13]]};

// Module macros
#define LNAME(V1) QUOTE(TRIPLES(STR,ADDON,DOUBLES(V1,name)))
#define LINFO(V1) QUOTE(TRIPLES(STR,ADDON,DOUBLES(V1,info)))
#define ELNAME(V1,V2) QUOTE(TRIPLES(STR,DOUBLES(PREFIX,V1),DOUBLES(V2,name)))
#define ELINFO(V1,V2) QUOTE(TRIPLES(STR,DOUBLES(PREFIX,V1),DOUBLES(V2,info)))
#define CNAME(V1) QUOTE(TRIPLES($STR,ADDON,DOUBLES(V1,name)))
#define CINFO(V1) QUOTE(TRIPLES($STR,ADDON,DOUBLES(V1,info)))
#define ECNAME(V1,V2) QUOTE(TRIPLES($STR,DOUBLES(PREFIX,V1),DOUBLES(V2,name)))
#define ECINFO(V1,V2) QUOTE(TRIPLES($STR,DOUBLES(PREFIX,V1),DOUBLES(V2,info)))
#define DESC(V1) [LNAME(V1),LINFO(V1)]
#define EDESC(V1,V2) [ELNAME(V1,V2),ELINFO(V1,V2)]
#define ATTRIBUTE(V1) displayName = CNAME(V1); tooltip = CINFO(V1); property = QGVAR(V1)
#define EATTRIBUTE(V1,V2) displayName = ECNAME(V1,V2); tooltip = ECINFO(V1,V2); property = QGVAR(V2)

#define FINAL_ATTRIBUTES \
class RemoteAccess : Checkbox {\
	EATTRIBUTE(common,RemoteAccess);\
	typeName = "BOOL";\
	defaultValue = "true";\
};\
class AccessItems : Edit {\
	EATTRIBUTE(common,AccessItems);\
	typeName = "STRING";\
	defaultValue = "''";\
};\
class AccessItemsLogic : Default {\
	EATTRIBUTE(common,AccessItemsLogic);\
	typeName = "NUMBER";\
	defaultValue = 0;\
	control = QPVAR(toggle);\
	class Values {\
		class And {name = ECSTRING(common,LogicAND);};\
		class Or {name = ECSTRING(common,LogicOR);};\
	};\
};\
class AccessCondition : Default {\
	EATTRIBUTE(common,AccessCondition);\
	typeName = "STRING";\
	defaultValue = "'true'";\
	control = "EditCodeMulti3";\
	validate = "expression";\
};\
class RequestCondition : Default {\
	EATTRIBUTE(common,RequestCondition);\
	typeName = "STRING";\
	defaultValue = "'true'";\
	control = "EditCodeMulti3";\
	validate = "expression";\
};\
class PVAR(auth) : Default {\
	displayName = QPVAR(auth);\
	tooltip = "";\
	property = QPVAR(auth);\
	typeName = "STRING";\
	defaultValue = "''";\
	control = QPVAR(hidden);\
};\
class ModuleDescription: ModuleDescription {}
