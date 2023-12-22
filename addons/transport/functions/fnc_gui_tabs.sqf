#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_ctrlTabs","_index"];

private _display = ctrlParent _ctrlTabs;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlConfirmationsBG = _ctrlGroup controlsGroupCtrl IDC_CONFIRMATIONS_BG;
private _ctrlConfirmationsGroup = _ctrlGroup controlsGroupCtrl IDC_CONFIRMATIONS_GROUP;
private _ctrlPlanGroup = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _vehicle = PVAR(guiEntity) getVariable [QPVAR(vehicle),objNull];
private _planOpen = _index == 0;
GVAR(guiTab) = _index;

_ctrlConfirmationsBG ctrlShow !_planOpen;
_ctrlConfirmationsGroup ctrlShow !_planOpen;
_ctrlConfirmationsGroup ctrlEnable !_planOpen;

_ctrlPlanGroup ctrlShow _planOpen;
_ctrlPlanGroup ctrlEnable _planOpen;

_ctrlTaskGroup ctrlShow _planOpen;
_ctrlTaskGroup ctrlEnable _planOpen;

{
	if (_x != _ctrlConfirmationsGroup) then {
		ctrlDelete _x;
	};
} forEach allControls _ctrlConfirmationsGroup;

DELETE_GUI_MARKERS;

if (_planOpen) exitWith FUNC(gui_verify);

GVAR(confirmation) set [0,_vehicle];

