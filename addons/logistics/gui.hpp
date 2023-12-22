#include "\z\sss\addons\sdf\gui_macros.hpp"

DECLARE_COMMON_GUI_CLASSES;

class GVAR(gui) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(call FUNC(gui));

	class ControlsBackground {
		COMMON_GUI_CONTROLS_BG;
	};

	class Controls {
		COMMON_GUI_CONTROLS {
			class Controls {
				class GVAR(itemsGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_ITEMS_GROUP;
					x = QUOTE(GD_W(0));
					y = QUOTE(GD_H(0));
					w = QUOTE(GD_W(20));
					h = QUOTE(GD_H(23));
					class Controls {
						class GVAR(dummy) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(0));
							h = QUOTE(CTRL_H(0));
						};
						class GVAR(itemsText) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(availableItems);
						};
						class GVAR(items) : EGVAR(sdf,Tree) {
							idc = IDC_ITEMS;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(13));
							sizeEx = QUOTE(GRID_H(1));
							onTreeDblClick = QUOTE(call FUNC(gui_itemAdd));
							onTreeSelChanged = QUOTE(call FUNC(gui_preview));
							idcSearch = IDC_FIND;
						};
						class GVAR(findIcon) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(6));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_SEARCH;
							style = "0x30 + 0x800";
						};
						class GVAR(find) : EGVAR(sdf,Editbox) {
							idc = IDC_FIND;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(5.9));
							h = QUOTE(CTRL_H(0.9));
							text = "";
						};
						class GVAR(previewText) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(itemInfo);
						};
						class GVAR(previewBG) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(13));
							colorBackground[] = {0,0,0,0.9};
						};
						class GVAR(previewImage) : RscPictureKeepAspect {
							idc = IDC_PREVIEW_IMAGE;
							x = QUOTE(CTRL_X(13.1));
							y = QUOTE(CTRL_Y(1.1));
							w = QUOTE(CTRL_W(6.8));
							h = QUOTE(CTRL_H(4));
						};
						class GVAR(previewLeft) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_PREVIEW_LEFT;
							x = QUOTE(CTRL_X(13.2));
							y = QUOTE(CTRL_Y(2.8));
							w = QUOTE(CTRL_W(0.6));
							h = QUOTE(CTRL_H(0.6));
							text = ICON_ARROW_LEFT;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(false call FUNC(gui_changeImage));
						};
						class GVAR(previewRight) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_PREVIEW_RIGHT;
							x = QUOTE(CTRL_X(19.2));
							y = QUOTE(CTRL_Y(2.8));
							w = QUOTE(CTRL_W(0.6));
							h = QUOTE(CTRL_H(0.6));
							text = ICON_ARROW_RIGHT;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(true call FUNC(gui_changeImage));
						};
						class GVAR(previewInfoGroup) : EGVAR(sdf,ControlsGroup) {
							idc = IDC_PREVIEW_INFO_GROUP;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(5.1));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(8.9));

							class Controls {
								class GVAR(previewInfo) : EGVAR(sdf,StructuredText) {
									idc = IDC_PREVIEW_INFO;
									x = QUOTE(CTRL_X(0));
									y = QUOTE(CTRL_Y(0));
									w = QUOTE(CTRL_W(6.8));
									h = QUOTE(CTRL_H(8.8));
								};
							};
						};
						class GVAR(selectionText) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(14));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(requestedItems);
						};
						class GVAR(selectionBG) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(15));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(5));
							colorBackground[] = {0,0,0,0.9};
						};
						class GVAR(selection) : EGVAR(sdf,ListNBox) {
							idc = IDC_SELECTION;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(15));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(5));
							columns[] = {0,0.9};
							onLBDblClick = QUOTE(call FUNC(gui_itemRemove));
						};
						class GVAR(objectLimit) : EGVAR(sdf,Text) {
							idc = IDC_OBJECT_LIMIT;
							x = QUOTE(CTRL_X(10));
							y = QUOTE(CTRL_Y(14));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
							text = "0/0";
							style = "0x01";
							colorBackground[] = {0,0,0,0};
						};
						class GVAR(objectLimitIcon) : EGVAR(sdf,Text) {
							idc = IDC_OBJECT_LIMIT_ICON;
							x = QUOTE(CTRL_X(11.9));
							y = QUOTE(CTRL_Y(14.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_SLINGLOAD;
							style = "0x30 + 0x800";
						};
						class GVAR(crewLimit) : EGVAR(sdf,Text) {
							idc = IDC_CREW_LIMIT;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(14));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
							text = "0/0";
							style = "0x01";
							colorBackground[] = {0,0,0,0};
						};
						class GVAR(crewLimitIcon) : EGVAR(sdf,Text) {
							idc = IDC_CREW_LIMIT_ICON;
							x = QUOTE(CTRL_X(14.9));
							y = QUOTE(CTRL_Y(14.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_GROUP;
							style = "0x30 + 0x800";
						};
						class GVAR(load) : EGVAR(sdf,Text) {
							idc = IDC_LOAD;
							x = QUOTE(CTRL_X(16));
							y = QUOTE(CTRL_Y(14));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
							text = "0/0";
							style = "0x01";
							colorBackground[] = {0,0,0,0};
						};
						class GVAR(loadIcon) : EGVAR(sdf,Text) {
							idc = IDC_LOAD_ICON;
							x = QUOTE(CTRL_X(17.9));
							y = QUOTE(CTRL_Y(14.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_BOX;
							style = "0x30 + 0x800";
						};
						class GVAR(clear) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_CLEAR;
							x = QUOTE(CTRL_X(18.9));
							y = QUOTE(CTRL_Y(14.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_TRASH;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(call FUNC(gui_clear));
						};
						class GVAR(gridText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(20));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,grid);
						};
						class GVAR(gridEastingText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_E_TEXT;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(20));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,easting);
						};
						class GVAR(gridEasting) : EGVAR(sdf,Editbox) {
							idc = IDC_GRID_E;
							x = QUOTE(CTRL_X(8));
							y = QUOTE(CTRL_Y(20));
							w = QUOTE(CTRL_W(5.5));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_grid));
						};
						class GVAR(gridNorthingText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_N_TEXT;
							x = QUOTE(CTRL_X(13.5));
							y = QUOTE(CTRL_Y(20));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,northing);
						};
						class GVAR(gridNorthing) : EGVAR(sdf,Editbox) {
							idc = IDC_GRID_N;
							x = QUOTE(CTRL_X(14.5));
							y = QUOTE(CTRL_Y(20));
							w = QUOTE(CTRL_W(5.5));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_grid));
						};
						class GVAR(signalsText) : EGVAR(sdf,Text) {
							idc = IDC_SIGNALS_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(21));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(landingSignals);
						};
						class GVAR(signal1) : EGVAR(sdf,Combobox) {
							idc = IDC_SIGNAL1;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(21));
							w = QUOTE(CTRL_W(6.5));
							h = QUOTE(CTRL_H(1));
							onLBSelChanged = QUOTE(call FUNC(gui_signals));

							class Items {
								class None {
									text = ECSTRING(common,NA);
									picture = "#(argb,8,8,3)color(0,0,0,0)";
									default = 1;
								};
								class BlueSmoke {
									text = ECSTRING(common,smokeBlue);
									picture = ICON_SMOKE_BLUE;
									data = "SmokeShellBlue";
								};
								class GreenSmoke {
									text = ECSTRING(common,smokeGreen);
									picture = ICON_SMOKE_GREEN;
									data = "SmokeShellGreen";
								};
								class RedSmoke {
									text = ECSTRING(common,smokeRed);
									picture = ICON_SMOKE_RED;
									data = "SmokeShellRed";
								};
								class YellowSmoke {
									text = ECSTRING(common,smokeYellow);
									picture = ICON_SMOKE_YELLOW;
									data = "SmokeShellYellow";
								};
								class BlueChemlight {
									text = ECSTRING(common,chemlightBlue);
									picture = ICON_CHEM_BLUE;
									data = "Chemlight_blue";
								};
								class GreenChemlight {
									text = ECSTRING(common,chemlightGreen);
									picture = ICON_CHEM_GREEN;
									data = "Chemlight_green";
								};
								class RedChemlight {
									text = ECSTRING(common,chemlightRed);
									picture = ICON_CHEM_RED;
									data = "Chemlight_red";
								};
								class YellowChemlight {
									text = ECSTRING(common,chemlightYellow);
									picture = ICON_CHEM_YELLOW;
									data = "Chemlight_yellow";
								};
								class IRStrobe {
									text = ECSTRING(common,IRStrobe);
									picture = ICON_IR;
									data = "B_IRStrobe";
								};
								class GreenFlare {
									text = ECSTRING(common,flareGreen);
									picture = ICON_FLARE_GREEN;
									data = "FlareGreen_F";
								};
								class RedFlare {
									text = ECSTRING(common,flareRed);
									picture = ICON_FLARE_RED;
									data = "FlareRed_F";
								};
								class YellowFlare {
									text = ECSTRING(common,flareYellow);
									picture = ICON_FLARE_YELLOW;
									data = "FlareYellow_F";
								};
							};
						};
						class GVAR(signal2) : GVAR(signal1) {
							idc = IDC_SIGNAL2;
							x = QUOTE(CTRL_X(13.5));
							w = QUOTE(CTRL_W(6.5));
						};
						class GVAR(aiHandlingText) : EGVAR(sdf,Text) {
							idc = IDC_AI_HANDLING_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(22));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(aiHandling);
						};
						class GVAR(aiHandling) : EGVAR(sdf,Toolbox) {
							idc = IDC_AI_HANDLING;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(22));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1));
							columns = 2;
							rows = 1;
							strings[] = {CSTRING(joinRequesterGroup),CSTRING(createStandaloneGroups)};
							tooltips[] = {"",""};
							onToolboxSelChanged = QUOTE(call FUNC(gui_aiHandling));
						};
					};
				};
			};
		};
	};
};

