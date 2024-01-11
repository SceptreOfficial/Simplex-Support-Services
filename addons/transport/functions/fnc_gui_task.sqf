#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_ctrlTask","_index"];

private _display = ctrlParent _ctrlTask;
private _ctrlPlan = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;
private _ctrlTaskGroup = ctrlParentControlsGroup _ctrlTask;
private _task = _ctrlTask lbData _index;
private _vehicle = PVAR(guiEntity) getVariable [QPVAR(vehicle),objNull];
private _isAircraft = (PVAR(guiEntity) getVariable QPVAR(supportType)) in ["HELICOPTER","PLANE","VTOL"];
private _groupHeight = [7,9] select _isAircraft;
private _controls = [];

[{
	params ["_ctrlTaskGroup","_isAircraft"];
	
	{
		private _ctrl = _ctrlTaskGroup controlsGroupCtrl _x;

		if (_isAircraft) then {
			_ctrl ctrlShow true;
			_ctrl ctrlSetPosition (_ctrl getVariable [QGVAR(ctrlPosition),ctrlPosition _ctrl]);
			_ctrl ctrlCommit 0;
		} else {
			_ctrl ctrlShow false;

			if (isNil {_ctrl getVariable QGVAR(ctrlPosition)}) then {
				_ctrl setVariable [QGVAR(ctrlPosition),ctrlPosition _ctrl];
			};
			
			_ctrl ctrlSetPosition [0,0,0,0];
			_ctrl ctrlCommit 0;
		};
	} forEach [
		IDC_ALTITUDE_ATL_TEXT,
		IDC_ALTITUDE_ATL,
		IDC_ALTITUDE_ATL_EDIT,
		IDC_ALTITUDE_ASL_TEXT,
		IDC_ALTITUDE_ASL,
		IDC_ALTITUDE_ASL_EDIT
	];
},[_ctrlTaskGroup,_isAircraft]] call CBA_fnc_execNextFrame;

{ctrlDelete _x} forEach (_ctrlTaskGroup getVariable QGVAR(taskSpecificControls));

private _item = GVAR(plan) # GVAR(planIndex);

if (_item get "task" != _task) then {
	_item = createHashMapFromArray [
		["task",_task],
		["posASL",_item get "posASL"],
		["behaviors",+(_item get "behaviors")],
		["timeout",_item get "timeout"]
	];

	GVAR(plan) set [GVAR(planIndex),_item];
};

_ctrlPlan lnbSetText [[GVAR(planIndex),0],GVAR(taskNames) get _task];
_ctrlPlan lnbSetPicture [[GVAR(planIndex),0],GVAR(taskIcons) get _task];

(_ctrlTaskGroup controlsGroupCtrl IDC_TIMEOUT) ctrlEnable (_task != "HOLD");
(_ctrlTaskGroup controlsGroupCtrl IDC_TIMEOUT_EDIT) ctrlEnable (_task != "HOLD");
(_ctrlTaskGroup controlsGroupCtrl IDC_SPEED) ctrlEnable (_task != "LOITER");
(_ctrlTaskGroup controlsGroupCtrl IDC_SPEED_EDIT) ctrlEnable (_task != "LOITER");

