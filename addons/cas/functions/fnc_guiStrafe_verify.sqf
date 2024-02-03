#include "..\script_component.hpp"

if ([QSERVICE,QGVAR(guiStrafe)] call EFUNC(common,gui_verify)) exitWith {};

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);

(_display displayCtrl IDC_STATUS) ctrlSetStructuredText parseText ([_entity,1] call EFUNC(common,status));
(_display displayCtrl IDC_ABORT) ctrlEnable (_entity getVariable [QPVAR(task),""] in ["INGRESS","STRAFE"]);

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;

if (GVAR(pylons) isEqualTo [] ||
	_entity getVariable [QPVAR(targetTypes),[]] isEqualTo [] ||
	_entity getVariable [QPVAR(busy),false] ||
	{GVAR(request) getOrDefault ["quantity1",0] == 0 && GVAR(request) getOrDefault ["quantity2",0] == 0}
) exitWith {
	_ctrlConfirm ctrlEnable false;
};

_ctrlConfirm ctrlEnable (+[_player,_entity,GVAR(request)] call (_entity getVariable QPVAR(requestCondition)));
