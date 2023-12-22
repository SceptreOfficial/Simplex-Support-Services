// Preferences
#define PROFILE_COLORS_R profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]
#define PROFILE_COLORS_G profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]
#define PROFILE_COLORS_B profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]

// Macros
#define COLOR_DISABLED 1,1,1,0.35

#define GRID_W(N) (pixelW * pixelGridNoUIScale * N)
#define GRID_H(N) (pixelH * pixelGridNoUIScale * N)
#define GD_W(N) GRID_W(N * 1.5)
#define GD_H(N) GRID_H(N * 1.5)

#define BUFFER_W GD_W(0.1)
#define BUFFER_H GD_H(0.1)

#define MAIN_X(N) ((safezoneXAbs + (safezoneWAbs / 2)) - (GD_W(N) / 2))
#define MAIN_Y(N) ((safezoneY + (safezoneH / 2)) - (GD_H(N) / 2))

#define TITLE_X(N) (MAIN_X(N) - BUFFER_W)
#define TITLE_Y(N) (MAIN_Y(N) - GD_H(1) - BUFFER_H)
#define TITLE_W(N) (GD_W(N) + (BUFFER_W * 2))
#define TITLE_H GD_H(1)

#define BG_X(N) (MAIN_X(N) - BUFFER_W)
#define BG_Y(N) (MAIN_Y(N) - BUFFER_H)
#define BG_W(N) (GD_W(N) + (BUFFER_W * 2))
#define BG_H(N) (GD_H(N) + (BUFFER_H * 2))

#define GROUP_X(N) MAIN_X(N)
#define GROUP_Y(N) MAIN_Y(N)
#define GROUP_W(N) (GD_W(N) + BUFFER_W)
#define GROUP_H(N) (GD_H(N) + BUFFER_H)

#define MAIN_BUTTON_W GD_W(5)
#define MAIN_BUTTON_H GD_H(1)
#define CANCEL_X(N) (MAIN_X(N) - BUFFER_W)
#define CANCEL_Y(N) (MAIN_Y(N) + GD_H(N) + (BUFFER_H * 3))
#define CONFIRM_X(N) (MAIN_X(N) + GD_W(N) + BUFFER_W - MAIN_BUTTON_W)
#define CONFIRM_Y(N) (MAIN_Y(N) + GD_H(N) + (BUFFER_H * 3))

#define CTRL_X(N) (GD_W(N) + (BUFFER_W / 2))
#define CTRL_Y(N) (GD_H(N) + (BUFFER_H / 2))
#define CTRL_W(N) ((GD_W(N) min safeZoneW) - BUFFER_W)
#define CTRL_H(N) ((GD_H(N) min safeZoneH) - BUFFER_H)
#define CTRL_X_BUFFER(N) (GD_W(N) - (BUFFER_W / 2))
#define CTRL_Y_BUFFER(N) (GD_H(N) - (BUFFER_H / 2))
#define CTRL_W_BUFFER(N) ((GD_W(N) min safeZoneW) + BUFFER_W)
#define CTRL_H_BUFFER(N) ((GD_H(N) min safeZoneH) + BUFFER_H)

#define SPACING_W GRID_W(0.15)
#define SPACING_H GRID_H(0.15)

#define MIN_H GRID_H(1.3)
#define MAX_H GRID_H(25)
#define CONTENT_W GRID_W(30)
#define ITEM_H GRID_H(1.3)
#define DESCRIPTION_W GRID_W(12)
#define LEG_TITLE_H ITEM_H
#define MENU_BUTTON_W GRID_W(6)
#define MENU_BUTTON_H ITEM_H
#define CONTROL_X (DESCRIPTION_W + SPACING_W)
#define CONTROL_W (CONTENT_W - DESCRIPTION_W - SPACING_W)
#define CHECKBOX_W GRID_W(1.3)
#define CHECKBOX_H GRID_H(1.3)
#define EDITBOX_W CONTROL_W
#define EDITBOX_H ITEM_H
#define SLIDER_EDIT_W GRID_W(3)
#define SLIDER_W (CONTROL_W - SPACING_W - SLIDER_EDIT_W)
#define SLIDER_H ITEM_H
#define COMBOBOX_W CONTROL_W
#define COMBOBOX_H ITEM_H
#define LISTNBOX_W (DESCRIPTION_W + SPACING_W + CONTROL_W)
#define LISTNBOX_H ITEM_H
#define BUTTON_W (DESCRIPTION_W + SPACING_W + CONTROL_W)
#define BUTTON2_W (((DESCRIPTION_W + SPACING_W + CONTROL_W) / 2) - (SPACING_W / 2))
#define BUTTON_H ITEM_H
#define CARGOBOX_W (((DESCRIPTION_W + SPACING_W + CONTROL_W) * 0.475) - SPACING_W)
#define CARGOBOX_H ITEM_H
#define CARGOBOX_BUTTON_W ((DESCRIPTION_W + SPACING_W + CONTROL_W) * 0.05)
#define CARGOBOX_BUTTON_H (ITEM_H * 0.7)
#define TREE_W (DESCRIPTION_W + SPACING_W + CONTROL_W)
#define TREE_H ITEM_H
#define CREATE_DESCRIPTION \
	private _ctrlDescription = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup]; \
	_ctrlDescription ctrlSetPosition [0,_posY,DESCRIPTION_W,ITEM_H]; \
	_ctrlDescription ctrlCommit 0; \
	_ctrlDescription ctrlSetText _descriptionText; \
	_ctrlDescription ctrlSetTooltip _descriptionTooltip
