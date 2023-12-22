#define COMPONENT sdf
#include "\z\sss\addons\main\script_mod.hpp"

//#define DEBUG_MODE_FULL
//#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_SDF
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_SDF
	#define DEBUG_SETTINGS DEBUG_SETTINGS_SDF
#endif

#include "\z\sss\addons\main\script_macros.hpp"
#include "\a3\ui_f_curator\ui\defineresincldesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "gui_macros.hpp"

// Control types
#define CT_STATIC				  0
#define CT_BUTTON				  1
#define CT_EDIT					  2
#define CT_SLIDER				  3
#define CT_COMBO				  4
#define CT_LISTBOX				  5
#define CT_TOOLBOX				  6
#define CT_CHECKBOXES			  7
#define CT_PROGRESS				  8
#define CT_HTML					  9
#define CT_STATIC_SKEW			 10
#define CT_ACTIVETEXT			 11
#define CT_TREE					 12
#define CT_STRUCTURED_TEXT		 13
#define CT_CONTEXT_MENU			 14
#define CT_CONTROLS_GROUP		 15
#define CT_SHORTCUTBUTTON		 16
#define CT_HITZONES				 17
#define CT_VEHICLETOGGLES		 18
#define CT_CONTROLS_TABLE		 19
#define CT_XKEYDESC				 40
#define CT_XBUTTON				 41
#define CT_XLISTBOX				 42
#define CT_XSLIDER				 43
#define CT_XCOMBO				 44
#define CT_ANIMATED_TEXTURE		 45
#define CT_MENU					 46
#define CT_MENU_STRIP			 47
#define CT_CHECKBOX				 77
#define CT_OBJECT				 80
#define CT_OBJECT_ZOOM			 81
#define CT_OBJECT_CONTAINER		 82
#define CT_OBJECT_CONT_ANIM		 83
#define CT_LINEBREAK			 98
#define CT_USER					 99
#define CT_MAP					100
#define CT_MAP_MAIN				101
#define CT_LISTNBOX				102
#define CT_ITEMSLOT				103
#define CT_LISTNBOX_CHECKABLE	104
#define CT_VEHICLE_DIRECTION	105
