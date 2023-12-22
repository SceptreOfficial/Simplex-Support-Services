#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

if ([QSERVICE,QGVAR(gui)] call EFUNC(common,gui_verify)) exitWith {};

PERFORMANCE_TRACKING_INIT

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);

(_display displayCtrl IDC_ABORT) ctrlEnable !((_entity getVariable [QPVAR(task),""]) in ["","RESPAWN","COOLDOWN"]);

private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;

// Verify plan
//(_display displayCtrl IDC_MAP_TEXT) ctrlShow !GVAR(manualInput);

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _vehicle = _entity getVariable QPVAR(vehicle);
ctrlDelete (_ctrlGroup getVariable [QGVAR(tip),controlNull]);

if (_vehicle getVariable [QGVAR(hold),""] isNotEqualTo "" ||
	_vehicle getVariable [QGVAR(searching),false] ||
	//!isNil {_vehicle getVariable QGVAR(signalPos)} ||
	!isNil {_vehicle getVariable QGVAR(slingloadPos)}
) then {
	[{
		params ["_display","_ctrlGroup"];

		private _ctrlTip = _display ctrlCreate ["RscPictureKeepAspect",-1,_ctrlGroup];
		_ctrlTip ctrlSetPosition [CTRL_X(19),CTRL_Y(0),CTRL_W(1),CTRL_H(1)];
		_ctrlTip ctrlCommit 0;
		_ctrlTip ctrlSetText ICON_CAUTION;
		_ctrlTip ctrlSetTextColor RGBA_YELLOW;
		ctrlSetFocus _ctrlTip;
		_ctrlGroup setVariable [QGVAR(tip),_ctrlTip];
	},[_display,_ctrlGroup]] call CBA_fnc_execNextFrame;
};

PERFORMANCE_TRACKING_END

if (GVAR(plan) isEqualTo [] || {GVAR(guiTab) == 1 && GVAR(confirmation) isEqualTo []}) exitWith {
	_ctrlConfirm ctrlEnable false;
};

_ctrlConfirm ctrlEnable (+[_player,_entity,GVAR(plan)] call (_entity getVariable QPVAR(requestCondition)));