class GVAR(guiStation) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(call FUNC(guiStation));

	class ControlsBackground {
		COMMON_GUI_CONTROLS_BG;
	};

	class Controls {
		COMMON_GUI_CONTROLS {
			class Controls {
				class GVAR(itemsGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_ITEMS_GROUP;
					x = QUOTE(GD_W(0));
					y = QUOTE(GD_H(0));
					w = QUOTE(GD_W(20));
					h = QUOTE(GD_H(23));
					class Controls {
						class GVAR(dummy) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(0));
							h = QUOTE(CTRL_H(0));
						};
						class GVAR(itemsText) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(availableItems);
						};
						class GVAR(items) : EGVAR(sdf,Tree) {
							idc = IDC_ITEMS;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(13));
							sizeEx = QUOTE(GRID_H(1));
							onTreeSelChanged = QUOTE(call FUNC(guiStation_select));
							idcSearch = IDC_FIND;
						};
						class GVAR(findIcon) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(6));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_SEARCH;
							style = "0x30 + 0x800";
						};
						class GVAR(find) : EGVAR(sdf,Editbox) {
							idc = IDC_FIND;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(5.9));
							h = QUOTE(CTRL_H(0.9));
							text = "";
						};
						class GVAR(previewText) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(itemInfo);
						};
						class GVAR(previewBG) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(13));
							colorBackground[] = {0,0,0,0.9};
						};
						class GVAR(previewImage) : RscPictureKeepAspect {
							idc = IDC_PREVIEW_IMAGE;
							x = QUOTE(CTRL_X(13.1));
							y = QUOTE(CTRL_Y(1.1));
							w = QUOTE(CTRL_W(6.8));
							h = QUOTE(CTRL_H(4));
						};
						class GVAR(previewLeft) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_PREVIEW_LEFT;
							x = QUOTE(CTRL_X(13.2));
							y = QUOTE(CTRL_Y(2.8));
							w = QUOTE(CTRL_W(0.6));
							h = QUOTE(CTRL_H(0.6));
							text = ICON_ARROW_LEFT;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(false call FUNC(gui_changeImage));
						};
						class GVAR(previewRight) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_PREVIEW_RIGHT;
							x = QUOTE(CTRL_X(19.2));
							y = QUOTE(CTRL_Y(2.8));
							w = QUOTE(CTRL_W(0.6));
							h = QUOTE(CTRL_H(0.6));
							text = ICON_ARROW_RIGHT;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(true call FUNC(gui_changeImage));
						};
						class GVAR(previewInfoGroup) : EGVAR(sdf,ControlsGroup) {
							idc = IDC_PREVIEW_INFO_GROUP;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(5.1));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(8.9));

							class Controls {
								class GVAR(previewInfo) : EGVAR(sdf,StructuredText) {
									idc = IDC_PREVIEW_INFO;
									x = QUOTE(CTRL_X(0));
									y = QUOTE(CTRL_Y(0));
									w = QUOTE(CTRL_W(6.8));
									h = QUOTE(CTRL_H(8.8));
								};
							};
						};
						class GVAR(aiHandlingText) : EGVAR(sdf,Text) {
							idc = IDC_AI_HANDLING_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(14));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(aiHandling);
						};
						class GVAR(aiHandling) : EGVAR(sdf,Toolbox) {
							idc = IDC_AI_HANDLING;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(14));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1));
							columns = 2;
							rows = 1;
							strings[] = {CSTRING(joinRequesterGroup),CSTRING(createStandaloneGroups)};
							tooltips[] = {"",""};
							onToolboxSelChanged = QUOTE(call FUNC(gui_aiHandling));
						};
					};
				};
			};
		};
	};
};
