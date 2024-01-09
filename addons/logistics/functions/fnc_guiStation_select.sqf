#include "script_component.hpp"

params ["_ctrlItems","_path"];

_this call FUNC(gui_preview);

if (isNil QGVAR(request)) exitWith {};

private _ctrlItemsGroup = ctrlParentControlsGroup _ctrlItems;

private _itemKey = _ctrlItems tvData _path;

if (_itemKey isEqualTo "") exitWith {};

private _item = GVAR(list) param [parseNumber _itemKey,[]];

if (_item isEqualTo []) exitWith {
	LOG_ERROR("No item data");
};

GVAR(request) set ["selection",_path];

call FUNC(guiStation_verify);
