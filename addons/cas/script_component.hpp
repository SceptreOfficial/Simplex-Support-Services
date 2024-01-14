#define COMPONENT cas
#include "\z\sss\addons\main\script_mod.hpp"

//#define DEBUG_MODE_FULL
//#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_CAS
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_CAS
	#define DEBUG_SETTINGS DEBUG_SETTINGS_CAS
#endif

#include "\z\sss\addons\main\script_macros.hpp"
#include "\z\sss\addons\common\gui_macros.hpp"

#define QSERVICE "CAS"
#define ICON_SERVICE ICON_CAS

#define STRAFE_TARGETS ["MAP","LASER","SMOKE","IR","FLARE"]
#define LOITER_TARGETS ["ENEMIES","INFANTRY","VEHICLES","MAP","LASER","SMOKE","IR","FLARE"]

#define LOITER_ALTITUDE_DEFAULT 1000
#define LOITER_RADIUS_DEFAULT 1200

#define IDC_GRID_E 						100
#define IDC_GRID_N 						110
#define IDC_ALTITUDE 					120
#define IDC_ALTITUDE_EDIT 				130
#define IDC_RANGE 						140
#define IDC_RANGE_EDIT 					150
#define IDC_INGRESS 					160
#define IDC_INGRESS_SLIDER 				170
#define IDC_INGRESS_SLIDER_EDIT 		180
#define IDC_INGRESS_TOGGLE 				190
#define IDC_EGRESS 						200
#define IDC_EGRESS_SLIDER 				210
#define IDC_EGRESS_SLIDER_EDIT 			220
#define IDC_EGRESS_TOGGLE 				230
#define IDC_TARGET 						240
#define IDC_TARGET_DETAIL 				250
#define IDC_SPREAD 						260
#define IDC_SPREAD_EDIT 				270
#define IDC_PRIMARY 					280
#define IDC_PRIMARY_QUANTITY 			290
#define IDC_PRIMARY_DISTRIBUTION 		300
#define IDC_PRIMARY_INTERVAL 			310
#define IDC_SECONDARY 					320
#define IDC_SECONDARY_QUANTITY 			330
#define IDC_SECONDARY_DISTRIBUTION 		340
#define IDC_SECONDARY_INTERVAL 			350
#define IDC_RADIUS 						360
#define IDC_RADIUS_EDIT 				370
#define IDC_TYPE 						380
#define IDC_TYPE_ALT 					381
#define IDC_WEAPON 						390
#define IDC_REMOTE_CONTROL_SELECT 		400
#define IDC_REMOTE_CONTROL 				410
#define IDC_BURST_DURATION 				420
#define IDC_BURST_DURATION_EDIT 		430
#define IDC_BURST_INTERVAL 				440
#define IDC_BURST_INTERVAL_EDIT 		450
#define IDC_SPACING 					460
#define IDC_SPACING_EDIT 				470
#define IDC_AIRCRAFT 					480
#define IDC_AIRCRAFT_EDIT 				490
#define IDC_INTERVAL 					500
#define IDC_INTERVAL_EDIT 				510
#define IDC_DANGER_CLOSE 				520
#define IDC_SPEED_MODE 					530
