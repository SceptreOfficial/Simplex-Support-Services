#include "\z\sss\addons\sdf\gui_macros.hpp"

class EGVAR(sdf,Checkbox);
class EGVAR(sdf,Text);
class EGVAR(sdf,StructuredText);
class EGVAR(sdf,ControlsGroup);
class EGVAR(sdf,ButtonSimple);
class EGVAR(sdf,Button);
class EGVAR(sdf,Combobox);
class EGVAR(sdf,ControlsGroupNoScrollbars);
class EGVAR(sdf,Editbox);
class EGVAR(sdf,Tree);
class EGVAR(sdf,Slider);
class EGVAR(sdf,Listbox);
class EGVAR(sdf,ListNBox);
class EGVAR(sdf,Toolbox);
class RscMapControl;

#define GUI_W 50
#define GUI_H 28

class GVAR(titleBG) : EGVAR(sdf,Text) {
	idc = IDC_TITLE_BG;
	x = QUOTE(TITLE_X(GUI_W));
	y = QUOTE(TITLE_Y(GUI_H));
	w = QUOTE(TITLE_W(GUI_W));
	h = QUOTE(TITLE_H);
	colorBackground[] = {QEGVAR(sdf,profileR),QEGVAR(sdf,profileG),QEGVAR(sdf,profileB),1};
};
class GVAR(titleLogo) : EGVAR(sdf,Text) {
	idc = IDC_TITLE_LOGO;
	x = QUOTE(TITLE_X(GUI_W));
	y = QUOTE(TITLE_Y(GUI_H) + BUFFER_H);
	w = QUOTE(GD_W(1));
	h = QUOTE(TITLE_H - (BUFFER_H * 2));
	colorBackground[] = {0,0,0,0};
	text = ICON_SSS;
	style = "48 + 2048";
};
class GVAR(titleText) : EGVAR(sdf,Text) {
	idc = IDC_TITLE_TEXT;
	x = QUOTE(TITLE_X(GUI_W) + GD_W(0.9));
	y = QUOTE(TITLE_Y(GUI_H));
	w = QUOTE(GD_W(20));
	h = QUOTE(TITLE_H);
	colorBackground[] = {0,0,0,0};
	font = "PuristaMedium";
	text = CSTRING(guiTitle);
};
class GVAR(background) : EGVAR(sdf,Text) {
	idc = IDC_BG;
	x = QUOTE(BG_X(GUI_W));
	y = QUOTE(BG_Y(GUI_H));
	w = QUOTE(BG_W(GUI_W));
	h = QUOTE(BG_H(GUI_H));
};
class GVAR(close) : EGVAR(sdf,ButtonSimple) {
	idc = IDC_CLOSE;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(0));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(27));
	w = QUOTE(CTRL_W(11));
	h = QUOTE(CTRL_H(1));
	font = "PuristaMedium";
	text = CSTRING(guiClose);
	onButtonClick = QUOTE(true call FUNC(gui_close));
};
class GVAR(confirm) : EGVAR(sdf,ButtonSimple) {
	idc = IDC_CONFIRM;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(11));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(27));
	w = QUOTE(CTRL_W(11));
	h = QUOTE(CTRL_H(1));
	font = "PuristaMedium";
	text = CSTRING(guiConfirm);
	onButtonClick = QUOTE(call FUNC(gui_confirm));
};
class GVAR(map) : RscMapControl {
	idc = IDC_MAP;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(22));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(0));
	w = QUOTE(CTRL_W(28));
	h = QUOTE(CTRL_H(28));
	onDraw = QUOTE(call FUNC(gui_mapDraw));
};
class GVAR(mapText) : EGVAR(sdf,Text) {
	idc = IDC_MAP_TEXT;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(22) + CTRL_W(28));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(0) + CTRL_H(28));
	w = QUOTE(0);
	h = QUOTE(0);
	style = 1;
};
class GVAR(serviceText) : EGVAR(sdf,Text) {
	idc = IDC_SERVICE_TEXT;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(0));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(0));
	w = QUOTE(CTRL_W(8));
	h = QUOTE(CTRL_H(1));
	text = CSTRING(guiService);
};
class GVAR(service) : EGVAR(sdf,Combobox) {
	idc = IDC_SERVICE;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(8));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(0));
	w = QUOTE(CTRL_W(14));
	h = QUOTE(CTRL_H(1));
	onLoad = QUOTE(call FUNC(gui_serviceLoad));
};
class GVAR(entityText) : EGVAR(sdf,Text) {
	idc = IDC_ENTITY_TEXT;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(0));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(1));
	w = QUOTE(CTRL_W(8));
	h = QUOTE(CTRL_H(1));
	text = CSTRING(guiEntity);
};
class GVAR(entity) : EGVAR(sdf,Combobox) {
	idc = IDC_ENTITY;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(8));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(1));
	w = QUOTE(CTRL_W(14));
	h = QUOTE(CTRL_H(1));
	onLoad = QUOTE(call FUNC(gui_entityLoad));
};
class GVAR(statusText) : EGVAR(sdf,Text) {
	idc = IDC_STATUS_TEXT;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(0));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(2));
	w = QUOTE(CTRL_W(8));
	h = QUOTE(CTRL_H(1));
	text = CSTRING(guiStatus);
};
class GVAR(status) : EGVAR(sdf,StructuredText) {
	idc = IDC_STATUS;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(8));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(2));
	w = QUOTE(CTRL_W(10));
	h = QUOTE(CTRL_H(1));
	text = CSTRING(NA);
	style = "0x02";
	onLoad = QUOTE(call FUNC(gui_statusLoad));
	class Attributes {
		align = "center";
		valign = "middle";
	};
};
class GVAR(abort) : EGVAR(sdf,ButtonSimple) {
	idc = IDC_ABORT;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(18));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(2));
	w = QUOTE(CTRL_W(4));
	h = QUOTE(CTRL_H(1));
	text = CSTRING(guiAbort);
	onButtonClick = QUOTE(call FUNC(gui_abort));
};
class GVAR(instructionsText) : EGVAR(sdf,Text) {
	idc = IDC_INSTRUCTIONS_TEXT;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(0));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y(3));
	w = QUOTE(CTRL_W(22));
	h = QUOTE(CTRL_H(1));
	font = "PuristaMedium";
	text = CSTRING(guiInstructions);
	colorBackground[] = {QEGVAR(sdf,profileR),QEGVAR(sdf,profileG),QEGVAR(sdf,profileB),1};
};
class GVAR(instructionsBG) : EGVAR(sdf,Text) {
	idc = IDC_INSTRUCTIONS_BG;
	x = QUOTE(MAIN_X(GUI_W) + CTRL_X(0));
	y = QUOTE(MAIN_Y(GUI_H) + CTRL_Y_BUFFER(4));
	w = QUOTE(CTRL_W(22));
	h = QUOTE(CTRL_H_BUFFER(23));
	colorBackground[] = {1,1,1,0.2};
};
class GVAR(instructionsGroup) : EGVAR(sdf,ControlsGroup) {
	idc = IDC_INSTRUCTIONS_GROUP;
	x = QUOTE(MAIN_X(GUI_W) + GD_W(1));
	y = QUOTE(MAIN_Y(GUI_H) + GD_H(4));
	w = QUOTE(GD_W(21));
	h = QUOTE(GD_H(23));
	class Controls {};
};
class GVAR(toggleDistribution) : EGVAR(sdf,Checkbox) {
	idc = -1;
	textureChecked = QPATHTOF(icons\toggle_duration_1.paa);
	textureFocusedChecked = QPATHTOF(icons\toggle_duration_1.paa);
	textureHoverChecked = QPATHTOF(icons\toggle_duration_2.paa);
	texturePressedChecked = QPATHTOF(icons\toggle_duration_1.paa);
	textureDisabledChecked = QPATHTOF(icons\toggle_duration_1.paa);
	textureUnchecked = QPATHTOF(icons\toggle_quantity_1.paa);
	textureFocusedUnchecked = QPATHTOF(icons\toggle_quantity_1.paa);
	textureHoverUnchecked = QPATHTOF(icons\toggle_quantity_2.paa);
	texturePressedUnchecked = QPATHTOF(icons\toggle_quantity_1.paa);
	textureDisabledUnchecked = QPATHTOF(icons\toggle_quantity_1.paa);
};
class GVAR(toggleAzimuth) : EGVAR(sdf,Checkbox) {
	idc = -1;
	textureChecked = QPATHTOF(icons\toggle_degrees_1.paa);
	textureFocusedChecked = QPATHTOF(icons\toggle_degrees_1.paa);
	textureHoverChecked = QPATHTOF(icons\toggle_degrees_2.paa);
	texturePressedChecked = QPATHTOF(icons\toggle_degrees_1.paa);
	textureDisabledChecked = QPATHTOF(icons\toggle_degrees_1.paa);
	textureUnchecked = QPATHTOF(icons\toggle_cardinal_1.paa);
	textureFocusedUnchecked = QPATHTOF(icons\toggle_cardinal_1.paa);
	textureHoverUnchecked = QPATHTOF(icons\toggle_cardinal_2.paa);
	texturePressedUnchecked = QPATHTOF(icons\toggle_cardinal_1.paa);
	textureDisabledUnchecked = QPATHTOF(icons\toggle_cardinal_1.paa);
};
