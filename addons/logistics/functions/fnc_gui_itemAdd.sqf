#include "script_component.hpp"

params ["_ctrlItems","_path"];

private _ctrlItemsGroup = ctrlParentControlsGroup _ctrlItems;
private _ctrlSelection = _ctrlItemsGroup controlsGroupCtrl IDC_SELECTION;

private _itemKey = if (_path isEqualType []) then {
	_ctrlItems tvData _path
} else {
	_path
};

if (_itemKey isEqualTo "") exitWith {};

private _item = GVAR(list) param [parseNumber _itemKey,[]];

if (_item isEqualTo []) exitWith {
	ERROR("No item data");
};

_item params ["_class","_formatting","_init","_thisArgs","_load","_requestLimit","_quantity"];
_formatting params ["_name","_icon","_tooltip","_info"];

private _index = _ctrlSelection lnbAddRow [_name];
_ctrlSelection lnbSetPicture [[_index,0],_icon];
_ctrlSelection lnbSetTooltip [[_index,0],_tooltip];
_ctrlSelection lnbSetData [[_index,0],_itemKey];
_ctrlSelection lnbSetTextRight [[_index,1],str _load];
_ctrlSelection lnbSetPicture [[_index,2],ICON_BOX];

_ctrlItems setVariable [_itemKey,(_ctrlItems getVariable [_itemKey,0]) + 1];

if (GVAR(objectLimit) >= 0) then {
	if (_class isEqualType "") then {_class = [_class]};
	
	{
		if (_x isKindOf "CAManBase") then {
			GVAR(crewCount) = GVAR(crewCount) + 1;
		} else {
			GVAR(objectCount) = GVAR(objectCount) + 1;
		};
	} forEach _class;
};

GVAR(load) = GVAR(load) + _load;
(GVAR(request) getOrDefault ["selection",[],true]) pushBack _itemKey;

call FUNC(gui_verify);
