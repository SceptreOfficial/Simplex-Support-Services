#include "\a3\ui_f\hpp\defineCommonGrids.inc"

#define POPUP_X (safezoneX + 1 * GUI_GRID_W)
#define POPUP_Y (safezoneY + 14 * GUI_GRID_H)
#define POPUP_W (16 * GUI_GRID_W)

#define POPUP_TITLE_H (1 * GUI_GRID_H)
#define POPUP_CONTENT_H (2 * GUI_GRID_H)
#define POPUP_GAP_H (0.05 * GUI_GRID_H)

#define POPUP_H ((0.25 * GUI_GRID_H) + POPUP_TITLE_H + POPUP_GAP_H + POPUP_CONTENT_H)
#define POPUP_LIMIT 6

#define POPUP_FADE_IN 0.4
#define POPUP_FADE_OUT 3
#define POPUP_DURATION 8
#define POPUP_CLEAR 0.2
#define POPUP_PUSH 0.1

#define IDC_POPUP_TITLE 100
#define IDC_POPUP_BODY 110