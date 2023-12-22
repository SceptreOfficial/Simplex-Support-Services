#define COMPONENT transport
#include "\z\sss\addons\main\script_mod.hpp"

//#define DEBUG_MODE_FULL
//#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_TRANSPORT
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_TRANSPORT
	#define DEBUG_SETTINGS DEBUG_SETTINGS_TRANSPORT
#endif

#include "\z\sss\addons\main\script_macros.hpp"
#include "\z\sss\addons\common\gui_macros.hpp"

#define QSERVICE "TRANSPORT"
#define ICON_SERVICE "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa"

#define ICON_BOAT_TRANSPORT QPATHTOF(icons\boat_transport.paa)
#define ICON_HELO_TRANSPORT QPATHTOF(icons\helo_transport.paa)
#define ICON_LAND_TRANSPORT QPATHTOF(icons\land_transport.paa)
#define ICON_PLANE_TRANSPORT QPATHTOF(icons\plane_transport.paa)
#define ICON_VTOL_TRANSPORT QPATHTOF(icons\vtol_transport.paa)

#define BOAT_TASK_TYPES ["MOVE","FOLLOW","HOLD","UNLOAD","SAD","FIRE"]
#define HELO_TASK_TYPES ["MOVE","FOLLOW","HOLD","LAND","LANDSIGNAL","HOVER","FASTROPE","HELOCAST","LOITER","SLINGLOADPICKUP","SLINGLOADDROPOFF","UNLOAD","PARADROP","SAD","STRAFE"]
#define LAND_TASK_TYPES ["MOVE","PATH","FOLLOW","HOLD","UNLOAD","SAD","FIRE"]
#define PLANE_TASK_TYPES ["MOVE","FOLLOW","HOLD","PARADROP","SAD","STRAFE"]
#define VTOL_TASK_TYPES ["MOVE","FOLLOW","HOLD","LAND","LANDSIGNAL","HOVER","FASTROPE","HELOCAST","LOITER","UNLOAD","PARADROP","SAD","STRAFE"]

#define COMBAT_MODES ["BLUE","GREEN","WHITE","YELLOW","RED"]

#define UNLOAD_DELAY 0.8

#define IDC_TABS 					110
#define IDC_CONFIRMATIONS_BG 		120
#define IDC_CONFIRMATIONS_GROUP 	130
#define IDC_PLAN_GROUP 				140
#define IDC_PLAN_HEADER 			150
#define IDC_PLAN 					160
#define IDC_ADD 					170
#define IDC_REMOVE 					180
#define IDC_CLEAR 					190
#define IDC_PLAN_LOGIC 				200
#define IDC_TASK_GROUP 				210
#define IDC_TASK_TEXT 				220
#define IDC_TASK 					230
#define IDC_GRID_TEXT 				240
#define IDC_GRID_E_TEXT 			250
#define IDC_GRID_E 					260
#define IDC_GRID_N_TEXT 			270
#define IDC_GRID_N 					280
#define IDC_TIMEOUT_TEXT 			290
#define IDC_TIMEOUT 				300
#define IDC_TIMEOUT_EDIT 			310
#define IDC_SPEED_TEXT 				320
#define IDC_SPEED 					330
#define IDC_SPEED_EDIT 				340
#define IDC_COMBAT_MODE_TEXT 		350
#define IDC_COMBAT_MODE 			360
#define IDC_LIGHTS_TEXT 			370
#define IDC_LIGHTS 					380
#define IDC_COLLISION_LIGHTS_TEXT 	390
#define IDC_COLLISION_LIGHTS 		400
#define IDC_ALTITUDE_ATL_TEXT 		410
#define IDC_ALTITUDE_ATL 			420
#define IDC_ALTITUDE_ATL_EDIT 		430
#define IDC_ALTITUDE_ASL_TEXT 		440
#define IDC_ALTITUDE_ASL 			450
#define IDC_ALTITUDE_ASL_EDIT 		460
#define IDC_REMOTE_CONTROL 			470
#define IDC_RTB 					480
