#define COMPONENT artillery
#include "\z\sss\addons\main\script_mod.hpp"

//#define DEBUG_MODE_FULL
//#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_ARTILLERY
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_ARTILLERY
	#define DEBUG_SETTINGS DEBUG_SETTINGS_ARTILLERY
#endif

#include "\z\sss\addons\main\script_macros.hpp"
#include "\z\sss\addons\common\gui_macros.hpp"

#define QSERVICE "ARTILLERY"
#define ICON_SERVICE "\A3\Ui_f\data\GUI\Cfg\CommunicationMenu\artillery_ca.paa"

#define SHEAF_TYPES ["CONVERGED","PARALLEL","BOX","CREEPING"]

#define IDC_TABS 						110
#define IDC_RELOCATE_BG 				120
#define IDC_RELOCATE_GROUP 				130
#define IDC_RELOCATE_GRID_TEXT 			140
#define IDC_RELOCATE_GRID_E_TEXT 		150
#define IDC_RELOCATE_GRID_E 			160
#define IDC_RELOCATE_GRID_N_TEXT 		170
#define IDC_RELOCATE_GRID_N 			180
#define IDC_RELOCATE_MAP_SELECT 		190
#define IDC_RELOCATE_CONFIRM 			220
#define IDC_PLAN_GROUP 					230
#define IDC_PLAN_HEADER 				240
#define IDC_PLAN 						250
#define IDC_ADD 						260
#define IDC_REMOVE 						270
#define IDC_CLEAR 						280
#define IDC_PLAN_OPTIONS_BUTTON 		290
#define IDC_PLAN_OPTIONS_BG 			300
#define IDC_PLAN_OPTIONS_GROUP 			310
#define IDC_LOOP_COUNT_TEXT 			320
#define IDC_LOOP_COUNT 					330
#define IDC_LOOP_COUNT_EDIT 			340
#define IDC_LOOP_DELAY_TEXT 			350
#define IDC_LOOP_DELAY 					360
#define IDC_LOOP_DELAY_EDIT 			370
#define IDC_COORDINATION_TEXT 			380
#define IDC_COORDINATION 				390
#define IDC_TASK_GROUP 					400
#define IDC_GRID_TEXT 					410
#define IDC_GRID_E_TEXT 				420
#define IDC_GRID_E 						430
#define IDC_GRID_N_TEXT 				440
#define IDC_GRID_N 						450
#define IDC_ETA_TEXT 					460
#define IDC_ETA 						470
#define IDC_SHEAF_TEXT 					480
#define IDC_SHEAF 						490
#define IDC_SHEAF_PARAMS_TEXT 			500
#define IDC_SHEAF_WIDTH_TEXT 			510
#define IDC_SHEAF_WIDTH 				520
#define IDC_SHEAF_HEIGHT_TEXT 			530
#define IDC_SHEAF_HEIGHT 				540
#define IDC_SHEAF_ANGLE_TEXT 			550
#define IDC_SHEAF_ANGLE 				560
#define IDC_SHEAF_DISPERSION_TEXT 		570
#define IDC_SHEAF_DISPERSION 			580
#define IDC_SHEAF_DISPERSION_EDIT 		590
#define IDC_AMMUNITION_TEXT 			600
#define IDC_AMMUNITION 					610
#define IDC_ROUNDS_TEXT 				620
#define IDC_ROUNDS 						630
#define IDC_ROUNDS_EDIT 				640
#define IDC_EXECUTION_DELAY_TEXT 		650
#define IDC_EXECUTION_DELAY 			660
#define IDC_EXECUTION_DELAY_EDIT 		670
#define IDC_FIRING_DELAY_TEXT 			680
#define IDC_FIRING_DELAY 				690
#define IDC_FIRING_DELAY_EDIT 			700
#define IDC_REMOTE_CONTROL 				710
