#include "script_component.hpp"

if ([QSERVICE,QGVAR(guiStrafe)] call EFUNC(common,gui_verify)) exitWith {};

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);

(_display displayCtrl IDC_STATUS) ctrlSetStructuredText parseText ([_entity,1] call EFUNC(common,status));
(_display displayCtrl IDC_ABORT) ctrlEnable (_entity getVariable [QPVAR(task),""] in ["INGRESS","STRAFE"]);

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;

// Disable unusable controls
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

if (GVAR(pylons) isEqualTo [] ||
	_entity getVariable [QPVAR(targetTypes),[]] isEqualTo [] ||
	_entity getVariable [QPVAR(busy),false] ||
	{GVAR(request) getOrDefault ["quantity1",0] == 0 && GVAR(request) getOrDefault ["quantity2",0] == 0}
) exitWith {
	_ctrlConfirm ctrlEnable false;
};

_ctrlConfirm ctrlEnable (+[_player,_entity,GVAR(request)] call (_entity getVariable QPVAR(requestCondition)));
