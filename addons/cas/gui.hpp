#include "\z\sss\addons\sdf\gui_macros.hpp"

DECLARE_COMMON_GUI_CLASSES;
class EGVAR(common,toggleDistribution);
class EGVAR(common,toggleAzimuth);

/*
class GVAR(guiBombing) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(call FUNC(guiBombing));

	class ControlsBackground {
		COMMON_GUI_CONTROLS_BG;
	};

	class Controls {
		COMMON_GUI_CONTROLS {
			class Controls {
				class GVAR(gridText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,grid);
				};
				class GVAR(gridEastingText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,easting);
				};
				class GVAR(gridEasting) : EGVAR(sdf,Editbox) {
					idc = IDC_GRID_E;
					x = QUOTE(CTRL_X(8));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
					text = "00000";
					onKeyUp = QUOTE(call FUNC(gui_grid));
				};
				class GVAR(gridNorthingText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(13.5));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,northing);
				};
				class GVAR(gridNorthing) : EGVAR(sdf,Editbox) {
					idc = IDC_GRID_N;
					x = QUOTE(CTRL_X(14.5));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
					text = "00000";
					onKeyUp = QUOTE(call FUNC(gui_grid));
				};
				class GVAR(altitudeText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(altitude);
				};
				class GVAR(altitude) : EGVAR(sdf,Slider) {
					idc = IDC_ALTITUDE;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(altitudeEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_ALTITUDE_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(ingressText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(ingressAzimuth);
				};
				class GVAR(ingress) : EGVAR(sdf,Toolbox) {
					idc = IDC_INGRESS;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					columns = 8;
					rows = 1;
					strings[] = {ECSTRING(common,dirN),ECSTRING(common,dirNE),ECSTRING(common,dirE),ECSTRING(common,dirSE),ECSTRING(common,dirS),ECSTRING(common,dirSW),ECSTRING(common,dirW),ECSTRING(common,dirNW)};
					values[] = {0,45,90,135,180,225,270,315};
					onToolBoxSelChanged = QUOTE(call FUNC(gui_ingress));
				};
				class GVAR(ingressSlider) : EGVAR(sdf,Slider) {
					idc = IDC_INGRESS_SLIDER;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
					tooltip = "~15°";
				};
				class GVAR(ingressSliderEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_INGRESS_SLIDER_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(ingressToggle) : EGVAR(common,toggleAzimuth) {
					idc = IDC_INGRESS_TOGGLE;
					x = QUOTE(CTRL_X(6));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(gui_ingress));
				};
				class GVAR(egressText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(egressAzimuth);
				};
				class GVAR(egress) : GVAR(ingress) {
					idc = IDC_EGRESS;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onToolBoxSelChanged = QUOTE(call FUNC(gui_egress));
				};
				class GVAR(egressSlider) : EGVAR(sdf,Slider) {
					idc = IDC_EGRESS_SLIDER;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
					tooltip = "~15°";
				};
				class GVAR(egressSliderEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_EGRESS_SLIDER_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(egressToggle) : EGVAR(common,toggleAzimuth) {
					idc = IDC_EGRESS_TOGGLE;
					x = QUOTE(CTRL_X(6));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(gui_egress));
				};
				class GVAR(spreadText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(linearSpread);
				};
				class GVAR(spread) : EGVAR(sdf,Slider) {
					idc = IDC_SPREAD;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(spreadEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_SPREAD_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(spacingText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(spacing);
				};
				class GVAR(spacing) : EGVAR(sdf,Slider) {
					idc = IDC_SPACING;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(spacingEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_SPACING_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(aircraftText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(aircraft);
				};
				class GVAR(aircraft) : EGVAR(sdf,Slider) {
					idc = IDC_AIRCRAFT;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(aircraftEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_AIRCRAFT_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(weaponText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(7));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(weapon);
				};
				class GVAR(weapon) : EGVAR(sdf,Combobox) {
					idc = IDC_WEAPON;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(7));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(gui_weapon));
				};
				class GVAR(intervalText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(dropInterval);
				};
				class GVAR(interval) : EGVAR(sdf,Slider) {
					idc = IDC_INTERVAL;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(intervalEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_INTERVAL_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
			};
		};
	};
};
*/

