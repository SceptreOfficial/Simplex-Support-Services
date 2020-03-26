#include "script_component.hpp"

class GVAR(Text) {
	idc = -1;
	type = 0;
	deletable = 0;
	x = 0;
	y = 0;
	w = 0;
	h = 0;
	colorBackground[] = {0,0,0,0.9};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {COLOR_DISABLED};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	tooltipColorText[] = {1,1,1,1};
	text = "";
	font = "RobotoCondensed";
	sizeEx = GUI_GRID_H * 1;
	style = 0;
	fixedWidth = 0;
	shadow = 0;
};

class GVAR(Checkbox) {
	idc = -1;
	type = 77;
	deletable = 0;
	style = 0;
	checked = 0;
	x = 0;
	y = 0;
	w = CHECKBOX_WIDTH;
	h = CHECKBOX_HEIGHT;
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

class GVAR(Editbox) {
	idc = -1;
	type = 2;
	deletable = 0;
	canModify = 1;
	x = 0;
	y = 0;
	w = EDITBOX_WIDTH;
	h = EDITBOX_HEIGHT;
	text = "";
	font = "RobotoCondensed";
	sizeEx = GUI_GRID_H * 1;
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

class GVAR(Slider) {
	idc = -1;
	type = 43;
	deletable = 0;
	x = 0;
	y = 0;
	w = SLIDER_WIDTH;
	h = SLIDER_HEIGHT;
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

class GVAR(SliderEdit) : GVAR(Editbox) {
	w = SLIDER_EDIT_WIDTH;
};

class GVAR(Combobox) {
	idc = -1;
	type = 4;
	deletable = 0;
	x = 0;
	y = 0;
	w = COMBOBOX_WIDTH;
	h = COMBOBOX_HEIGHT;
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
	sizeEx = GUI_GRID_H * 1;
	shadow = 0;
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	wholeHeight = 0.3;
};

class GVAR(ListNBox) {
	idc = -1;
	type = 102;
	deletable = 0;
	x = 0;
	y = 0;
	w = LISTNBOX_WIDTH;
	h = LISTNBOX_HEIGHT;
	columns[] = {0,0.2,0.4,0.6,0.8};
	rowHeight = 0.047;
	drawSideArrows = false;
	idcLeft = -1;
	idcRight = -1;
	color[] = {0.95,0.95,0.95,1};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {COLOR_DISABLED};
	colorScrollbar[] = {0.95,0.95,0.95,1};
	colorSelect[] = {0,0,0,1};
	colorSelect2[] = {0,0,0,1};
	colorSelectBackground[] = {0.8,0.8,0.8,1};
	colorSelectBackground2[] = {1,1,1,0.5};
	colorPicture[] = {1,1,1,1};
	colorPictureSelected[] = {1,1,1,1};
	colorPictureDisabled[] = {1,1,1,1};
	style = 16;
	font = "RobotoCondensed";
	sizeEx = GUI_GRID_H * 1;
	shadow = 0;
	disableOverflow = 0;
	soundSelect[] = {"",0.1,1};
	soundExpand[] = {"",0.1,1};
	soundCollapse[] = {"",0.1,1};
	period = 1.2;
	maxHistoryDelay = 0.5;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	class ListScrollBar
	{
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
};

class GVAR(Button) {
	idc = -1;
	type = 1;
	x = 0;
	y = 0;
	w = BUTTON_WIDTH;
	h = BUTTON_HEIGHT;
	colorBackground[] = {0,0,0,1};
	colorBackgroundActive[] = {0.3,0.3,0.3,1};
	colorBackgroundDisabled[] = {0,0,0,1};
	colorBorder[] = {0,0,0,0};
	colorDisabled[] = {COLOR_DISABLED};
	colorFocused[] = {0.2,0.2,0.2,1};
	colorShadow[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	text = "";
	font = "RobotoCondensed";
	sizeEx = GUI_GRID_H * 1;
	style = 2;
	borderSize = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	offsetX = 0;
	offsetY = 0;
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
};

class GVAR(Dialog) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(with uiNamespace do {GVAR(display) = _this select 0});

	class ControlsBackground {
		class Background {
			idc = 1;
			type = 0;
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			colorBackground[] = {0,0,0,0.8};
			colorText[] = {0,0,0,0};
			text = "";
			font = "RobotoCondensed";
			sizeEx = GUI_GRID_H * 1;
			style = 0;
		};
		class Title {
			idc = 2;
			type = 0;
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			colorBackground[] = {
				"profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]",
				"profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]",
				"profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]",
				"profilenamespace getvariable ['GUI_BCG_RGB_A',1]"
			};
			colorText[] = {1,1,1,1};
			text = "";
			font = "PuristaMedium";
			sizeEx = GUI_GRID_H * 1;
			style = 0;
		};
	};

	class Controls {
		class ControlsGroup {
			idc = 3;
			type = 15;
			deletable = 0;
			x = 0;
			y = 0;
			w = 1;
			h = 1;
			shadow = 0;
			style = 16;
			fade = 0;
			class VScrollbar {
				color[] = {1,1,1,1};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				shadow = 0;
				scrollSpeed = 0.06;
				width = 0.01;
				height = 0;
				autoScrollEnabled = 1;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
			};
			class HScrollbar {
				color[] = {1,1,1,1};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				shadow = 0;
				scrollSpeed = 0.06;
				width = 0;
				height = 0.01;
				autoScrollEnabled = 1;
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
			};
			class Controls {};
		};
		class Cancel {
			idc = 4;
			type = 1;
			onButtonClick = QUOTE(call FUNC(cancel));
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {0.4,0.4,0.4,1};
			colorBackgroundDisabled[] = {0,0,0,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0,0,0,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			text = "CANCEL";
			font = "PuristaMedium";
			sizeEx = GUI_GRID_H * 1;
			style = 2;
			borderSize = 0;
			offsetPressedX = 0;
			offsetPressedY = 0;
			offsetX = 0;
			offsetY = 0;
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
		};
		class Confirm {
			idc = 5;
			type = 1;
			onButtonClick = QUOTE(call FUNC(confirm));
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			colorBackground[] = {0,0,0,1};
			colorBackgroundActive[] = {0.4,0.4,0.4,1};
			colorBackgroundDisabled[] = {0,0,0,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0,0,0,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			text = "CONFIRM";
			font = "PuristaMedium";
			sizeEx = GUI_GRID_H * 1;
			style = 2;
			borderSize = 0;
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
