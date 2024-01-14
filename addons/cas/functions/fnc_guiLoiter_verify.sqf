#include "script_component.hpp"

if ([QSERVICE,QGVAR(guiLoiter)] call EFUNC(common,gui_verify)) exitWith {};

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);
private _task = _entity getVariable [QPVAR(task),""];

(_display displayCtrl IDC_STATUS) ctrlSetStructuredText parseText ([_entity,1] call EFUNC(common,status));
(_display displayCtrl IDC_ABORT) ctrlEnable (_task in ["INGRESS","LOITER"]);

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

// Remote Control
private _ctrlRC = _ctrlGroup controlsGroupCtrl IDC_REMOTE_CONTROL;
private _ctrlRCSelect = _ctrlGroup controlsGroupCtrl IDC_REMOTE_CONTROL_SELECT;
private _index = lbCurSel _ctrlRCSelect;

//_ctrlRC ctrlEnable (alive _vehicle && _entity getVariable [QPVAR(remoteControl),true] && _task == "LOITER" && GVAR(remoteControlTurrets) isNotEqualTo []);
_ctrlRC ctrlSetTooltip "";

{
	private _unit = _vehicle turretUnit _x;
	
	if (!alive _unit || _unit call EFUNC(common,isRemoteControlled) || _unit getVariable [QEGVAR(common,firing),false]) then {
		_ctrlRCSelect lbSetData [_forEachIndex,""];
		_ctrlRCSelect lbSetColor [_forEachIndex,RGBA_RED];
		_ctrlRCSelect lbSetTooltip [_forEachIndex,LLSTRING(unavailable)];
		if (_index == _forEachIndex) then {_ctrlRC ctrlSetTooltip LLSTRING(unavailable)};
	} else {
		_ctrlRCSelect lbSetData [_forEachIndex,str _turret];
		_ctrlRCSelect lbSetColor [_forEachIndex,[1,1,1,1]];
		_ctrlRCSelect lbSetTooltip [_forEachIndex,LLSTRING(available)];
	};
} forEach GVAR(remoteControlTurrets);

// Disable unusable controls
private _enableIngressEgress = _task in ["","EGRESS","COOLDOWN"];
{(_ctrlGroup controlsGroupCtrl _x) ctrlEnable _enableIngressEgress} forEach [
	IDC_INGRESS,
	IDC_INGRESS_SLIDER,
	IDC_INGRESS_SLIDER_EDIT,
	IDC_INGRESS_TOGGLE,
	IDC_EGRESS,
	IDC_EGRESS_SLIDER,
	IDC_EGRESS_SLIDER_EDIT,
	IDC_EGRESS_TOGGLE
];

if (_enableIngressEgress) then {
	{ctrlDelete _x} forEach (_display getVariable QGVAR(toolboxCovers));
	_display setVariable [QGVAR(toolboxCovers),nil];
} else {
	if (!isNil {_display getVariable QGVAR(toolboxCovers)}) exitWith {};

	_display setVariable [QGVAR(toolboxCovers),[IDC_INGRESS,IDC_EGRESS] apply {
		private _cover = _display ctrlCreate ["RscText",-1,_ctrlGroup];
		_cover ctrlSetBackgroundColor [0,0,0,0.5];
		_cover ctrlSetPosition ctrlPosition (_ctrlGroup controlsGroupCtrl _x);
		_cover ctrlCommit 0;
		_cover
	}];
};

private _isWeapon = GVAR(request) getOrDefault ["weapon",[]] param [0,""] != "SEARCHLIGHT";
{(_ctrlGroup controlsGroupCtrl _x) ctrlEnable _isWeapon} forEach [
	IDC_BURST_DURATION,
	IDC_BURST_DURATION_EDIT,
	IDC_BURST_INTERVAL,
	IDC_BURST_INTERVAL_EDIT
];

private _ctrlDangerClose = _ctrlGroup controlsGroupCtrl IDC_DANGER_CLOSE;

if (GVAR(request) getOrDefault ["target",""] in ["ENEMIES","INFANTRY","VEHICLES"]) then {
	_ctrlDangerClose ctrlEnable true;
	ctrlDelete (_ctrlDangerClose getVariable [QGVAR(cover),controlNull]);
} else {
	_ctrlDangerClose ctrlEnable false;
	
	if (!isNull (_ctrlDangerClose getVariable [QGVAR(cover),controlNull])) exitWith {};
	
	private _cover = _display ctrlCreate ["RscText",-1,_ctrlGroup];
	_cover ctrlSetBackgroundColor [0,0,0,0.5];
	_cover ctrlSetPosition ctrlPosition _ctrlDangerClose;
	_cover ctrlCommit 0;
	_ctrlDangerClose setVariable [QGVAR(cover),_cover];
};


if (_enableIngressEgress || _entity getVariable [QPVAR(repositioning),true]) then {
	(_ctrlGroup controlsGroupCtrl IDC_GRID_E) ctrlEnable true;
	(_ctrlGroup controlsGroupCtrl IDC_GRID_N) ctrlEnable true;
	(_display displayCtrl IDC_MAP) setVariable [QEGVAR(sdf,override),GVAR(manualInput)];
} else {
	(_ctrlGroup controlsGroupCtrl IDC_GRID_E) ctrlEnable false;
	(_ctrlGroup controlsGroupCtrl IDC_GRID_N) ctrlEnable false;
	(_display displayCtrl IDC_MAP) setVariable [QEGVAR(sdf,override),true];
};

// Confirm
if !(_task in ["","LOITER"]) exitWith {
	_ctrlConfirm ctrlEnable false;
};

_ctrlConfirm ctrlEnable (+[_player,_entity,GVAR(request)] call (_entity getVariable QPVAR(requestCondition)));