switch _task do {
	case "RTB" : {
		[_display displayCtrl IDC_MAP,[[[PVAR(guiEntity) getVariable QPVAR(base)]],[],[],0]] call EFUNC(sdf,setValueData);
	};
	case "MOVE" : {};
	case "PATH" : {
		// Some sort of point planner?
	};
	case "FOLLOW" : {
		// Friendly vehicle & unit selection
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(5)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(target);

		private _ctrlBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlBG ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(5)];
		_ctrlBG ctrlCommit 0;
		_ctrlBG ctrlSetBackgroundColor [0,0,0,0.9];

		private _ctrlList = _display ctrlCreate [QEGVAR(sdf,ListNBox),-1,_ctrlTaskGroup];
		_ctrlList ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(5)];
		_ctrlList ctrlCommit 0;
		_ctrlList lnbSetColumnsPos [0,0.05,0.75];

		[_ctrlList,"LBSelChanged",{
			params ["_ctrlList","_index"];
			GVAR(plan) # GVAR(planIndex) set ["attachedObject",_ctrlList getVariable [str _index,objNull]];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		private _listUpdate = [_ctrlList,{
			params ["_ctrlList"];

			private _vehicle = PVAR(guiEntity) getVariable QPVAR(vehicle);
			private _side = PVAR(guiEntity) getVariable QPVAR(side);
			private _selected = GVAR(plan) # GVAR(planIndex) getOrDefault ["attachedObject",objNull];
			private _index = -1;

			lnbClear _ctrlList;

			private _pos = ASLtoATL (GVAR(plan) # GVAR(planIndex) get "posASL");

			{
				if (alive _x &&
					_vehicle != _x &&
					{[_side,side _x] call BIS_fnc_sideIsFriendly} &&
					{!(_x isKindOf "Animal")} &&
					{_x distance2D _pos < 150}
				) then {
					private _row = _ctrlList lnbAddRow ["",getText (configOf _x >> "displayName"),groupID group _x];
					_ctrlList lnbSetTextRight [[_row,1],["",name _x] select (_x isKindOf "CAManBase")];
					_ctrlList lnbSetPicture [[_row,0],_x call EFUNC(common,getIcon)];
					_ctrlList setVariable [str _row,_x];

					if (_x == _selected) then {_index = _row};
				};
			} forEach (_pos nearEntities 500);

			_ctrlList lnbSetCurSelRow _index;
		}];

		(_listUpdate # 0) call (_listUpdate # 1);

		_display setVariable [QGVAR(followListUpdate),_listUpdate];

		_controls append [_ctrlText,_ctrlBG,_ctrlList];
		_groupHeight = _groupHeight + 5;
	};
	case "HOLD" : {};
	case "LAND" : {
		// Engine toolbox
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(engine);

		parsingNamespace setVariable [QEGVAR(sdf,toolboxRows),1];
		parsingNamespace setVariable [QEGVAR(sdf,toolboxColumns),2];
		private _ctrl = _display ctrlCreate [QEGVAR(sdf,Toolbox),-1,_ctrlTaskGroup];
		_ctrl ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(1)];
		_ctrl ctrlCommit 0;
		_ctrl lbAdd LELSTRING(common,off);
		_ctrl lbAdd LELSTRING(common,on);
		_ctrl lbSetCurSel parseNumber (_item getOrDefault ["engine",true]);

		[_ctrl,"ToolBoxSelChanged",{
			params ["_ctrl","_index"];
			GVAR(plan) # GVAR(planIndex) set ["engine",_index == 1];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		_controls append [_ctrlText,_ctrl];
		_groupHeight = _groupHeight + 1;

		// Final azimuth slider
		_controls append ([_groupHeight,LLSTRING(finalAzimuth),[-1,360,0],-1,"endDir","°",[[-1,"AUTO"]]] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Approach slider
		_controls append ([_groupHeight,LLSTRING(approach),[10,600,0],150,"approach",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "LANDSIGNAL" : {
		// Engine toolbox
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(engine);

		parsingNamespace setVariable [QEGVAR(sdf,toolboxRows),1];
		parsingNamespace setVariable [QEGVAR(sdf,toolboxColumns),2];
		private _ctrl = _display ctrlCreate [QEGVAR(sdf,Toolbox),-1,_ctrlTaskGroup];
		_ctrl ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(1)];
		_ctrl ctrlCommit 0;
		_ctrl lbAdd LELSTRING(common,off);
		_ctrl lbAdd LELSTRING(common,on);
		_ctrl lbSetCurSel parseNumber (_item getOrDefault ["engine",true]);

		[_ctrl,"ToolBoxSelChanged",{
			params ["_ctrl","_index"];
			GVAR(plan) # GVAR(planIndex) set ["engine",_index == 1];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		_groupHeight = _groupHeight + 1;
		_controls append [_ctrlText,_ctrl];

		// Signal type combo
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(signalType);

		private _ctrl = _display ctrlCreate [QEGVAR(sdf,Combobox),-1,_ctrlTaskGroup];
		_ctrl ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(1)];
		_ctrl ctrlCommit 0;

		[_ctrl,"LBSelChanged",{
			params ["_ctrl","_index"];
			GVAR(plan) # GVAR(planIndex) set ["signalType",["ANY","SMOKE","IR","FLARE"] # _index];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		{
			private _index = _ctrl lbAdd (_x # 0);
			_ctrl lbSetPicture [_index,_x # 1];
		} forEach [
			["Anything",ICON_SEARCH],
			["Smoke",ICON_SMOKE],
			["IR strobe",ICON_IR],
			["Flare",ICON_FLARE]
		];

		_ctrl lbSetCurSel (["ANY","SMOKE","IR","FLARE"] find (_item getOrDefault ["signalType","ANY"]));

		_groupHeight = _groupHeight + 1;
		_controls append [_ctrlText,_ctrl];

		// Search radius slider
		_controls append ([_groupHeight,LLSTRING(searchRadius),[50,800,0],500,"searchRadius",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Search timeout slider
		_controls append ([_groupHeight,LLSTRING(searchTimeout),[30,600,0],300,"searchTimeout",LELSTRING(common,secondAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "HOVER" : {
		// Hover height slider
		_controls append ([_groupHeight,LLSTRING(hoverHeight),[0,2000,0],15,"hoverHeight",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Final azimuth slider
		_controls append ([_groupHeight,LLSTRING(finalAzimuth),[-1,360,0],-1,"endDir","°",[[-1,"AUTO"]]] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Approach slider
		_controls append ([_groupHeight,LLSTRING(approach),[10,600,0],150,"approach",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "FASTROPE" : {
		// Hover height slider
		_controls append ([_groupHeight,LLSTRING(hoverHeight),[10,30,0],15,"hoverHeight",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Final azimuth slider
		_controls append ([_groupHeight,LLSTRING(finalAzimuth),[-1,360,0],-1,"endDir","°",[[-1,"AUTO"]]] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Approach slider
		_controls append ([_groupHeight,LLSTRING(approach),[10,600,0],150,"approach",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Ejections
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(5)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(ejections);

		private _ctrlCBText1 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText1 ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(6.5),CTRL_H(1)];
		_ctrlCBText1 ctrlCommit 0;
		_ctrlCBText1 ctrlSetText LLSTRING(allPlayers);

		private _ctrlCBText2 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText2 ctrlSetPosition [CTRL_X(13.5),CTRL_Y(_groupHeight),CTRL_W(6.5),CTRL_H(1)];
		_ctrlCBText2 ctrlCommit 0;
		_ctrlCBText2 ctrlSetText LLSTRING(allAI);
		
		private _ctrlCB1 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB1 ctrlSetPosition [CTRL_X(12.5),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB1 ctrlCommit 0;

		private _ctrlCB2 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB2 ctrlSetPosition [CTRL_X(19),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB2 ctrlCommit 0;

		_groupHeight = _groupHeight + 1;

		private _ctrlBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlBG ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlBG ctrlCommit 0;
		_ctrlBG ctrlSetBackgroundColor [0,0,0,0.9];

		private _ctrlList = _display ctrlCreate [QEGVAR(sdf,ListNBoxCB),-1,_ctrlTaskGroup];
		_ctrlList ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlList ctrlCommit 0;
		_ctrlList lnbSetColumnsPos [0,0.08,0.6];

		private _ctrlOverlay = _display ctrlCreate [QEGVAR(sdf,TextCentered),-1,_ctrlTaskGroup];
		_ctrlOverlay ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlOverlay ctrlCommit 0;
		_ctrlOverlay ctrlSetText LELSTRING(common,NA);
		_ctrlOverlay ctrlSetTextColor [1,1,1,0.5];
		_ctrlOverlay ctrlSetFontHeight GD_H(1.5);
		_ctrlOverlay ctrlSetBackgroundColor [0.2,0.2,0.2,0.5];

		[_ctrlList,"LBSelChanged",{
			params ["_ctrlList","_index"];

			private _item = _ctrlList getVariable [str _index,objNull];
			private _selected = GVAR(plan) # GVAR(planIndex) getOrDefault ["ejections",[]];

			if (_ctrlList lnbPicture [_index,0] == ICON_CHECKED2) then {
				_ctrlList lnbSetPicture [[_index,0],ICON_UNCHECKED2];
				_selected deleteAt (_selected find _item);
			} else {
				_ctrlList lnbSetPicture [[_index,0],ICON_CHECKED2];
				_selected pushBackUnique _item;
			};

			GVAR(plan) # GVAR(planIndex) set ["ejections",_selected - [objNull]];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		private _thisArgs = [_ctrlCB1,_ctrlCB2,_ctrlList,_ctrlOverlay];
		private _fnc_listUpdate = {
			_thisArgs params ["_ctrlCB1","_ctrlCB2","_ctrlList","_ctrlOverlay"];

			private _vehicle = PVAR(guiEntity) getVariable [QPVAR(vehicle),objNull];

			[cbChecked _ctrlCB1,cbChecked _ctrlCB2] params ["_players","_ai"];

			GVAR(plan) # GVAR(planIndex) set ["ejectTypes",[_players,_ai]];

			// for some reason overlay isn't hidden on menu load
			[{
				params ["_ctrlList","_ctrlOverlay","_showList"];
				_ctrlList ctrlEnable _showList;
				_ctrlList ctrlShow _showList;
				_ctrlOverlay ctrlShow !_showList;
			},[_ctrlList,_ctrlOverlay,!(_players && _ai)]] call CBA_fnc_execNextFrame;
			
			lnbClear _ctrlList;
			private _items = [];
			private _selected = GVAR(plan) # GVAR(planIndex) getOrDefault ["ejections",[]];

			{
				private _isPlayer = isPlayer _x;
				
				if (alive _x && {(_isPlayer && !_players) || (!_isPlayer && !_ai)}) then {
					private _row = _ctrlList lnbAddRow ["",name _x,groupID group _x,["AI","PLAYER"] select _isPlayer];
					_ctrlList lnbSetPicture [[_row,0],[ICON_UNCHECKED2,ICON_CHECKED2] select (_x in _selected)];
					_ctrlList setVariable [str _row,_x];
					_items pushBack _x;
				};
			} forEach SECONDARY_CREW(_vehicle);
			
			GVAR(plan) # GVAR(planIndex) set ["ejections",_items arrayIntersect _selected - [objNull]];
			call FUNC(gui_verify);
		};

		[_ctrlCB1,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;
		[_ctrlCB2,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;

		private _ejectTypes = _item getOrDefault ["ejectTypes",[true,true]];
		_ctrlCB1 cbSetChecked (_ejectTypes # 0);
		_ctrlCB2 cbSetChecked (_ejectTypes # 1);

		call _fnc_listUpdate;

		_groupHeight = _groupHeight + 4;
		_controls append [_ctrlText,_ctrlCBText1,_ctrlCBText2,_ctrlCB1,_ctrlCB2,_ctrlBG,_ctrlList,_ctrlOverlay];
	};
	case "HELOCAST" : {
		// Drift height slider
		_controls append ([_groupHeight,LLSTRING(hoverHeight),[0,50,0],1,"hoverHeight",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Drift speed slider
		_controls append ([_groupHeight,LLSTRING(hoverSpeed),[0,10,1],1,"hoverSpeed","m/s"] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Final azimuth slider
		_controls append ([_groupHeight,LLSTRING(finalAzimuth),[-1,360,0],-1,"endDir","°",[[-1,LELSTRING(common,dirAuto)]]] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Approach slider
		_controls append ([_groupHeight,LLSTRING(approach),[10,600,0],150,"approach",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "LOITER" : {
		// Loiter type toolbox
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(direction);

		private _ctrl = _display ctrlCreate [QEGVAR(sdf,ToolboxLoiter),-1,_ctrlTaskGroup];
		_ctrl ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(1)];
		_ctrl ctrlCommit 0;
		_ctrl lbSetCurSel (["CIRCLE","CIRCLE_L"] find (_item getOrDefault ["loiterType","CIRCLE_L"]));

		[_ctrl,"ToolBoxSelChanged",{
			params ["_ctrl","_index"];
			GVAR(plan) # GVAR(planIndex) set ["loiterType",["CIRCLE","CIRCLE_L"] select _index];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		_groupHeight = _groupHeight + 1;
		_controls append [_ctrlText,_ctrl];

		// Loiter radius slider
		_controls append ([_groupHeight,LLSTRING(radius),[100,800,0],200,"loiterRadius",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "SLINGLOADPICKUP" : {
		// Friendly vehicle & unit selection
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,TextCentered),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(20),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(slingloadInfo);

		_controls append [_ctrlText];
		_groupHeight = _groupHeight + 1;
	};
	case "SLINGLOADDROPOFF" : {};
	case "UNLOAD" : {
		// Ejections
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(5)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(ejections);

		private _ctrlCBText1 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText1 ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(4.33),CTRL_H(1)];
		_ctrlCBText1 ctrlCommit 0;
		_ctrlCBText1 ctrlSetText LLSTRING(allPlayers);

		private _ctrlCBText2 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText2 ctrlSetPosition [CTRL_X(11.33),CTRL_Y(_groupHeight),CTRL_W(4.33),CTRL_H(1)];
		_ctrlCBText2 ctrlCommit 0;
		_ctrlCBText2 ctrlSetText LLSTRING(allAI);

		private _ctrlCBText3 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText3 ctrlSetPosition [CTRL_X(15.66),CTRL_Y(_groupHeight),CTRL_W(4.33),CTRL_H(1)];
		_ctrlCBText3 ctrlCommit 0;
		_ctrlCBText3 ctrlSetText LLSTRING(allCargo);

		private _ctrlCB1 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB1 ctrlSetPosition [CTRL_X(10.33),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB1 ctrlCommit 0;

		private _ctrlCB2 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB2 ctrlSetPosition [CTRL_X(14.66),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB2 ctrlCommit 0;

		private _ctrlCB3 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB3 ctrlSetPosition [CTRL_X(18.99),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB3 ctrlCommit 0;

		_groupHeight = _groupHeight + 1;

		private _ctrlBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlBG ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlBG ctrlCommit 0;
		_ctrlBG ctrlSetBackgroundColor [0,0,0,0.9];

		private _ctrlList = _display ctrlCreate [QEGVAR(sdf,ListNBoxCB),-1,_ctrlTaskGroup];
		_ctrlList ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlList ctrlCommit 0;
		_ctrlList lnbSetColumnsPos [0,0.08,0.45,0.8];

		private _ctrlOverlay = _display ctrlCreate [QEGVAR(sdf,TextCentered),-1,_ctrlTaskGroup];
		_ctrlOverlay ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlOverlay ctrlCommit 0;
		_ctrlOverlay ctrlSetText LELSTRING(common,NA);
		_ctrlOverlay ctrlSetTextColor [1,1,1,0.5];
		_ctrlOverlay ctrlSetFontHeight GD_H(1.5);
		_ctrlOverlay ctrlSetBackgroundColor [0.2,0.2,0.2,0.5];

		[_ctrlList,"LBSelChanged",{
			params ["_ctrlList","_index"];

			private _item = _ctrlList getVariable [str _index,objNull];
			private _selected = GVAR(plan) # GVAR(planIndex) getOrDefault ["ejections",[]];

			if (_ctrlList lnbPicture [_index,0] == ICON_CHECKED2) then {
				_ctrlList lnbSetPicture [[_index,0],ICON_UNCHECKED2];
				_selected deleteAt (_selected find _item);
			} else {
				_ctrlList lnbSetPicture [[_index,0],ICON_CHECKED2];
				_selected pushBackUnique _item;
			};

			GVAR(plan) # GVAR(planIndex) set ["ejections",_selected - [objNull]];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		private _thisArgs = [_ctrlCB1,_ctrlCB2,_ctrlCB3,_ctrlList,_ctrlOverlay];
		private _fnc_listUpdate = {
			_thisArgs params ["_ctrlCB1","_ctrlCB2","_ctrlCB3","_ctrlList","_ctrlOverlay"];

			private _vehicle = PVAR(guiEntity) getVariable [QPVAR(vehicle),objNull];

			[cbChecked _ctrlCB1,cbChecked _ctrlCB2,cbChecked _ctrlCB3] params ["_players","_ai","_cargo"];

			GVAR(plan) # GVAR(planIndex) set ["ejectTypes",[_players,_ai,_cargo]];

			// for some reason overlay isn't hidden on menu load
			[{
				params ["_ctrlList","_ctrlOverlay","_showList"];
				_ctrlList ctrlEnable _showList;
				_ctrlList ctrlShow _showList;
				_ctrlOverlay ctrlShow !_showList;
			},[_ctrlList,_ctrlOverlay,!(_players && _ai && _cargo)]] call CBA_fnc_execNextFrame;

			lnbClear _ctrlList;
			private _items = [];
			private _selected = GVAR(plan) # GVAR(planIndex) getOrDefault ["ejections",[]];

			if (!_cargo) then {
				{
					private _row = _ctrlList lnbAddRow ["",getText (configOf _x >> "displayName"),"","CARGO"];
					_ctrlList lnbSetPicture [[_row,0],[ICON_UNCHECKED2,ICON_CHECKED2] select (_x in _selected)];
					_ctrlList lnbSetPicture [[_row,1],_x call EFUNC(common,getIcon)];
					_ctrlList setVariable [str _row,_x];
					_items pushBack _x;
				} forEach getVehicleCargo _vehicle;
			};

			{
				private _isPlayer = isPlayer _x;
				
				if (alive _x && {(_isPlayer && !_players) || (!_isPlayer && !_ai)}) then {
					private _row = _ctrlList lnbAddRow ["",name _x,groupID group _x,["AI","PLAYER"] select _isPlayer];
					_ctrlList lnbSetPicture [[_row,0],[ICON_UNCHECKED2,ICON_CHECKED2] select (_x in _selected)];
					_ctrlList setVariable [str _row,_x];
					_items pushBack _x;
				};
			} forEach SECONDARY_CREW(_vehicle);

			GVAR(plan) # GVAR(planIndex) set ["ejections",_items arrayIntersect _selected - [objNull]];
			call FUNC(gui_verify);
		};

		[_ctrlCB1,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;
		[_ctrlCB2,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;
		[_ctrlCB3,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;

		private _ejectTypes = _item getOrDefault ["ejectTypes",[true,true,true]];
		_ctrlCB1 cbSetChecked (_ejectTypes # 0);
		_ctrlCB2 cbSetChecked (_ejectTypes # 1);
		_ctrlCB3 cbSetChecked (_ejectTypes # 2);

		call _fnc_listUpdate;

		_groupHeight = _groupHeight + 4;
		_controls append [_ctrlText,_ctrlCBText1,_ctrlCBText2,_ctrlCBText3,_ctrlCB1,_ctrlCB2,_ctrlCB3,_ctrlBG,_ctrlList,_ctrlOverlay];

		// Ejection interval
		_controls append ([_groupHeight,LLSTRING(ejectInterval),[0,5,1],OPTION(ejectInterval),"ejectInterval",LELSTRING(common,secondAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "PARADROP" : {
		// Ejections
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(5)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(ejections);

		private _ctrlCBText1 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText1 ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(4.33),CTRL_H(1)];
		_ctrlCBText1 ctrlCommit 0;
		_ctrlCBText1 ctrlSetText LLSTRING(allPlayers);

		private _ctrlCBText2 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText2 ctrlSetPosition [CTRL_X(11.33),CTRL_Y(_groupHeight),CTRL_W(4.33),CTRL_H(1)];
		_ctrlCBText2 ctrlCommit 0;
		_ctrlCBText2 ctrlSetText LLSTRING(allAI);

		private _ctrlCBText3 = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlCBText3 ctrlSetPosition [CTRL_X(15.66),CTRL_Y(_groupHeight),CTRL_W(4.33),CTRL_H(1)];
		_ctrlCBText3 ctrlCommit 0;
		_ctrlCBText3 ctrlSetText LLSTRING(allCargo);

		private _ctrlCB1 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB1 ctrlSetPosition [CTRL_X(10.33),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB1 ctrlCommit 0;

		private _ctrlCB2 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB2 ctrlSetPosition [CTRL_X(14.66),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB2 ctrlCommit 0;

		private _ctrlCB3 = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlTaskGroup];
		_ctrlCB3 ctrlSetPosition [CTRL_X(18.99),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlCB3 ctrlCommit 0;

		_groupHeight = _groupHeight + 1;

		private _ctrlBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlBG ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlBG ctrlCommit 0;
		_ctrlBG ctrlSetBackgroundColor [0,0,0,0.9];

		private _ctrlList = _display ctrlCreate [QEGVAR(sdf,ListNBoxCB),-1,_ctrlTaskGroup];
		_ctrlList ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlList ctrlCommit 0;
		_ctrlList lnbSetColumnsPos [0,0.08,0.45,0.8];

		private _ctrlOverlay = _display ctrlCreate [QEGVAR(sdf,TextCentered),-1,_ctrlTaskGroup];
		_ctrlOverlay ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(4)];
		_ctrlOverlay ctrlCommit 0;
		_ctrlOverlay ctrlSetText LELSTRING(common,NA);
		_ctrlOverlay ctrlSetTextColor [1,1,1,0.5];
		_ctrlOverlay ctrlSetFontHeight GD_H(1.5);
		_ctrlOverlay ctrlSetBackgroundColor [0.2,0.2,0.2,0.5];

		[_ctrlList,"LBSelChanged",{
			params ["_ctrlList","_index"];

			private _item = _ctrlList getVariable [str _index,objNull];
			private _selected = GVAR(plan) # GVAR(planIndex) getOrDefault ["ejections",[]];

			if (_ctrlList lnbPicture [_index,0] == ICON_CHECKED2) then {
				_ctrlList lnbSetPicture [[_index,0],ICON_UNCHECKED2];
				_selected deleteAt (_selected find _item);
			} else {
				_ctrlList lnbSetPicture [[_index,0],ICON_CHECKED2];
				_selected pushBackUnique _item;
			};

			GVAR(plan) # GVAR(planIndex) set ["ejections",_selected - [objNull]];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		private _thisArgs = [_ctrlCB1,_ctrlCB2,_ctrlCB3,_ctrlList,_ctrlOverlay];
		private _fnc_listUpdate = {
			_thisArgs params ["_ctrlCB1","_ctrlCB2","_ctrlCB3","_ctrlList","_ctrlOverlay"];

			private _vehicle = PVAR(guiEntity) getVariable [QPVAR(vehicle),objNull];

			[cbChecked _ctrlCB1,cbChecked _ctrlCB2,cbChecked _ctrlCB3] params ["_players","_ai","_cargo"];

			GVAR(plan) # GVAR(planIndex) set ["ejectTypes",[_players,_ai,_cargo]];

			// for some reason overlay isn't hidden on menu load
			[{
				params ["_ctrlList","_ctrlOverlay","_showList"];
				_ctrlList ctrlEnable _showList;
				_ctrlList ctrlShow _showList;
				_ctrlOverlay ctrlShow !_showList;
			},[_ctrlList,_ctrlOverlay,!(_players && _ai && _cargo)]] call CBA_fnc_execNextFrame;

			lnbClear _ctrlList;
			private _items = [];
			private _selected = GVAR(plan) # GVAR(planIndex) getOrDefault ["ejections",[]];

			if (!_cargo) then {
				{
					private _row = _ctrlList lnbAddRow ["",getText (configOf _x >> "displayName"),"","CARGO"];
					_ctrlList lnbSetPicture [[_row,0],[ICON_UNCHECKED2,ICON_CHECKED2] select (_x in _selected)];
					_ctrlList lnbSetPicture [[_row,1],_x call EFUNC(common,getIcon)];
					_ctrlList setVariable [str _row,_x];
					_items pushBack _x;
				} forEach getVehicleCargo _vehicle;
			};

			{
				private _isPlayer = isPlayer _x;
				
				if (alive _x && {(_isPlayer && !_players) || (!_isPlayer && !_ai)}) then {
					private _row = _ctrlList lnbAddRow ["",name _x,groupID group _x,["AI","PLAYER"] select _isPlayer];
					_ctrlList lnbSetPicture [[_row,0],[ICON_UNCHECKED2,ICON_CHECKED2] select (_x in _selected)];
					_ctrlList setVariable [str _row,_x];
					_items pushBack _x;
				};
			} forEach SECONDARY_CREW(_vehicle);

			GVAR(plan) # GVAR(planIndex) set ["ejections",_items arrayIntersect _selected - [objNull]];
			call FUNC(gui_verify);
		};

		[_ctrlCB1,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;
		[_ctrlCB2,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;
		[_ctrlCB3,"CheckedChanged",_fnc_listUpdate,_thisArgs] call CBA_fnc_addBISEventHandler;

		private _ejectTypes = _item getOrDefault ["ejectTypes",[true,true,true]];
		_ctrlCB1 cbSetChecked (_ejectTypes # 0);
		_ctrlCB2 cbSetChecked (_ejectTypes # 1);
		_ctrlCB3 cbSetChecked (_ejectTypes # 2);

		call _fnc_listUpdate;

		_groupHeight = _groupHeight + 4;
		_controls append [_ctrlText,_ctrlCBText1,_ctrlCBText2,_ctrlCBText3,_ctrlCB1,_ctrlCB2,_ctrlCB3,_ctrlBG,_ctrlList,_ctrlOverlay];

		// Ejection interval
		_controls append ([_groupHeight,LLSTRING(ejectInterval),[0,5,1],OPTION(ejectInterval),"ejectInterval",LELSTRING(common,secondAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Open altitude
		_controls append ([_groupHeight,LLSTRING(parachuteDeployHeight),[50,2000,0],150,"openAltitude",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "SAD" : {};
	case "STRAFE" : {
		// Target
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(target);

		private _ctrlTarget = _display ctrlCreate [QEGVAR(sdf,Combobox),-1,_ctrlTaskGroup];
		_ctrlTarget ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlTarget ctrlCommit 0;
		_ctrlTarget ctrlSetTooltip LLSTRING(targetTooltip);

		private _ctrlTargetDetail = _display ctrlCreate [QEGVAR(sdf,Combobox),-1,_ctrlTaskGroup];
		_ctrlTargetDetail ctrlSetPosition [CTRL_X(14),CTRL_Y(_groupHeight),CTRL_W(6),CTRL_H(1)];
		_ctrlTargetDetail ctrlCommit 0;

		{
			_ctrlTarget lbAdd (_x # 0);
			_ctrlTarget lbSetPicture [_forEachIndex,_x # 1];
			_ctrlTarget lbSetData [_forEachIndex,_x # 2];
		} forEach [
			[LLSTRING(targetMap),ICON_MAP,"MAP"],
			[LLSTRING(targetLaser),ICON_LASER,"LASER"],
			[LLSTRING(targetSmoke),ICON_SMOKE,"SMOKE"],
			[LLSTRING(targetIRStrobe),ICON_IR,"IR"],
			[LLSTRING(targetFlare),ICON_FLARE,"FLARE"]
		];

		{
			_ctrlTargetDetail lbAdd (_x # 0);
			_ctrlTargetDetail lbSetPicture [_forEachIndex,_x # 1];
			_ctrlTargetDetail lbSetPictureColor [_forEachIndex,_x # 2];
			_ctrlTargetDetail lbSetData [_forEachIndex,_x # 3];
		} forEach [
			[LELSTRING(common,any),ICON_GEAR,[1,1,1,1],""],
			[LELSTRING(common,white),ICON_SEARCH,[1,1,1,1],"WHITE"],
			[LELSTRING(common,black),ICON_SEARCH,[0.1,0.1,0.1,1],"BLACK"],
			[LELSTRING(common,red),ICON_SEARCH,[0.8438,0.1383,0.1353,1],"RED"],
			[LELSTRING(common,orange),ICON_SEARCH,[0.6697,0.2275,0.10053,1],"ORANGE"],
			[LELSTRING(common,yellow),ICON_SEARCH,[0.9883,0.8606,0.0719,1],"YELLOW"],
			[LELSTRING(common,green),ICON_SEARCH,[0.2125,0.6258,0.4891,1],"GREEN"],
			[LELSTRING(common,blue),ICON_SEARCH,[0.1183,0.1867,1,1],"BLUE"],
			[LELSTRING(common,purple),ICON_SEARCH,[0.4341,0.1388,0.4144,1],"PURPLE"]
		];
		
		[_ctrlTarget,"LBSelChanged",{
			params ["_ctrlTarget","_index"];

			private _type = _ctrlTarget lbData _index;

			if (_type in ["SMOKE","FLARE"]) then {
				GVAR(plan) # GVAR(planIndex) set ["target",_type + ":" + (_thisArgs lbData lbCurSel _thisArgs)];
				_thisArgs ctrlEnable true;
			} else {
				GVAR(plan) # GVAR(planIndex) set ["target",_type];
				_thisArgs ctrlEnable false;
			};

			call FUNC(gui_verify);
		},_ctrlTargetDetail] call CBA_fnc_addBISEventHandler;

		[_ctrlTargetDetail,"LBSelChanged",{
			params ["_ctrlTargetDetail","_index"];

			private _type = _thisArgs lbData lbCurSel _thisArgs;
			GVAR(plan) # GVAR(planIndex) set ["target",_type + ":" + (_ctrlTargetDetail lbData _index)];

			call FUNC(gui_verify);
		},_ctrlTarget] call CBA_fnc_addBISEventHandler;

		((_item getOrDefault ["target","MAP"]) splitString ":") params ["_type",["_typeDetail",""]];

		_ctrlTargetDetail lbSetCurSel (["","WHITE","BLACK","RED","ORANGE","YELLOW","GREEN","BLUE","PURPLE"] find _typeDetail);
		_ctrlTarget lbSetCurSel (["MAP","LASER","SMOKE","IR","FLARE"] find _type);

		_groupHeight = _groupHeight + 1;
		_controls append [_ctrlText,_ctrlTarget,_ctrlTargetDetail];

		// Linear spread slider
		_controls append ([_groupHeight,LLSTRING(linearSpread),[0,150,0],0,"spread",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Primary
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(primaryWeapon);

		private _ctrl1 = _display ctrlCreate [QEGVAR(sdf,Combobox),-1,_ctrlTaskGroup];
		_ctrl1 ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(1)];
		_ctrl1 ctrlCommit 0;
		
		[_ctrl1,"LBSelChanged",{
			params ["_ctrl","_index"];
			GVAR(plan) # GVAR(planIndex) set ["pylon1",(_ctrl lbData _index) call EFUNC(common,parseArray)];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		_groupHeight = _groupHeight + 1;
		_controls append [_ctrlText,_ctrl1];

		// Rate control
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(primaryRateControl);

		private _ctrlDistributionBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlDistributionBG ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlDistributionBG ctrlCommit 0;

		private _ctrlDistribution = _display ctrlCreate [QEGVAR(common,toggleDistribution),-1,_ctrlTaskGroup];
		_ctrlDistribution ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlDistribution ctrlCommit 0;

		private _ctrlQuantity = _display ctrlCreate [QEGVAR(sdf,Editbox),-1,_ctrlTaskGroup];
		_ctrlQuantity ctrlSetPosition [CTRL_X(8),CTRL_Y(_groupHeight),CTRL_W(5.5),CTRL_H(1)];
		_ctrlQuantity ctrlCommit 0;

		private _ctrlIntervalBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlIntervalBG ctrlSetPosition [CTRL_X(13.5),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlIntervalBG ctrlCommit 0;

		private _ctrlIntervalIcon = _display ctrlCreate ["RscPictureKeepAspect",-1,_ctrlTaskGroup];
		_ctrlIntervalIcon ctrlSetPosition [CTRL_X(13.55),CTRL_Y((_groupHeight + 0.05)),CTRL_W(0.9),CTRL_H(0.9)];
		_ctrlIntervalIcon ctrlCommit 0;
		_ctrlIntervalIcon ctrlSetText ICON_TRIGGER_INTERVAL;

		private _ctrlInterval = _display ctrlCreate [QEGVAR(sdf,Editbox),-1,_ctrlTaskGroup];
		_ctrlInterval ctrlSetPosition [CTRL_X(14.5),CTRL_Y(_groupHeight),CTRL_W(5.5),CTRL_H(1)];
		_ctrlInterval ctrlCommit 0;

		[_ctrlInterval,GVAR(plan) # GVAR(planIndex) getOrDefault ["interval1",0],{
			params ["_ctrl","_value"];
			GVAR(plan) # GVAR(planIndex) set ["interval1",_value];
			call FUNC(gui_verify);
		},LELSTRING(common,secondAcronym)] call EFUNC(sdf,manageNumberbox);

		private _fnc_distribution = {
			params ["_ctrl"];
			GVAR(plan) # GVAR(planIndex) set ["distribution1",cbChecked _ctrl];
			[_ctrl getVariable QGVAR(ctrlQuantity),GVAR(plan) # GVAR(planIndex) getOrDefault ["quantity1",0],{
				params ["_ctrl","_value"];
				GVAR(plan) # GVAR(planIndex) set ["quantity1",_value];
				call FUNC(gui_verify);
			},["",LELSTRING(common,secondAcronym)] select (cbChecked _ctrl)] call EFUNC(sdf,manageNumberbox);
			call FUNC(gui_verify);
		};

		_ctrlDistribution setVariable [QGVAR(ctrlQuantity),_ctrlQuantity];
		[_ctrlDistribution,"CheckedChanged",_fnc_distribution] call CBA_fnc_addBISEventHandler;

		_ctrlDistribution cbSetChecked (_item getOrDefault ["distribution1",false]);
		[_fnc_distribution,_ctrlDistribution] call CBA_fnc_execNextFrame;

		_controls append [_ctrlText,_ctrlDistributionBG,_ctrlDistribution,_ctrlQuantity,_ctrlIntervalBG,_ctrlIntervalIcon,_ctrlInterval];
		_groupHeight = _groupHeight + 1;

		// Secondary
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(secondaryWeapon);

		private _ctrl2 = _display ctrlCreate [QEGVAR(sdf,Combobox),-1,_ctrlTaskGroup];
		_ctrl2 ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(1)];
		_ctrl2 ctrlCommit 0;
		
		[_ctrl2,"LBSelChanged",{
			params ["_ctrl","_index"];
			GVAR(plan) # GVAR(planIndex) set ["pylon2",(_ctrl lbData _index) call EFUNC(common,parseArray)];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		_groupHeight = _groupHeight + 1;
		_controls append [_ctrlText,_ctrl2];

		// Rate control
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(secondaryRateControl);

		private _ctrlDistributionBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlDistributionBG ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlDistributionBG ctrlCommit 0;

		private _ctrlDistribution = _display ctrlCreate [QEGVAR(common,toggleDistribution),-1,_ctrlTaskGroup];
		_ctrlDistribution ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlDistribution ctrlCommit 0;

		private _ctrlQuantity = _display ctrlCreate [QEGVAR(sdf,Editbox),-1,_ctrlTaskGroup];
		_ctrlQuantity ctrlSetPosition [CTRL_X(8),CTRL_Y(_groupHeight),CTRL_W(5.5),CTRL_H(1)];
		_ctrlQuantity ctrlCommit 0;

		private _ctrlIntervalBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlIntervalBG ctrlSetPosition [CTRL_X(13.5),CTRL_Y(_groupHeight),CTRL_W(1),CTRL_H(1)];
		_ctrlIntervalBG ctrlCommit 0;

		private _ctrlIntervalIcon = _display ctrlCreate ["RscPictureKeepAspect",-1,_ctrlTaskGroup];
		_ctrlIntervalIcon ctrlSetPosition [CTRL_X(13.55),CTRL_Y((_groupHeight + 0.05)),CTRL_W(0.9),CTRL_H(0.9)];
		_ctrlIntervalIcon ctrlCommit 0;
		_ctrlIntervalIcon ctrlSetText ICON_TRIGGER_INTERVAL;

		private _ctrlInterval = _display ctrlCreate [QEGVAR(sdf,Editbox),-1,_ctrlTaskGroup];
		_ctrlInterval ctrlSetPosition [CTRL_X(14.5),CTRL_Y(_groupHeight),CTRL_W(5.5),CTRL_H(1)];
		_ctrlInterval ctrlCommit 0;

		[_ctrlInterval,GVAR(plan) # GVAR(planIndex) getOrDefault ["interval2",0],{
			params ["_ctrl","_value"];
			GVAR(plan) # GVAR(planIndex) set ["interval2",_value];
			call FUNC(gui_verify);
		},LELSTRING(common,secondAcronym)] call EFUNC(sdf,manageNumberbox);

		private _fnc_distribution = {
			params ["_ctrl"];
			GVAR(plan) # GVAR(planIndex) set ["distribution2",cbChecked _ctrl];
			[_ctrl getVariable QGVAR(ctrlQuantity),GVAR(plan) # GVAR(planIndex) getOrDefault ["quantity2",0],{
				params ["_ctrl","_value"];
				GVAR(plan) # GVAR(planIndex) set ["quantity2",_value];
				call FUNC(gui_verify);
			},["",LELSTRING(common,secondAcronym)] select (cbChecked _ctrl)] call EFUNC(sdf,manageNumberbox);
			call FUNC(gui_verify);
		};

		_ctrlDistribution setVariable [QGVAR(ctrlQuantity),_ctrlQuantity];
		[_ctrlDistribution,"CheckedChanged",_fnc_distribution] call CBA_fnc_addBISEventHandler;

		_ctrlDistribution cbSetChecked (_item getOrDefault ["distribution2",false]);
		[_fnc_distribution,_ctrlDistribution] call CBA_fnc_execNextFrame;

		_controls append [_ctrlText,_ctrlDistributionBG,_ctrlDistribution,_ctrlQuantity,_ctrlIntervalBG,_ctrlIntervalIcon,_ctrlInterval];
		_groupHeight = _groupHeight + 1;

		// Select weapons
		_ctrl2 lbAdd "NONE";

		_vehicle call EFUNC(common,getPylonSelections) params ["_validPylons","_formatPylons"];

		private _pylon1 = _item getOrDefault ["pylon1",[]];
		private _pylon2 = _item getOrDefault ["pylon2",[]];

		if (_pylon1 isEqualTo [] || {!(_pylon1 in _validPylons)}) then {
			_pylon1 = _validPylons param [0,[]];
		};

		if (_pylon2 isEqualTo []) then {
			_ctrl2 lbSetCurSel 0;
		};

		{
			_x params ["_pylon","_weaponName","_magazineName","_turretName"];

			private _index1 = _ctrl1 lbAdd _weaponName;
			_ctrl1 lbSetData [_index1,str _pylon];
			_ctrl1 lbSetTextRight [_index1,_magazineName];
			_ctrl1 lbSetTooltip [_index1,_turretName];
			if (_pylon1 isEqualTo _pylon) then {_ctrl1 lbSetCurSel _index1};
			
			private _index2 = _ctrl2 lbAdd _weaponName;
			_ctrl2 lbSetData [_index2,str _pylon];
			_ctrl2 lbSetTextRight [_index2,_magazineName];
			_ctrl2 lbSetTooltip [_index2,_turretName];
			if (_pylon2 isEqualTo _pylon) then {_ctrl2 lbSetCurSel _index2};
		} forEach _formatPylons;
	};
	case "FIRE" : {
		// Weapon selection
		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_groupHeight),CTRL_W(7),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(weapon);

		private _ctrl = _display ctrlCreate [QEGVAR(sdf,Combobox),-1,_ctrlTaskGroup];
		_ctrl ctrlSetPosition [CTRL_X(7),CTRL_Y(_groupHeight),CTRL_W(13),CTRL_H(1)];
		_ctrl ctrlCommit 0;

		[_ctrl,"LBSelChanged",{
			params ["_ctrl","_index"];
			GVAR(plan) # GVAR(planIndex) set ["weapon",(_ctrl lbData _index) call EFUNC(common,parseArray)];
			call FUNC(gui_verify);
		}] call CBA_fnc_addBISEventHandler;

		_vehicle call EFUNC(common,getPylonSelections) params ["_validPylons","_formatPylons"];
		private _weapon = GVAR(plan) # GVAR(planIndex) getOrDefault ["weapon",[]];

		if (_weapon isEqualTo [] || {!(_weapon in _validPylons)}) then {
			_weapon = _validPylons param [0,[]];
		};

		{
			_x params ["_pylon","_weaponName","_magazineName","_turretName"];

			private _i = _ctrl lbAdd _weaponName;
			_ctrl lbSetData [_i,str _pylon];
			_ctrl lbSetTextRight [_i,_magazineName];
			//_ctrl lbSetTooltip [_i,_turretName];
			if (_weapon isEqualTo _pylon) then {_ctrl lbSetCurSel _i};
		} forEach _formatPylons;

		_groupHeight = _groupHeight + 1;
		_controls append [_ctrlText,_ctrl];

		// Duration
		_controls append ([_groupHeight,LLSTRING(totalDuration),[1,20,0],10,"duration",LELSTRING(common,secondAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Burst duration
		_controls append ([_groupHeight,LLSTRING(burstDuration),[1,20,0],3,"burstDuration",LELSTRING(common,secondAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Burst interval
		_controls append ([_groupHeight,LLSTRING(burstInterval),[1,20,0],2,"burstInterval",LELSTRING(common,secondAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;

		// Spread
		_controls append ([_groupHeight,LLSTRING(spread),[0,30,0],0,"spread",LELSTRING(common,meterAcronym)] call FUNC(gui_slider));
		_groupHeight = _groupHeight + 1;
	};
	case "RELOCATE" : {};	
};

_ctrlTaskGroup setVariable [QGVAR(taskSpecificControls),_controls];
_ctrlTaskGroup ctrlSetPositionH GD_H(_groupHeight);
_ctrlTaskGroup ctrlCommit 0;

call FUNC(gui_verify);
