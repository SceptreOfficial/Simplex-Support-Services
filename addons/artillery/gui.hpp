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
					strings[] = {CSTRING(fireMission),CSTRING(relocation)};
					colorTextSelect[] = {0,0,0,1};
					colorSelectedBg[] = {1,1,1,0.7};
					onToolboxSelChanged = QUOTE(call FUNC(gui_tabs));
				};
				class GVAR(relocateBG) : EGVAR(sdf,Text) {
					idc = IDC_RELOCATE_BG;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y_BUFFER(1));
					w = QUOTE(CTRL_W(20));
					h = QUOTE(CTRL_H_BUFFER(1));
					colorBackground[] = {1,1,1,0.2};
				};
				class GVAR(relocateGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_RELOCATE_GROUP;
					x = QUOTE(GD_W(1));
					y = QUOTE(GD_H(1));
					w = QUOTE(GD_W(18));
					h = QUOTE(GD_H(10));

					class Controls {
						class GVAR(gridText) : EGVAR(sdf,Text) {
							idc = IDC_RELOCATE_GRID_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(6));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,grid);
						};
						class GVAR(gridEastingText) : EGVAR(sdf,Text) {
							idc = IDC_RELOCATE_GRID_E_TEXT;
							x = QUOTE(CTRL_X(6));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,easting);
						};
						class GVAR(gridEasting) : EGVAR(sdf,Editbox) {
							idc = IDC_RELOCATE_GRID_E;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(5));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_relocateGrid));
						};
						class GVAR(gridNorthingText) : EGVAR(sdf,Text) {
							idc = IDC_RELOCATE_GRID_N_TEXT;
							x = QUOTE(CTRL_X(12));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,northing);
						};
						class GVAR(gridNorthing) : EGVAR(sdf,Editbox) {
							idc = IDC_RELOCATE_GRID_N;
							x = QUOTE(CTRL_X(13));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(5));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_relocateGrid));
						};
					};
				};
				class GVAR(planGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_PLAN_GROUP;
					x = QUOTE(GD_W(0));
					y = QUOTE(GD_H(1));
					w = QUOTE(GD_W(20));
					h = QUOTE(GD_H(7));
					class Controls {
						class GVAR(planText) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(strikePlan);
						};
						class GVAR(remoteControl) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_REMOTE_CONTROL;
							x = QUOTE(CTRL_X(16));
							y = QUOTE(CTRL_Y(0.1));
							w = QUOTE(CTRL_W(3.9));
							h = QUOTE(CTRL_H(0.9));
							text = ECSTRING(common,remoteControl);
							onButtonClick = QUOTE(call FUNC(gui_remoteControl));
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
							columns[] = {0,0.2,0.4,0.7,0.8,0.9};
						};
						class GVAR(plan) : EGVAR(sdf,ListNBox) {
							idc = IDC_PLAN;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(4));
							columns[] = {0,0.2,0.4,0.7,0.8,0.9};
							onLBSelChanged = QUOTE(call FUNC(gui_plan));
						};
						class GVAR(add) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_ADD;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(6));
							w = QUOTE(CTRL_W(5));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(addTask);
							onButtonClick = QUOTE(call FUNC(gui_addTask));
						};
						class GVAR(remove) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_REMOVE;
							x = QUOTE(CTRL_X(5));
							y = QUOTE(CTRL_Y(6));
							w = QUOTE(CTRL_W(5));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(removeTask);
							onButtonClick = QUOTE(call FUNC(gui_removeTask));
						};
						class GVAR(clear) : EGVAR(sdf,ButtonSimple) {
							idc = IDC_CLEAR;
							x = QUOTE(CTRL_X(10));
							y = QUOTE(CTRL_Y(6));
							w = QUOTE(CTRL_W(5));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(clearAll);
							onButtonClick = QUOTE(call FUNC(gui_clearTasks));
						};
						class GVAR(planOptionsButton) : EGVAR(sdf,Button) {
							idc = IDC_PLAN_OPTIONS_BUTTON;
							x = QUOTE(CTRL_X(15));
							y = QUOTE(CTRL_Y(6));
							w = QUOTE(CTRL_W(5));
							h = QUOTE(CTRL_H(1));
							onButtonClick = QUOTE(0.1 call FUNC(gui_planOptions));
						};
					};
				};		
				class GVAR(planOptionsBG) : EGVAR(sdf,Text) {
					idc = IDC_PLAN_OPTIONS_BG;
					x = QUOTE(CTRL_X(0));
					y = QUOTE(CTRL_Y_BUFFER(8));
					w = QUOTE(CTRL_W(20));
					h = QUOTE(CTRL_H_BUFFER(8));
					colorBackground[] = {1,1,1,0.2};
				};
				class GVAR(planOptionsGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_PLAN_OPTIONS_GROUP;
					x = QUOTE(GD_W(1));
					y = QUOTE(GD_H(8));
					w = QUOTE(GD_W(18));
					h = QUOTE(GD_H(8));
						
					class Controls {
						class GVAR(loopCountText) : EGVAR(sdf,Text) {
							idc = IDC_LOOP_COUNT_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(6));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(loopCount);
						};
						class GVAR(loopCount) : EGVAR(sdf,Slider) {
							idc = IDC_LOOP_COUNT;
							x = QUOTE(CTRL_X(6));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(10));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(loopCountEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_LOOP_COUNT_EDIT;
							x = QUOTE(CTRL_X(16));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(loopDelayText) : EGVAR(sdf,Text) {
							idc = IDC_LOOP_DELAY_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(6));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(loopDelay);
						};
						class GVAR(loopDelay) : EGVAR(sdf,Slider) {
							idc = IDC_LOOP_DELAY;
							x = QUOTE(CTRL_X(6));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(10));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(loopDelayEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_LOOP_DELAY_EDIT;
							x = QUOTE(CTRL_X(16));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(coordinationText) : EGVAR(sdf,Text) {
							idc = IDC_COORDINATION_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(18));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(coordination);
						};
						class GVAR(coordinationBG) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(3));
							w = QUOTE(CTRL_W(18));
							h = QUOTE(CTRL_H(5));
							colorBackground[] = {0,0,0,0.9};
						};
						class GVAR(coordination) : EGVAR(sdf,ListNBoxCB) {
							idc = IDC_COORDINATION;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(3));
							w = QUOTE(CTRL_W(18));
							h = QUOTE(CTRL_H(5));
							columns[] = {0,0.08,0.16};
							onLBSelChanged = QUOTE(call FUNC(gui_coordination));
						};
					};
				};
				class GVAR(taskGroup) : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_TASK_GROUP;
					x = QUOTE(GD_W(0));
					y = QUOTE(GD_H(16));
					w = QUOTE(GD_W(20));
					h = QUOTE(GD_H(12));
						
					class Controls {
						class GVAR(gridText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,grid);
						};
						class GVAR(gridEastingText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_E_TEXT;
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
							w = QUOTE(CTRL_W(3));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_grid));
						};
						class GVAR(gridNorthingText) : EGVAR(sdf,Text) {
							idc = IDC_GRID_N_TEXT;
							x = QUOTE(CTRL_X(11));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = ECSTRING(common,northing);
						};
						class GVAR(gridNorthing) : EGVAR(sdf,Editbox) {
							idc = IDC_GRID_N;
							x = QUOTE(CTRL_X(12));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(3));
							h = QUOTE(CTRL_H(1));
							text = "00000";
							onKeyUp = QUOTE(call FUNC(gui_grid));
						};
						class GVAR(ETAText) : EGVAR(sdf,Text) {
							idc = IDC_ETA_TEXT;
							x = QUOTE(CTRL_X(15));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(eta);
						};
						class GVAR(ETA) : EGVAR(sdf,Text) {
							idc = IDC_ETA;
							x = QUOTE(CTRL_X(17));
							y = QUOTE(CTRL_Y(0));
							w = QUOTE(CTRL_W(3));
							h = QUOTE(CTRL_H(1));
							style = 0x02;
						};
						class GVAR(sheafText) : EGVAR(sdf,Text) {
							idc = IDC_SHEAF_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(sheafType);
						};
						class GVAR(sheaf) : EGVAR(sdf,Combobox) {
							idc = IDC_SHEAF;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(1));
							w = QUOTE(CTRL_W(13));
							h = QUOTE(CTRL_H(1));
							onLBSelChanged = QUOTE(call FUNC(gui_sheaf));
						};
						class GVAR(sheafParamsText) : EGVAR(sdf,Text) {
							idc = IDC_SHEAF_PARAMS_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(sheafParameters);
						};
						class GVAR(sheafWidthText) : EGVAR(sdf,Text) {
							idc = IDC_SHEAF_WIDTH_TEXT;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(widthAcronym);
						};
						class GVAR(sheafWidth) : EGVAR(sdf,Editbox) {
							idc = IDC_SHEAF_WIDTH;
							x = QUOTE(CTRL_X(8));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(3));
							h = QUOTE(CTRL_H(1));
							onKeyUp = QUOTE(call FUNC(gui_dimensions));
						};
						class GVAR(sheafHeightText) : EGVAR(sdf,Text) {
							idc = IDC_SHEAF_HEIGHT_TEXT;
							x = QUOTE(CTRL_X(11));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(1));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(heightAcronym);
						};
						class GVAR(sheafHeight) : EGVAR(sdf,Editbox) {
							idc = IDC_SHEAF_HEIGHT;
							x = QUOTE(CTRL_X(12));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(3));
							h = QUOTE(CTRL_H(1));
							onKeyUp = QUOTE(call FUNC(gui_dimensions));
						};
						class GVAR(sheafAngleText) : EGVAR(sdf,Text) {
							idc = IDC_SHEAF_ANGLE_TEXT;
							x = QUOTE(CTRL_X(15));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(angle);
						};
						class GVAR(sheafAngle) : EGVAR(sdf,Editbox) {
							idc = IDC_SHEAF_ANGLE;
							x = QUOTE(CTRL_X(17));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(3));
							h = QUOTE(CTRL_H(1));
							onKeyUp = QUOTE(call FUNC(gui_dimensions));
						};
						class GVAR(sheafDispersionText) : EGVAR(sdf,Text) {
							idc = IDC_SHEAF_DISPERSION_TEXT;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(4));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(dispersion);
						};
						class GVAR(sheafDispersion) : EGVAR(sdf,Slider) {
							idc = IDC_SHEAF_DISPERSION;
							x = QUOTE(CTRL_X(11));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(sheafDispersionEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_SHEAF_DISPERSION_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(2));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(ammunitionText) : EGVAR(sdf,Text) {
							idc = IDC_AMMUNITION_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(3));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(1.1));
							text = CSTRING(ammunition);
						};
						class GVAR(ammunitionBG) : EGVAR(sdf,Text) {
							idc = -1;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(4));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(5));
							colorBackground[] = {0,0,0,0.9};
						};
						class GVAR(ammunition) : EGVAR(sdf,ListNBoxMulti) {
							idc = IDC_AMMUNITION;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(4));
							w = QUOTE(CTRL_W(20));
							h = QUOTE(CTRL_H(5));
							columns[] = {0,0.1};
							onLBSelChanged = QUOTE(call FUNC(gui_ammunition));
						};
						class GVAR(roundsText) : EGVAR(sdf,Text) {
							idc = IDC_ROUNDS_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(9));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(rounds);
						};
						class GVAR(rounds) : EGVAR(sdf,Slider) {
							idc = IDC_ROUNDS;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(9));
							w = QUOTE(CTRL_W(11));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(roundsEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_ROUNDS_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(9));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(executionDelayText) : EGVAR(sdf,Text) {
							idc = IDC_EXECUTION_DELAY_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(10));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(executionDelay);
						};
						class GVAR(executionDelay) : EGVAR(sdf,Slider) {
							idc = IDC_EXECUTION_DELAY;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(10));
							w = QUOTE(CTRL_W(11));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(executionDelayEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_EXECUTION_DELAY_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(10));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(firingDelayText) : EGVAR(sdf,Text) {
							idc = IDC_FIRING_DELAY_TEXT;
							x = QUOTE(CTRL_X(0));
							y = QUOTE(CTRL_Y(11));
							w = QUOTE(CTRL_W(7));
							h = QUOTE(CTRL_H(1));
							text = CSTRING(firingDelay);
						};
						class GVAR(firingDelay) : EGVAR(sdf,Slider) {
							idc = IDC_FIRING_DELAY;
							x = QUOTE(CTRL_X(7));
							y = QUOTE(CTRL_Y(11));
							w = QUOTE(CTRL_W(11));
							h = QUOTE(CTRL_H(1));
						};
						class GVAR(firingDelayEdit) : EGVAR(sdf,Editbox) {
							idc = IDC_FIRING_DELAY_EDIT;
							x = QUOTE(CTRL_X(18));
							y = QUOTE(CTRL_Y(11));
							w = QUOTE(CTRL_W(2));
							h = QUOTE(CTRL_H(1));
						};
					};
				};
			};
		};
	};
};
