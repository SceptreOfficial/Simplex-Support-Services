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
				class GVAR(tabs) : EGVAR(sdf,Toolbox) {
					idc = IDC_TABS;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y(0));
					w = QUOTE(CTRL_W(20));
					h = QUOTE(CTRL_H(1));
					rows = 1;
					columns = 2;
					strings[] = {CSTRING(planner),CSTRING(confirmations)};
					colorTextSelect[] = {0,0,0,1};
					colorSelectedBg[] = {1,1,1,0.7};
					onToolboxSelChanged = QUOTE(call FUNC(gui_tabs));
				};
				class GVAR(confirmationsBG) : EGVAR(sdf,Text) {
					idc = IDC_CONFIRMATIONS_BG;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y_BUFFER(1));
					w = QUOTE(CTRL_W(20));
					h = QUOTE(CTRL_H_BUFFER(1));
					colorBackground[] = {1,1,1,0.2};
				};
				class GVAR(confirmationsGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_CONFIRMATIONS_GROUP;
					x = QUOTE(GD_W(1));
					y = QUOTE(GD_H(1));
					w = QUOTE(GD_W(18));
					h = QUOTE(GD_H(10));
				};
				class GVAR(planGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_PLAN_GROUP;
					x = QUOTE(GD_W(0));
					y = QUOTE(GD_H(1));
					w = QUOTE(GD_W(20));
					h = QUOTE(GD_H(6));
					class Controls {
						class GVAR(dummy) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(0));
							h = QUOTE(CTRL_H(0));
						};
						class GVAR(planText) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(waypoints);
						};
						class GVAR(planBG) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(5));
							colorBackground[] = {0,0,0,0.9};
						};
						class GVAR(planHeader) : EGVAR(sdf,ListNBox) {
							idc = IDC_PLAN_HEADER;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(1) + BUFFER_H);
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(1));
							columns[] = {0,0.4,0.8};
						};
						class GVAR(plan) : EGVAR(sdf,ListNBox) {
							idc = IDC_PLAN;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(4));
							columns[] = {0,0.4,0.8};
							onLBSelChanged = QUOTE(call FUNC(gui_plan));
						};
						class GVAR(remoteControl) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_REMOTE_CONTROL;
							x = QUOTE(CTRL_X(6));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(3.9));
							h = QUOTE(CTRL_H(0.9));
							text = ECSTRING(common,remoteControl);
							onButtonClick = QUOTE(call FUNC(gui_remoteControl));
						};
						class GVAR(add) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_ADD;
							x = QUOTE(CTRL_X(9.9));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_PLUS;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(call FUNC(gui_addTask));
						};
						class GVAR(remove) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_REMOVE;
							x = QUOTE(CTRL_X(10.9));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_MINUS;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(call FUNC(gui_removeTask));
						};
						class GVAR(clear) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_CLEAR;
							x = QUOTE(CTRL_X(11.9));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(0.9));
							text = ICON_TRASH;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(call FUNC(gui_clearTasks));
						};
						class GVAR(planLogic) : EGVAR(sdf,Toolbox) {
							idc = IDC_PLAN_LOGIC;
							x = QUOTE(CTRL_X(12.9));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(0.9));
							rows = 1;
							columns = 2;
							strings[] = {CSTRING(append),CSTRING(overwrite)};
							onToolboxSelChanged = QUOTE(GVAR(planLogic) = _this select 1);
						};
					};
				};
				class GVAR(taskGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_TASK_GROUP;
					x = QUOTE(GD_W(0));
					y = QUOTE(GD_H(7));
					w = QUOTE(GD_W(20));
					h = QUOTE(GD_H(9));
						
					class Controls {
						class GVAR(taskText) : EGVAR(sdf,Text) {
							idc = IDC_TASK_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(task);
						};
						class GVAR(RTB) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RTB;
							x = QUOTE(CTRL_X(6));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(0.9));
							h = QUOTE(CTRL_H(0.8));
							text = ICON_HOME_PATHING;
							style = "0x30 + 0x800";
							onButtonClick = QUOTE(call FUNC(gui_rtb));
						};
						class GVAR(task) : EGVAR(sdf,Combobox) {
							idc = IDC_TASK;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1));
							onLBSelChanged = QUOTE(call FUNC(gui_task));
						};
						class GVAR(gridText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,grid);
						};
						class GVAR(gridEastingText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_E_TEXT;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,easting);
						};
						class GVAR(gridEasting) : EGVAR(sdf,Editbox) {
							idc = IDC_GRID_E;
							x = QUOTE(CTRL_X(8));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(5.5));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_grid));
						};
						class GVAR(gridNorthingText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_N_TEXT;
							x = QUOTE(CTRL_X(13.5));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,northing);
						};
						class GVAR(gridNorthing) : EGVAR(sdf,Editbox) {
							idc = IDC_GRID_N;
							x = QUOTE(CTRL_X(14.5));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(5.5));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_grid));
						};
						class GVAR(timeoutText) : EGVAR(sdf,Text) {
							idc = IDC_TIMEOUT_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(timeout);
						};
						class GVAR(timeout) : EGVAR(sdf,Slider) {
							idc = IDC_TIMEOUT;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(11));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(timeoutEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_TIMEOUT_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(speedText) : EGVAR(sdf,Text) {
							idc = IDC_SPEED_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(3));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(speedLimit);
						};
						class GVAR(speed) : EGVAR(sdf,Slider) {
							idc = IDC_SPEED;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(3));
							w = QUOTE(CTRL_W(11));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(speedEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_SPEED_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(3));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(combatModeText) : EGVAR(sdf,Text) {
							idc = IDC_COMBAT_MODE_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(4));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(combatMode);
						};
						class GVAR(combatMode) : EGVAR(sdf,Combobox) {
							idc = IDC_COMBAT_MODE;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(4));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1));

							class Items {
								class Blue {
									text = CSTRING(combatModeBlue);
									data = "BLUE";
									tooltip = CSTRING(combatModeBlueTooltip);
								};
								class Green {
									text = CSTRING(combatModeGreen);
									data = "GREEN";
									tooltip = CSTRING(combatModeGreenTooltip);
									default = 1;
								};
								class White {
									text = CSTRING(combatModeWhite);
									data = "WHITE";
									tooltip = CSTRING(combatModeWhiteTooltip);
								};
								class Yellow {
									text = CSTRING(combatModeYellow);
									data = "YELLOW";
									tooltip = CSTRING(combatModeYellowTooltip);
								};
								class Red {
									text = CSTRING(combatModeRed);
									data = "RED";
									tooltip = CSTRING(combatModeRedTooltip);
								};
							};
						};
						class GVAR(lightsText) : EGVAR(sdf,Text) {
							idc = IDC_LIGHTS_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(5));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(lights);
						};
						class GVAR(lights) : EGVAR(sdf,Toolbox) {
							idc = IDC_LIGHTS;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(5));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1));
							rows = 1;
							columns = 2;
							strings[] = {ECSTRING(common,off),ECSTRING(common,on)};
						};
						class GVAR(collisionLightsText) : EGVAR(sdf,Text) {
							idc = IDC_COLLISION_LIGHTS_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(6));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(collisionLights);
						};
						class GVAR(collisionLights) : EGVAR(sdf,Toolbox) {
							idc = IDC_COLLISION_LIGHTS;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(6));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1));
							rows = 1;
							columns = 2;
							strings[] = {ECSTRING(common,off),ECSTRING(common,on)};
						};
						class GVAR(altitudeATLText) : EGVAR(sdf,Text) {
							idc = IDC_ALTITUDE_ATL_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(7));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(altitudeATL);
						};
						class GVAR(altitudeATL) : EGVAR(sdf,Slider) {
							idc = IDC_ALTITUDE_ATL;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(7));
							w = QUOTE(CTRL_W(11));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(altitudeATLEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_ALTITUDE_ATL_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(7));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(altitudeASLText) : EGVAR(sdf,Text) {
							idc = IDC_ALTITUDE_ASL_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(8));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(altitudeASL);
						};
						class GVAR(altitudeASL) : EGVAR(sdf,Slider) {
							idc = IDC_ALTITUDE_ASL;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(8));
							w = QUOTE(CTRL_W(11));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(altitudeASLEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_ALTITUDE_ASL_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(8));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
					};
				};
			};
		};
	};
};
