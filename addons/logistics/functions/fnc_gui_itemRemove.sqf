#include "..\script_component.hpp"

params ["_ctrlSelection","_index"];

private _ctrlItemsGroup = ctrlParentControlsGroup _ctrlSelection;
private _ctrlItems = _ctrlItemsGroup controlsGroupCtrl IDC_ITEMS;

private _itemKey = _ctrlSelection lnbData [_index,0];
private _item = GVAR(list) param [parseNumber _itemKey,[]];

if (_item isEqualTo []) exitWith {
	LOG_ERROR("No item data");
};

_item params ["_class","_formatting","_init","_thisArgs","_load","_requestLimit","_quantity"];
_formatting params ["_name","_icon","_tooltip","_info"];

_ctrlSelection lnbDeleteRow _index;

_ctrlItems setVariable [_itemKey,((_ctrlItems getVariable [_itemKey,0]) - 1) max 0];

if (GVAR(objectLimit) >= 0) then {
	if (_class isEqualType "") then {_class = [_class]};
	
	{
		if (_x isKindOf "CAManBase") then {
			GVAR(crewCount) = (GVAR(crewCount) - 1) max 0;
		} else {
			GVAR(objectCount) = (GVAR(objectCount) - 1) max 0;
		};
	} forEach _class;
};

GVAR(load) = (GVAR(load) - _load) max 0;
(GVAR(request) getOrDefault ["selection",[],true]) deleteAt _index;

call FUNC(gui_verify);
