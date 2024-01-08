#define COMPONENT logistics
#include "\z\sss\addons\main\script_mod.hpp"

//#define DEBUG_MODE_FULL
//#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_LOGISTICS
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_LOGISTICS
	#define DEBUG_SETTINGS DEBUG_SETTINGS_LOGISTICS
#endif

#include "\z\sss\addons\main\script_macros.hpp"
#include "\z\sss\addons\common\gui_macros.hpp"

#define QSERVICE "LOGISTICS"
#define ICON_SERVICE ICON_BOX

#define MAX_LOAD 9999999
#define SIGNAL_CLASSES ["","SmokeShellBlue","SmokeShellGreen","SmokeShellRed","SmokeShellYellow","Chemlight_blue","Chemlight_green","Chemlight_red","Chemlight_yellow","B_IRStrobe","FlareGreen_F","FlareRed_F","FlareYellow_F"]

#define IDC_ITEMS_GROUP 			110
#define IDC_ITEMS 					120
#define IDC_FIND 					130
#define IDC_SELECTION 				140
#define IDC_LOAD 					150
#define IDC_LOAD_ICON 				160
#define IDC_CLEAR 					170
#define IDC_OPTIONS_GROUP 			180
#define IDC_GRID_TEXT 				190
#define IDC_GRID_E_TEXT 			200
#define IDC_GRID_E 					210
#define IDC_GRID_N_TEXT 			220
#define IDC_GRID_N 					230
#define IDC_SIGNALS_TEXT 			240
#define IDC_SIGNAL1 				250
#define IDC_SIGNAL2 				260
#define IDC_AI_HANDLING_TEXT 		270
#define IDC_AI_HANDLING 			280
#define IDC_PREVIEW_IMAGE 			290
#define IDC_PREVIEW_INFO_GROUP 		300
#define IDC_PREVIEW_INFO 			310
#define IDC_PREVIEW_LEFT 			320
#define IDC_PREVIEW_RIGHT 			330
#define IDC_OBJECT_LIMIT 			340
#define IDC_OBJECT_LIMIT_ICON 		350
#define IDC_CREW_LIMIT 				360
#define IDC_CREW_LIMIT_ICON 		370
#define IDC_CLEAR_AREA 				380
