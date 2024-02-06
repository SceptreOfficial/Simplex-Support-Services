#include "..\script_component.hpp"

params ["_direction"];

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlItemsGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlPreviewImage = _ctrlItemsGroup controlsGroupCtrl IDC_PREVIEW_IMAGE;

private _images = _ctrlPreviewImage getVariable [QGVAR(images),[]];
private _index = _ctrlPreviewImage getVariable [QGVAR(imageIndex),0];

if (_direction) then {
	_index = _index + 1;
	if (_index >= count _images) then {_index = 0};
} else {
	_index = _index - 1;
	if (_index < 0) then {_index = count _images - 1};
};

_ctrlPreviewImage setVariable [QGVAR(imageIndex),_index];
_ctrlPreviewImage ctrlSetText (_images param [_index,""]);
