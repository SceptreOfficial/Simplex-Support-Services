#include "script_component.hpp"

params ["_ctrl","_index"];

private _display = ctrlParent _ctrl;
private _ctrlGroup = ctrlParentControlsGroup _ctrl;
private _ctrlTarget = _ctrlGroup controlsGroupCtrl IDC_TARGET;
private _ctrlTargetDetail = _ctrlGroup controlsGroupCtrl IDC_TARGET_DETAIL;

private _type = _ctrlTarget lbData lbCurSel _ctrlTarget;
private _detail = _ctrlTargetDetail lbData lbCurSel _ctrlTargetDetail;

if (_ctrlTargetDetail == _ctrl) exitWith {
	if (_detail isEqualTo "") then {
		GVAR(request) set ["target",_type];
	} else {
		GVAR(request) set ["target",_type + ":" + _detail];
	};
};

switch _type do {
	case "LASER" : {
		lbClear _ctrlTargetDetail;
		_ctrlTargetDetail ctrlEnable true;

		_ctrlTargetDetail lbAdd LELSTRING(common,default);
		_ctrlTargetDetail lbSetPicture [0,ICON_GEAR];
		_ctrlTargetDetail lbAdd LELSTRING(common,targetLaserMatch);
		_ctrlTargetDetail lbSetPicture [1,ICON_LASER_MATCH];
		_ctrlTargetDetail lbSetData [1,"MATCH"];

		_ctrlTargetDetail lbSetCurSel parseNumber (_detail isEqualTo "MATCH");
	};
	case "SMOKE";
	case "FLARE" : {
		lbClear _ctrlTargetDetail;
		_ctrlTargetDetail ctrlEnable true;

		private _selection = 0;

		{
			_x params ["_color","_name","_icon","_rgba"];
			_ctrlTargetDetail lbAdd _name;
			_ctrlTargetDetail lbSetPicture [_forEachIndex,_icon];
			_ctrlTargetDetail lbSetPictureColor [_forEachIndex,_rgba];
			_ctrlTargetDetail lbSetData [_forEachIndex,_color];
			if (_detail isEqualTo _color) then {_selection = _forEachIndex};
		} forEach EGVAR(common,colorFormatting);

		_ctrlTargetDetail lbSetCurSel _selection;
	};
	case "VEHICLES" : {
		lbClear _ctrlTargetDetail;
		_ctrlTargetDetail ctrlEnable true;

		_ctrlTargetDetail lbAdd LELSTRING(common,any);
		_ctrlTargetDetail lbSetPicture [0,ICON_GEAR];
		_ctrlTargetDetail lbAdd LELSTRING(common,targetVehiclesStatic);
		_ctrlTargetDetail lbSetPicture [1,ICON_MORTAR];
		_ctrlTargetDetail lbSetData [1,"STATIC"];
		_ctrlTargetDetail lbAdd LELSTRING(common,targetVehiclesWheeled);
		_ctrlTargetDetail lbSetPicture [2,ICON_CAR];
		_ctrlTargetDetail lbSetData [2,"WHEELED"];
		_ctrlTargetDetail lbAdd LELSTRING(common,targetVehiclesTracked);
		_ctrlTargetDetail lbSetPicture [3,ICON_SELF_PROPELLED];
		_ctrlTargetDetail lbSetData [3,"TRACKED"];
		_ctrlTargetDetail lbAdd LELSTRING(common,targetVehiclesRadar);
		_ctrlTargetDetail lbSetPicture [4,ICON_RADAR];
		_ctrlTargetDetail lbSetData [4,"RADAR"];

		_ctrlTargetDetail lbSetCurSel 0 max (["","STATIC","WHEELED","TRACKED","RADAR"] find _detail);
	};
	default {
		//lbClear _ctrlTargetDetail;
		_ctrlTargetDetail ctrlEnable false;
		GVAR(request) set ["target",_type];
	};
};

private _ctrlDangerClose = _ctrlGroup controlsGroupCtrl IDC_DANGER_CLOSE;

if (_type in ["","MAP"]) then {
	_ctrlDangerClose ctrlEnable false;
	
	if (!isNull (_ctrlDangerClose getVariable [QGVAR(cover),controlNull])) exitWith {};
	
	private _cover = _display ctrlCreate ["RscText",-1,_ctrlGroup];
	_cover ctrlSetBackgroundColor [0,0,0,0.5];
	_cover ctrlSetPosition ctrlPosition _ctrlDangerClose;
	_cover ctrlCommit 0;
	_ctrlDangerClose setVariable [QGVAR(cover),_cover];

	(_ctrlGroup controlsGroupCtrl IDC_SEARCH_RADIUS) ctrlEnable false;
	(_ctrlGroup controlsGroupCtrl IDC_SEARCH_RADIUS_EDIT) ctrlEnable false;

} else {
	_ctrlDangerClose ctrlEnable true;
	ctrlDelete (_ctrlDangerClose getVariable [QGVAR(cover),controlNull]);
	
	(_ctrlGroup controlsGroupCtrl IDC_SEARCH_RADIUS) ctrlEnable true;
	(_ctrlGroup controlsGroupCtrl IDC_SEARCH_RADIUS_EDIT) ctrlEnable true;
};

call FUNC(gui_verify);
