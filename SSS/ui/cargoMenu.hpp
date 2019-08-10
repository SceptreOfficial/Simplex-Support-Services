#include "\a3\ui_f\hpp\defineDIKCodes.inc"

#define DISPLAY_IDD 77700
#define BG_IDC 77701
#define TITLE_IDC 77702
#define LISTBOX_IDC 77703
#define CATEGORY_IDC 77704
#define CANCEL_IDC 77705
#define OK_IDC 77706


#define POS_X 0
#define POS_Y 0.4
#define WIDTH 1
#define HEIGHT 0.6
#define BUFFER 0.02
#define TITLE_H 0.1
#define BG_Y POS_Y + TITLE_H + BUFFER
#define BG_H HEIGHT - TITLE_H - BUFFER
#define BUTTON_W 0.2
#define BUTTON_H 0.05
#define CATEGORY_H 0.1
#define LISTBOX_H BG_H - (BUFFER * 3) - CATEGORY_H

class RscListBox;
class RscText;
class RscXComboBox;

class SSS_CargoMenu {
	idd = DISPLAY_IDD;

	class ControlsBackground {
		class Background {
			idc = BG_IDC;
			type = 0;
			x = POS_X;
			y = BG_Y;
			w = WIDTH;
			h = BG_H;
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
			x = POS_X;
			y = POS_Y;
			w = WIDTH;
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
		class Listbox : RscListBox {
			idc = LISTBOX_IDC;
			x = POS_X + BUFFER;
			y = BG_Y + BUFFER;
			w = WIDTH - (BUFFER * 2);
			h = BG_H - (BUFFER * 3) - CATEGORY_H;
		};
		class Category_Text : RscText {
			idc = -1;
			x = POS_X + BUFFER;
			y = LISTBOX_H + BUFFER;
			w = (WIDTH - (BUFFER * 2)) * 0.3;
			h = CATEGORY_H;
			text = "Category:";
		};
		class Category : RscXComboBox {
			idc = CATEGORY_IDC;
			x = POS_X + BUFFER + (WIDTH - * 0.3);
			y = LISTBOX_H + BUFFER;
			w = (WIDTH - (BUFFER * 2)) * 0.7;
			h = COMBOBOX_H;
		};
		class Cancel {
			idc = CANCEL_IDC;
			type = 1;
			onButtonClick = "closeDialog 0;";
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
			onButtonClick = "closeDialog 0;";
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