class GVAR(guiLoiter) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(call FUNC(guiLoiter));

	class ControlsBackground {
		COMMON_GUI_CONTROLS_BG;
	};

	class Controls {
		COMMON_GUI_CONTROLS {
			class Controls {
				class GVAR(gridText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,grid);
				};
				class GVAR(gridEastingText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,easting);
				};
				class GVAR(gridEasting) : EGVAR(sdf,Editbox) {
					idc = IDC_GRID_E;
					x = QUOTE(CTRL_X(8));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
					text = "00000";
					onKeyUp = QUOTE(call FUNC(gui_grid));
				};
				class GVAR(gridNorthingText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(13.5));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,northing);
				};
				class GVAR(gridNorthing) : EGVAR(sdf,Editbox) {
					idc = IDC_GRID_N;
					x = QUOTE(CTRL_X(14.5));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
					text = "00000";
					onKeyUp = QUOTE(call FUNC(gui_grid));
				};
				class GVAR(altitudeText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(altitude);
				};
				class GVAR(altitude) : EGVAR(sdf,Slider) {
					idc = IDC_ALTITUDE;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(altitudeEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_ALTITUDE_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(radiusText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(radius);
				};
				class GVAR(radius) : EGVAR(sdf,Slider) {
					idc = IDC_RADIUS;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(radiusEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_RADIUS_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(typeText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(loiterType);
				};
				class GVAR(type) : EGVAR(sdf,ToolboxLoiter) {
					idc = IDC_TYPE;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onToolBoxSelChanged = QUOTE(call FUNC(guiLoiter_type));
				};
				class GVAR(typeAlt) : GVAR(type) {
					idc = IDC_TYPE_ALT;
					columns = 3;
					strings[] = {ICON_CLOCKWISE,ICON_COUNTER_CLOCKWISE,ICON_HOVER};
					values[] = {0,1,2};
				};
				class GVAR(speedModeText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(speedMode);
				};
				class GVAR(speedMode) : EGVAR(sdf,Toolbox) {
					idc = IDC_SPEED_MODE;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					columns = 2;
					rows = 1;
					strings[] = {CSTRING(limited),CSTRING(normal)};
					onToolBoxSelChanged = QUOTE(call FUNC(gui_speedMode));
				};
				class GVAR(ingressText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(ingressAzimuth);
				};
				class GVAR(ingress) : EGVAR(sdf,Toolbox) {
					idc = IDC_INGRESS;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					columns = 9;
					rows = 1;
					strings[] = {ECSTRING(common,dirAuto),ECSTRING(common,dirN),ECSTRING(common,dirNE),ECSTRING(common,dirE),ECSTRING(common,dirSE),ECSTRING(common,dirS),ECSTRING(common,dirSW),ECSTRING(common,dirW),ECSTRING(common,dirNW)};
					values[] = {-1,0,45,90,135,180,225,270,315};
					onToolBoxSelChanged = QUOTE(call FUNC(gui_ingress));
				};
				class GVAR(ingressSlider) : EGVAR(sdf,Slider) {
					idc = IDC_INGRESS_SLIDER;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
					tooltip = "~15°";
				};
				class GVAR(ingressSliderEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_INGRESS_SLIDER_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(ingressToggle) : EGVAR(common,toggleAzimuth) {
					idc = IDC_INGRESS_TOGGLE;
					x = QUOTE(CTRL_X(6));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(gui_ingress));
				};
				class GVAR(egressText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(egressAzimuth);
				};
				class GVAR(egress) : GVAR(ingress) {
					idc = IDC_EGRESS;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onToolBoxSelChanged = QUOTE(call FUNC(gui_egress));
				};
				class GVAR(egressSlider) : EGVAR(sdf,Slider) {
					idc = IDC_EGRESS_SLIDER;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
					tooltip = "~15°";
				};
				class GVAR(egressSliderEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_EGRESS_SLIDER_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(egressToggle) : EGVAR(common,toggleAzimuth) {
					idc = IDC_EGRESS_TOGGLE;
					x = QUOTE(CTRL_X(6));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(gui_egress));
				};
				class GVAR(targetText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(7));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(target);
					tooltip = CSTRING(targetTooltip);
				};
				class GVAR(target) : EGVAR(sdf,Combobox) {
					idc = IDC_TARGET;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(7));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(gui_target));
				};
				class GVAR(targetDetail) : EGVAR(sdf,Combobox) {
					idc = IDC_TARGET_DETAIL;
					x = QUOTE(CTRL_X(14));
					y = QUOTE(CTRL_Y(7));
					w = QUOTE(CTRL_W(6));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(gui_target));

					class Items {
						class Any {
							text = ECSTRING(common,any);
							data = "";
							picture = ICON_GEAR;
							default = 1;
						};
						class White {
							text = ECSTRING(common,white);
							data = "WHITE";
							picture = ICON_SEARCH;
							colorPicture[] = {1,1,1,1};
						};
						class Black {
							text = ECSTRING(common,black);
							data = "BLACK";
							picture = ICON_SEARCH;
							colorPicture[] = {0.1,0.1,0.1,1};
						};
						class Red {
							text = ECSTRING(common,red);
							data = "RED";
							picture = ICON_SEARCH;
							colorPicture[] = {0.8438,0.1383,0.1353,1};
						};
						class Orange {
							text = ECSTRING(common,orange);
							data = "ORANGE";
							picture = ICON_SEARCH;
							colorPicture[] = {0.6697,0.2275,0.10053,1};
						};
						class Yellow {
							text = ECSTRING(common,yellow);
							data = "YELLOW";
							picture = ICON_SEARCH;
							colorPicture[] = {0.9883,0.8606,0.0719,1};
						};
						class Green {
							text = ECSTRING(common,green);
							data = "GREEN";
							picture = ICON_SEARCH;
							colorPicture[] = {0.2125,0.6258,0.4891,1};
						};
						class Blue {
							text = ECSTRING(common,blue);
							data = "BLUE";
							picture = ICON_SEARCH;
							colorPicture[] = {0.1183,0.1867,1,1};
						};
						class Purple {
							text = ECSTRING(common,purple);
							data = "PURPLE";
							picture = ICON_SEARCH;
							colorPicture[] = {0.4341,0.1388,0.4144,1};
						};
					};
				};
				class GVAR(dangerCloseText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(dangerClose);
				};
				class GVAR(dangerClose) : EGVAR(sdf,Toolbox) {
					idc = IDC_DANGER_CLOSE;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					columns = 2;
					rows = 1;
					strings[] = {ECSTRING(common,enable),ECSTRING(common,disable)};
					values[] = {1,0};
					onToolBoxSelChanged = QUOTE(call FUNC(gui_dangerClose));
				};
				class GVAR(spreadText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(9));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(spread);
				};
				class GVAR(spread) : EGVAR(sdf,Slider) {
					idc = IDC_SPREAD;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(9));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(spreadEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_SPREAD_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(9));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(weaponText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(weapon);
				};
				class GVAR(weapon) : EGVAR(sdf,Combobox) {
					idc = IDC_WEAPON;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(gui_weapon));
				};
				class GVAR(burstDurationText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(11));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(burstDuration);
				};
				class GVAR(burstDuration) : EGVAR(sdf,Slider) {
					idc = IDC_BURST_DURATION;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(11));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(burstDurationEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_BURST_DURATION_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(11));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(burstIntervalText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(12));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(burstCycleInterval);
					tooltip = CSTRING(burstCycleIntervalTooltip);
				};
				class GVAR(burstInterval) : EGVAR(sdf,Slider) {
					idc = IDC_BURST_INTERVAL;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(12));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(burstIntervalEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_BURST_INTERVAL_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(12));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(remoteControlHeader) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(13));
					w = QUOTE(CTRL_W(20));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(remoteControlHeader);
				};
				class GVAR(remoteControlBG) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y_BUFFER(14));
					w = QUOTE(CTRL_W(20));
					h = QUOTE(CTRL_H_BUFFER(1));
					colorBackground[] = {1,1,1,0.2};
				};
				class GVAR(remoteControlText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(1));
					y = QUOTE(CTRL_Y(14));
					w = QUOTE(CTRL_W(6));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(turretSelection);
				};
				class GVAR(remoteControlSelect) : EGVAR(sdf,Combobox) {
					idc = IDC_REMOTE_CONTROL_SELECT;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(14));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(guiLoiter_remoteControlSelect));
				};
				class GVAR(remoteControl) : EGVAR(sdf,ButtonSimple) {
					idc = IDC_REMOTE_CONTROL;
					x = QUOTE(CTRL_X(14));
					y = QUOTE(CTRL_Y(14));
					w = QUOTE(CTRL_W(5));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,remoteControl);
					onButtonClick = QUOTE(call FUNC(guiLoiter_remoteControl));
				};
			};
		};
	};
};

