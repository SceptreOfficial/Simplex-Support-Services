#include "script_component.hpp"

if ([QSERVICE,QGVAR(guiBombing)] call EFUNC(common,gui_verify)) exitWith {};

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);
private _task = _entity getVariable [QPVAR(task),""];

(_display displayCtrl IDC_STATUS) ctrlSetStructuredText parseText ([_entity,1] call EFUNC(common,status));
(_display displayCtrl IDC_ABORT) ctrlEnable (_task in ["INGRESS","BOMBING"]);

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

// Confirm
if (_task isNotEqualTo "") exitWith {
	_ctrlConfirm ctrlEnable false;
};

_ctrlConfirm ctrlEnable (+[_player,_entity,GVAR(request)] call (_entity getVariable QPVAR(requestCondition)));
