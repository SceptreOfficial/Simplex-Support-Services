#include "..\script_component.hpp"

if ([QSERVICE,QGVAR(guiStation)] call EFUNC(common,gui_verify)) exitWith {};

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);

(_display displayCtrl IDC_STATUS) ctrlSetStructuredText parseText ([_entity,1] call EFUNC(common,status));
(_display displayCtrl IDC_ABORT) ctrlEnable false;

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlItemsGroup = _ctrlGroup controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlItems = _ctrlItemsGroup controlsGroupCtrl IDC_ITEMS;
private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;

private _itemKey = _ctrlItems tvData tvCurSel _ctrlItems;

if (_itemKey isEqualTo "" || _entity getVariable [QPVAR(busy),false]) exitWith {
	_ctrlConfirm ctrlEnable false;
};

private _item = GVAR(list) param [parseNumber _itemKey,[]];
private _count = _entity getVariable [_item # 6,-1];
private _request = +GVAR(request);

_request set ["selection",[_item]];

_ctrlConfirm ctrlEnable (_count != 0 && {+[_player,_entity,_request] call (_entity getVariable QPVAR(requestCondition))});
