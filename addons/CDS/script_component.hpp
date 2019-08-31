#define COMPONENT CDS
#include "\z\SSS\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_CDS
#define DEBUG_MODE_FULL
#endif
#ifdef DEBUG_SETTINGS_CDS
#define DEBUG_SETTINGS DEBUG_SETTINGS_CDS
#endif

#include "\z\SSS\addons\main\script_macros.hpp"

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

#define DISPLAY_IDD 12700
#define BG_IDC 12701
#define TITLE_IDC 12702
#define CANCEL_IDC 12703
#define OK_IDC 12704
#define TEXT_IDC_START 12750
#define CTRL_IDC_START 12850
#define CTRL_AUX_IDC_START 12950

#define COLOR_DISABLED 1, 1, 1, 0.35
#define CENTER_Y 0.5
#define TOTAL_WIDTH 1
#define DEFAULT_X (0.5 - TOTAL_WIDTH / 2)
#define BUFFER_W 0.02
#define BUFFER_H 0.02
#define TITLE_H 0.06
#define BUTTON_W 0.2
#define BUTTON_H 0.05
#define BUTTON_SEPARATION 0.005
#define ROW_H 0.07

#define TEXT_X 0.01
#define TEXT_W (0.4 - BUFFER_W)
#define TEXT_H 0.06
#define CTRL_X (TEXT_W + BUFFER_W)
#define STANDARD_W (TOTAL_WIDTH - CTRL_X - BUFFER_W)

#define CHECKBOX_Y 0.005
#define CHECKBOX_W 0.04
#define CHECKBOX_H 0.05

#define EDITBOX_Y 0.005
#define EDITBOX_W STANDARD_W
#define EDITBOX_H 0.05

#define SLIDER_Y 0.01
#define SLIDER_W (TOTAL_WIDTH - CTRL_X - 0.1 - BUFFER_W)
#define SLIDER_H 0.04
#define SLIDER_AUX_X (CTRL_X + SLIDER_W + BUFFER_W)
#define SLIDER_AUX_Y EDITBOX_Y
#define SLIDER_AUX_W (0.1 - BUFFER_W)
#define SLIDER_AUX_H EDITBOX_H

#define COMBOBOX_Y 0.005
#define COMBOBOX_W STANDARD_W
#define COMBOBOX_H 0.05