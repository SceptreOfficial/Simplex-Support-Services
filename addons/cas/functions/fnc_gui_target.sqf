#include "script_component.hpp"

params ["_ctrl","_index"];

private _ctrlGroup = ctrlParent _ctrl displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTarget = _ctrlGroup controlsGroupCtrl IDC_TARGET;
private _ctrlTargetDetail = _ctrlGroup controlsGroupCtrl IDC_TARGET_DETAIL;
private _type = _ctrlTarget lbData lbCurSel _ctrlTarget;

if (_ctrlTargetDetail == _ctrl) exitWith {
	private _detail = _ctrl lbData _index;
	
	if (_detail isEqualTo "") then {
		GVAR(request) set ["target",_type];
	} else {
		GVAR(request) set ["target",_type + ":" + _detail];
	};
};

if (_type in ["SMOKE","FLARE"]) then {
	private _detail = _ctrlTargetDetail lbData lbCurSel _ctrlTargetDetail;

	if (_detail isEqualTo "") then {
		GVAR(request) set ["target",_type];
	} else {
		GVAR(request) set ["target",_type + ":" + _detail];
	};
	
	_ctrlTargetDetail ctrlEnable true;
} else {
	GVAR(request) set ["target",_type];
	_ctrlTargetDetail ctrlEnable false;
};

call FUNC(gui_verify);