class GVAR(guiStrafe) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(call FUNC(guiStrafe));

	class ControlsBackground {
		COMMON_GUI_CONTROLS_BG;
	};

	class Controls {
		COMMON_GUI_CONTROLS {
			class Controls {
				class GVAR(gridText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,grid);
				};
				class GVAR(gridEastingText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,easting);
				};
				class GVAR(gridEasting) : EGVAR(sdf,Editbox) {
					idc = IDC_GRID_E;
					x = QUOTE(CTRL_X(8));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
					text = "00000";
					onKeyUp = QUOTE(call FUNC(gui_grid));
				};
				class GVAR(gridNorthingText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(13.5));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					text = ECSTRING(common,northing);
				};
				class GVAR(gridNorthing) : EGVAR(sdf,Editbox) {
					idc = IDC_GRID_N;
					x = QUOTE(CTRL_X(14.5));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
					text = "00000";
					onKeyUp = QUOTE(call FUNC(gui_grid));
				};
				class GVAR(altitudeText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(altitude);
				};
				class GVAR(altitude) : EGVAR(sdf,Slider) {
					idc = IDC_ALTITUDE;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(altitudeEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_ALTITUDE_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(1));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(rangeText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(firingRange);
					tooltip = CSTRING(firingRangeTooltip);
				};
				class GVAR(range) : EGVAR(sdf,Slider) {
					idc = IDC_RANGE;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(rangeEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_RANGE_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(2));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(ingressText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(ingressAzimuth);
				};
				class GVAR(ingress) : EGVAR(sdf,Toolbox) {
					idc = IDC_INGRESS;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					columns = 9;
					rows = 1;
					strings[] = {ECSTRING(common,dirAuto),ECSTRING(common,dirN),ECSTRING(common,dirNE),ECSTRING(common,dirE),ECSTRING(common,dirSE),ECSTRING(common,dirS),ECSTRING(common,dirSW),ECSTRING(common,dirW),ECSTRING(common,dirNW)};
					values[] = {-1,0,45,90,135,180,225,270,315};
					onToolBoxSelChanged = QUOTE(call FUNC(gui_ingress));
				};
				class GVAR(ingressSlider) : EGVAR(sdf,Slider) {
					idc = IDC_INGRESS_SLIDER;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
					tooltip = "~15°";
				};
				class GVAR(ingressSliderEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_INGRESS_SLIDER_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(ingressToggle) : EGVAR(common,toggleAzimuth) {
					idc = IDC_INGRESS_TOGGLE;
					x = QUOTE(CTRL_X(6));
					y = QUOTE(CTRL_Y(3));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(gui_ingress));
				};
				class GVAR(egressText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(egressAzimuth);
				};
				class GVAR(egress) : GVAR(ingress) {
					idc = IDC_EGRESS;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onToolBoxSelChanged = QUOTE(call FUNC(gui_egress));
				};
				class GVAR(egressSlider) : EGVAR(sdf,Slider) {
					idc = IDC_EGRESS_SLIDER;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
					tooltip = "~15°";
				};
				class GVAR(egressSliderEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_EGRESS_SLIDER_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(egressToggle) : EGVAR(common,toggleAzimuth) {
					idc = IDC_EGRESS_TOGGLE;
					x = QUOTE(CTRL_X(6));
					y = QUOTE(CTRL_Y(4));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(gui_egress));
				};
				class GVAR(targetText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(target);
					tooltip = CSTRING(targetTooltip);
				};
				class GVAR(target) : EGVAR(sdf,Combobox) {
					idc = IDC_TARGET;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(gui_target));
				};
				class GVAR(targetDetail) : EGVAR(sdf,Combobox) {
					idc = IDC_TARGET_DETAIL;
					x = QUOTE(CTRL_X(14));
					y = QUOTE(CTRL_Y(5));
					w = QUOTE(CTRL_W(6));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(gui_target));

					class Items {
						class Any {
							text = ECSTRING(common,any);
							data = "";
							picture = ICON_GEAR;
							default = 1;
						};
						class White {
							text = ECSTRING(common,white);
							data = "WHITE";
							picture = ICON_SEARCH;
							colorPicture[] = {1,1,1,1};
						};
						class Black {
							text = ECSTRING(common,black);
							data = "BLACK";
							picture = ICON_SEARCH;
							colorPicture[] = {0.1,0.1,0.1,1};
						};
						class Red {
							text = ECSTRING(common,red);
							data = "RED";
							picture = ICON_SEARCH;
							colorPicture[] = {0.8438,0.1383,0.1353,1};
						};
						class Orange {
							text = ECSTRING(common,orange);
							data = "ORANGE";
							picture = ICON_SEARCH;
							colorPicture[] = {0.6697,0.2275,0.10053,1};
						};
						class Yellow {
							text = ECSTRING(common,yellow);
							data = "YELLOW";
							picture = ICON_SEARCH;
							colorPicture[] = {0.9883,0.8606,0.0719,1};
						};
						class Green {
							text = ECSTRING(common,green);
							data = "GREEN";
							picture = ICON_SEARCH;
							colorPicture[] = {0.2125,0.6258,0.4891,1};
						};
						class Blue {
							text = ECSTRING(common,blue);
							data = "BLUE";
							picture = ICON_SEARCH;
							colorPicture[] = {0.1183,0.1867,1,1};
						};
						class Purple {
							text = ECSTRING(common,purple);
							data = "PURPLE";
							picture = ICON_SEARCH;
							colorPicture[] = {0.4341,0.1388,0.4144,1};
						};
					};
				};
				class GVAR(spreadText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(linearSpread);
				};
				class GVAR(spread) : EGVAR(sdf,Slider) {
					idc = IDC_SPREAD;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(11));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(spreadEdit) : EGVAR(sdf,Editbox) {
					idc = IDC_SPREAD_EDIT;
					x = QUOTE(CTRL_X(18));
					y = QUOTE(CTRL_Y(6));
					w = QUOTE(CTRL_W(2));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(primaryText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(7));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(primaryWeapon);
				};
				class GVAR(primary) : EGVAR(sdf,Combobox) {
					idc = IDC_PRIMARY;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(7));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(guiStrafe_pylon));
				};
				class GVAR(primaryRateText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(primaryRateControl);
				};
				class GVAR(primaryDistributionBG) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(primaryDistribution) : EGVAR(common,toggleDistribution) {
					idc = IDC_PRIMARY_DISTRIBUTION;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(guiStrafe_distribution));
					tooltip = CSTRING(distribution);
				};
				class GVAR(primaryQuantity) : EGVAR(sdf,Editbox) {
					idc = IDC_PRIMARY_QUANTITY;
					x = QUOTE(CTRL_X(8));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(primaryIntervalBG) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(13.5));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(primaryIntervalIcon) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(13.55));
					y = QUOTE(CTRL_Y(8.05));
					w = QUOTE(CTRL_W(0.9));
					h = QUOTE(CTRL_H(0.9));
					text = ICON_TRIGGER_INTERVAL;
					style = "48 + 2048";
					tooltip = CSTRING(triggerInterval);
				};
				class GVAR(primaryInterval) : EGVAR(sdf,Editbox) {
					idc = IDC_PRIMARY_INTERVAL;
					x = QUOTE(CTRL_X(14.5));
					y = QUOTE(CTRL_Y(8));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(secondaryText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(9));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(secondaryWeapon);
				};
				class GVAR(secondary) : EGVAR(sdf,Combobox) {
					idc = IDC_SECONDARY;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(9));
					w = QUOTE(CTRL_W(13));
					h = QUOTE(CTRL_H(1));
					onLBSelChanged = QUOTE(call FUNC(guiStrafe_pylon));
				};
				class GVAR(secondaryRateText) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(7));
					h = QUOTE(CTRL_H(1));
					text = CSTRING(secondaryRateControl);
				};
				class GVAR(secondaryDistributionBG) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(secondaryDistribution) : EGVAR(common,toggleDistribution) {
					idc = IDC_SECONDARY_DISTRIBUTION;
					x = QUOTE(CTRL_X(7));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
					onCheckedChanged = QUOTE(call FUNC(guiStrafe_distribution));
					tooltip = CSTRING(distribution);
				};
				class GVAR(secondaryQuantity) : EGVAR(sdf,Editbox) {
					idc = IDC_SECONDARY_QUANTITY;
					x = QUOTE(CTRL_X(8));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(secondaryIntervalBG) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(13.5));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(1));
					h = QUOTE(CTRL_H(1));
				};
				class GVAR(secondaryIntervalIcon) : EGVAR(sdf,Text) {
					idc = -1;
					x = QUOTE(CTRL_X(13.55));
					y = QUOTE(CTRL_Y(10.05));
					w = QUOTE(CTRL_W(0.9));
					h = QUOTE(CTRL_H(0.9));
					text = ICON_TRIGGER_INTERVAL;
					style = "48 + 2048";
					tooltip = CSTRING(triggerInterval);
				};
				class GVAR(secondaryInterval) : EGVAR(sdf,Editbox) {
					idc = IDC_SECONDARY_INTERVAL;
					x = QUOTE(CTRL_X(14.5));
					y = QUOTE(CTRL_Y(10));
					w = QUOTE(CTRL_W(5.5));
					h = QUOTE(CTRL_H(1));
				};
			};
		};
	};
};
