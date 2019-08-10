#include "defines.hpp"

class SSS_CDS_Text {
	idc = -1;
	type = 0;
	deletable = 0;
	x = TEXT_X;
	y = 0;
	w = TEXT_W;
	h = TEXT_H;
	text = "";
	font = "RobotoCondensed";
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	style = 0;
	fixedWidth = 0;
	shadow = 0;
	colorBackground[] = {0,0,0,0.9};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {COLOR_DISABLED};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
};

class SSS_CDS_Checkbox {
	idc = -1;
	type = 77;
	deletable = 0;
	style = 0;
	checked = 0;
	x = CTRL_X;
	y = CHECKBOX_Y;
	w = CHECKBOX_W;
	h = CHECKBOX_H;
	color[] = {1,1,1,1};
	colorFocused[] = {1,1,1,1};
	colorHover[] = {1,1,1,1};
	colorPressed[] = {1,1,1,1};
	colorDisabled[] = {COLOR_DISABLED};
	colorBackground[] = {0,0,0,0};
	colorBackgroundFocused[] = {0,0,0,0};
	colorBackgroundHover[] = {0,0,0,0};
	colorBackgroundPressed[] = {0,0,0,0};
	colorBackgroundDisabled[] = {0,0,0,0};
	textureChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureFocusedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureFocusedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureHoverChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureHoverUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	texturePressedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	texturePressedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	textureDisabledChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
	textureDisabledUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
	soundEnter[] = {"", 0.1, 1};
	soundPush[] = {"", 0.1, 1};
	soundClick[] = {"", 0.1, 1};
	soundEscape[] = {"", 0.1, 1};
};

class SSS_CDS_Editbox {
	idc = -1;
	type = 2;
	deletable = 0;
	canModify = 1;
	x = CTRL_X;
	y = EDITBOX_Y;
	w = EDITBOX_W;
	h = EDITBOX_H;
	text = "";
	font = "RobotoCondensed";
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	style = "0x00 + 0x40";
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {COLOR_DISABLED};
	colorSelection[] = {
		"profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]",
		"profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]",
		"profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]",
		"profilenamespace getvariable ['GUI_BCG_RGB_A',1]"
	};
	autocomplete = "";
};

class SSS_CDS_Slider {
	idc = -1;
	type = 43;
	deletable = 0;
	x = CTRL_X;
	y = SLIDER_Y;
	w = SLIDER_W;
	h = SLIDER_H;
	shadow = 0;
	style = "0x400	+ 0x10";
	color[] = {1,1,1,1};
	colorActive[] = {1,1,1,1};
	colorDisable[] = {COLOR_DISABLED};
	colorDisabled[] = {COLOR_DISABLED};
	colorBackground[] = {0,0,0,1};
	arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
	arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
	border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
	thumb = "\A3\ui_f\data\gui\cfg\slider\thumb_ca.paa";
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
};

class SSS_CDS_SliderAux : SSS_CDS_Editbox {
	x = CTRL_X;
	y = SLIDER_AUX_Y;
	w = SLIDER_AUX_W;
	h = SLIDER_AUX_H;
};

class SSS_CDS_Combobox {
	idc = -1;
	type = 4;
	deletable = 0;
	x = CTRL_X;
	y = COMBOBOX_Y;
	w = COMBOBOX_W;
	h = COMBOBOX_H;
	colorBackground[] = {0,0,0,1};
	colorDisabled[] = {COLOR_DISABLED};
	colorSelect[] = {1,1,1,1};
	colorSelectBackground[] = {1,1,1,0.7};
	colorText[] = {1,1,1,1};
	colorActive[] = {1,0,0,1};
	colorPicture[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	colorPictureDisabled[] = {1,1,1,0.5};
	soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1};
	soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1};
	soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1};
	maxHistoryDelay = 1;
	class ComboScrollBar {
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {COLOR_DISABLED};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		shadow = 0;
		scrollSpeed = 0.06;
		width = 0;
		height = 0;
		autoScrollEnabled = 0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
	};
	style = "0x10 + 0x200";
	font = "RobotoCondensed";
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	shadow = 0;
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	wholeHeight = 0.3;
};

class SSS_CDS_Dialog {
	idd = DISPLAY_IDD;

	class ControlsBackground {
		class Background {
			idc = BG_IDC;
			type = 0;
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			text = "";
			font = "RobotoCondensed";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			style = 0;
			colorBackground[] = {0,0,0,0.85};
			colorText[] = {1,1,1,1};
		};
	};

	class Controls {
		class Title {
			idc = TITLE_IDC;
			type = 0;
			x = 0;
			y = 0.5;
			w = TOTAL_WIDTH;
			h = TITLE_H;
			text = "";
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			style = 0;
			colorBackground[] = {
				"profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]",
				"profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]",
				"profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]",
				"profilenamespace getvariable ['GUI_BCG_RGB_A',1]"
			};
			colorText[] = {1,1,1,1};
		};
		class Cancel {
			idc = CANCEL_IDC;
			type = 1;
			onButtonClick = "call SSS_CDS_fnc_cancel;";
			x = 0;
			y = 0;
			w = BUTTON_W;
			h = BUTTON_H;
			text = "CANCEL";
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			style = 2;
			borderSize = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {0.4,0.4,0.4,1};
			colorBackgroundDisabled[] = {0,0,0,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0,0,0,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			offsetPressedX = 0;
			offsetPressedY = 0;
			offsetX = 0;
			offsetY = 0;
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
		};
		class OK {
			idc = OK_IDC;
			type = 1;
			onButtonClick = "call SSS_CDS_fnc_confirm;";
			x = 0;
			y = 0;
			w = BUTTON_W;
			h = BUTTON_H;
			text = "OK";
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			style = 2;
			borderSize = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {0.4,0.4,0.4,1};
			colorBackgroundDisabled[] = {0,0,0,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0,0,0,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			offsetPressedX = 0;
			offsetPressedY = 0;
			offsetX = 0;
			offsetY = 0;
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
		};
	};
};