switch true do {
	case (_vehicle getVariable [QGVAR(hold),""] isNotEqualTo "") : {
		GVAR(confirmation) set [2,{
			params ["_vehicle","_value"];
			_vehicle setVariable [QGVAR(endHold),_value,true];
		}];

		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlConfirmationsGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(0),CTRL_W(6),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText localize (_vehicle getVariable [QGVAR(hold),""]);

		private _ctrl = _display ctrlCreate [QEGVAR(sdf,Checkbox),-1,_ctrlConfirmationsGroup];
		_ctrl ctrlSetPosition [CTRL_X(6),CTRL_Y(0),CTRL_W(1),CTRL_H(1)];
		_ctrl ctrlCommit 0;

		[_ctrl,"CheckedChanged",{
			params ["_ctrl"];
			GVAR(confirmation) set [1,cbChecked _ctrl];
			call FUNC(gui_verify);
		},_vehicle] call CBA_fnc_addBISEventHandler;

		private _end = GVAR(confirmation) param [1,true];
		if !(_end isEqualType false) then {_end = true};

		_ctrl cbSetChecked _end;
		GVAR(confirmation) set [1,_end];

		_ctrlConfirmationsBG ctrlSetPositionH CTRL_H_BUFFER(1);
		_ctrlConfirmationsBG ctrlCommit 0;
		_ctrlConfirmationsGroup ctrlSetPositionH CTRL_H_BUFFER(1);
		_ctrlConfirmationsGroup ctrlCommit 0;
	};
	case (_vehicle getVariable [QGVAR(searching),false]) : {
		GVAR(confirmation) set [2,{
			params ["_vehicle","_signal"];
			_vehicle setVariable [QGVAR(signal),_signal,true];
			_vehicle setVariable [QGVAR(searching),nil,true];
		}];

		private _dummy = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlConfirmationsGroup];
		_dummy ctrlSetPosition [CTRL_X(0),CTRL_Y(0),CTRL_W(0),CTRL_H(0)];
		_dummy ctrlCommit 0;
		_dummy ctrlShow false;

		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlConfirmationsGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(0),CTRL_W(18),CTRL_H(1.1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(slingloadTarget);

		private _ctrlBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlConfirmationsGroup];
		_ctrlBG ctrlSetPosition [CTRL_X(0),CTRL_Y(1),CTRL_W(18),CTRL_H(20)];
		_ctrlBG ctrlCommit 0;
		_ctrlBG ctrlSetBackgroundColor [0,0,0,1];

		private _ctrl = _display ctrlCreate [QEGVAR(sdf,ListNBox),-1,_ctrlConfirmationsGroup];
		_ctrl ctrlSetPosition [CTRL_X(0),CTRL_Y(1),CTRL_W(18),CTRL_H(20)];
		_ctrl ctrlCommit 0;
		_ctrl lnbSetColumnsPos [0,1/18,0.7];

		private _signalData = _vehicle getVariable [QGVAR(signalData),[]];
		private _signals = _signalData apply {_x # 0};
		private _group = group driver _vehicle;
		_ctrl setVariable [str (_ctrl lnbAddRow ["","[ CANCEL SEARCH ]"]),[objNull,[0,0,0]]];

		{
			if (_x in _signals) then {continue};
			
			_signalData pushBack [
				_x,
				getPos _x,
				_x call EFUNC(common,signalDescription),
				_x call EFUNC(common,signalIcon),
				[_x,true] call EFUNC(common,signalColor)
			];
		} forEach ([
			_vehicle getVariable [QGVAR(signalType),""],
			waypointPosition [_group,currentWaypoint _group],
			_vehicle getVariable [QGVAR(searchRadius),350]
		] call EFUNC(common,signalSearch));

		{
			_x params ["_obj","_pos","_name","_icon","_color"];

			if (!isNull _obj) then {
				_pos = getPos _obj;
				_x set [1,_pos];
			};

			private _row = _ctrl lnbAddRow ["",_name,_pos call EFUNC(common,formatGrid)];
			_ctrl lnbSetPicture [[_row,0],_icon];
			_ctrl lnbSetPictureColor [[_row,0],_color];
			_ctrl setVariable [str _row,_x];
		} forEach _signalData;

		[_ctrl,"LBSelChanged",{
			params ["_ctrl","_index"];
			
			private _signal = _ctrl getVariable [str _index,[objNull,[0,0,0]]];
			_signal params ["_obj","_pos"];

			GVAR(confirmation) set [1,_signal];
			//_vehicle setVariable [QGVAR(signalIndex),_index];

			if (GVAR(visualAids) && _pos isNotEqualTo [0,0,0]) then {
				private _marker = createMarkerLocal [GEN_STR(_signal),_pos];
				_marker setMarkerTypeLocal "selector_selectable";
				_marker setMarkerColorLocal "ColorBlue";
				//_marker setMarkerSizeLocal [0.5,0.5];
				DELETE_GUI_MARKERS;
				PVAR(guiMarkers) pushBack _marker;

				[{
					params ["_marker","_start","_signal"];
					_signal params ["_signalObj","_signalPos"];

					if (markerColor _marker == "") exitWith {true};

					private _progress = (CBA_missionTime - _start) / 5;

					if (_progress >= 1) then {
						_this set [1,CBA_missionTime];
					};

					if (!isNull _signalObj) then {
						_signalPos = getPos _signalObj;
					};

					_marker setMarkerPosLocal _signalPos;
					_marker setMarkerDirLocal (360 * _progress);

					false
				},{},[_marker,CBA_missionTime,_signal]] call CBA_fnc_waitUntilAndExecute;
			};

			call FUNC(gui_verify);
		},_vehicle] call CBA_fnc_addBISEventHandler;

		_ctrl lnbSetCurSelRow (_vehicle getVariable [QGVAR(signalIndex),0]);

		_ctrlConfirmationsBG ctrlSetPositionH CTRL_H_BUFFER(21);
		_ctrlConfirmationsBG ctrlCommit 0;
		_ctrlConfirmationsGroup ctrlSetPositionH CTRL_H_BUFFER(21);
		_ctrlConfirmationsGroup ctrlCommit 0;
	};
	case (!isNil {_vehicle getVariable QGVAR(slingloadPos)}) : {
		GVAR(confirmation) set [2,{
			params ["_vehicle","_slingloadTarget"];
			_vehicle setVariable [QGVAR(slingloadTarget),_slingloadTarget,true];
			_vehicle setVariable [QGVAR(slingloadPos),nil,true];
		}];

		private _slingloadPos = _vehicle getVariable [QGVAR(slingloadPos),getPos _vehicle];

		private _dummy = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlConfirmationsGroup];
		_dummy ctrlSetPosition [CTRL_X(0),CTRL_Y(0),CTRL_W(0),CTRL_H(0)];
		_dummy ctrlCommit 0;
		_dummy ctrlShow false;

		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlConfirmationsGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(0),CTRL_W(18),CTRL_H(1.1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetText LLSTRING(slingloadTarget);

		private _ctrlBG = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlConfirmationsGroup];
		_ctrlBG ctrlSetPosition [CTRL_X(0),CTRL_Y(1),CTRL_W(18),CTRL_H(20)];
		_ctrlBG ctrlCommit 0;
		_ctrlBG ctrlSetBackgroundColor [0,0,0,1];

		private _ctrl = _display ctrlCreate [QEGVAR(sdf,ListNBox),-1,_ctrlConfirmationsGroup];
		_ctrl ctrlSetPosition [CTRL_X(0),CTRL_Y(1),CTRL_W(18),CTRL_H(20)];
		_ctrl ctrlCommit 0;
		_ctrl lnbSetColumnsPos [0,1/18,0.7];

		private _objects = [objNull];
		_ctrl setVariable [str (_ctrl lnbAddRow ["","[ CANCEL SLINGLOADING ]"]),objNull];

		{
			if ([_vehicle,_x,GVAR(slingloadMassOverride)] call EFUNC(common,canSlingLoad)) then {
				private _row = _ctrl lnbAddRow ["",getText (configOf _x >> "displayName"),(getPos _x) call EFUNC(common,formatGrid)];
				_ctrl lnbSetPicture [[_row,0],_x call EFUNC(common,getIcon)];
				_ctrl setVariable [str _row,_x];
				_objects pushBack _x;
			};
		} forEach (nearestObjects [_slingloadPos,[],100]);

		[_ctrl,"LBSelChanged",{
			params ["_ctrl","_index"];
			
			private _slingloadTarget = _ctrl getVariable [str _index,objNull];

			GVAR(confirmation) set [1,_slingloadTarget];

			if (GVAR(visualAids) && !isNull _slingloadTarget) then {
				private _marker = createMarkerLocal [GEN_STR(_slingloadTarget),getPos _slingloadTarget];
				_marker setMarkerTypeLocal "selector_selectable";
				_marker setMarkerColorLocal "ColorBlue";
				//_marker setMarkerSizeLocal [0.5,0.5];
				DELETE_GUI_MARKERS;
				PVAR(guiMarkers) pushBack _marker;

				[{
					params ["_marker","_start","_target"];

					if (markerColor _marker == "") exitWith {true};

					private _interval = (CBA_missionTime - _start) / 5;

					if (_interval >= 1) then {
						_this set [1,CBA_missionTime];
					};

					_marker setMarkerPosLocal getPos _target;
					_marker setMarkerDirLocal (360 * _interval);

					false
				},{},[_marker,CBA_missionTime,_slingloadTarget]] call CBA_fnc_waitUntilAndExecute;
			};

			call FUNC(gui_verify);
		},_vehicle] call CBA_fnc_addBISEventHandler;

		private _object = GVAR(confirmation) param [1,objNull];
		if !(_object isEqualType objNull) then {_object = objNull};

		private _index = _objects find _object;
		if (_index < 0) then {_index = 0};

		_ctrl lnbSetCurSelRow _index;

		_ctrlConfirmationsBG ctrlSetPositionH CTRL_H_BUFFER(21);
		_ctrlConfirmationsBG ctrlCommit 0;
		_ctrlConfirmationsGroup ctrlSetPositionH CTRL_H_BUFFER(21);
		_ctrlConfirmationsGroup ctrlCommit 0;
	};
	default {
		GVAR(confirmation) = [];

		private _ctrlText = _display ctrlCreate [QEGVAR(sdf,TextCentered),-1,_ctrlConfirmationsGroup];
		_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(0),CTRL_W(18),CTRL_H(1)];
		_ctrlText ctrlCommit 0;
		_ctrlText ctrlSetBackgroundColor [0,0,0,0];
		_ctrlText ctrlSetText LELSTRING(common,NA);

		_ctrlConfirmationsBG ctrlSetPositionH CTRL_H_BUFFER(1);
		_ctrlConfirmationsBG ctrlCommit 0;
		_ctrlConfirmationsGroup ctrlSetPositionH CTRL_H_BUFFER(1);
		_ctrlConfirmationsGroup ctrlCommit 0;
	};
};

call FUNC(gui_verify);
