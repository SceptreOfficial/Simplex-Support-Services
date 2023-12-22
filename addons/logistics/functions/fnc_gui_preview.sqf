#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_ctrlItems","_path"];

private _display = ctrlParent _ctrlItems;
private _ctrlItemsGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlPreviewImage = _ctrlItemsGroup controlsGroupCtrl IDC_PREVIEW_IMAGE;
private _ctrlPreviewLeft = _ctrlItemsGroup controlsGroupCtrl IDC_PREVIEW_LEFT;
private _ctrlPreviewRight = _ctrlItemsGroup controlsGroupCtrl IDC_PREVIEW_RIGHT;
private _ctrlPreviewInfoGroup = _ctrlItemsGroup controlsGroupCtrl IDC_PREVIEW_INFO_GROUP;
private _ctrlPreviewInfo = _ctrlPreviewInfoGroup controlsGroupCtrl IDC_PREVIEW_INFO;

private _itemKey = _ctrlItems tvData _path;

if (_itemKey isEqualTo "") exitWith {
	_ctrlPreviewInfo ctrlSetStructuredText parseText "";
	_ctrlPreviewInfo ctrlSetPositionH ((ctrlTextHeight _ctrlPreviewInfo) max CTRL_H(8.8));
	_ctrlPreviewInfo ctrlCommit 0;
	_ctrlPreviewInfoGroup ctrlSetScrollValues [0,0];
	_ctrlPreviewImage setVariable [QGVAR(imageIndex),nil];
	_ctrlPreviewImage setVariable [QGVAR(images),nil];
	_ctrlPreviewImage ctrlSetText "";
};

private _item = GVAR(list) param [parseNumber _itemKey,[]];

_item params ["_class","_formatting","_init","_thisArgs","_load","_requestLimit","_quantity"];
_formatting params ["_name","_icon","_tooltip","_info"];

private _cfgVehicles = configFile >> "CfgVehicles";
private _count = PVAR(guiEntity) getVariable [_quantity,-1];
private _extras = if (_class isEqualType []) then {
	format ["%1 %2:<t align='right'>-<br/>%3</t><br/>%4",IMG_STR(ICON_GROUP),LLSTRING(group),_class apply {getText (_cfgVehicles >> _x >> "displayName")} joinString "<br/>",_info]
} else {_info};

_ctrlPreviewInfo ctrlSetStructuredText parseText format [
	"%1<br/>%2<br/>%3<br/>%4<br/>%5",
	format ["<t align='center'>%1 %2</t>",IMG_STR(_icon),_name],
	format ["%1 %2:<t align='right'>%3</t>",IMG_STR(ICON_BOX),LLSTRING(load),_load],
	format ["%1 %2:<t align='right'>%3</t>",IMG_STR(ICON_UNLOCK),LLSTRING(requestLimit),[LELSTRING(common,NA),_requestLimit] select (_requestLimit >= 0)],
	format ["%1 %2:<t align='right'>%3</t>",IMG_STR(ICON_HASH),LLSTRING(quantity),[LELSTRING(common,NA),_count] select (_count >= 0)],
	_extras
];

_ctrlPreviewInfo ctrlSetPositionH ((ctrlTextHeight _ctrlPreviewInfo) max CTRL_H(8.8));
_ctrlPreviewInfo ctrlCommit 0;
_ctrlPreviewInfoGroup ctrlSetScrollValues [0,0];

_ctrlPreviewImage setVariable [QGVAR(imageIndex),0];

if (_class isEqualType []) then {
	_ctrlPreviewImage setVariable [QGVAR(images),_class apply {getText (_cfgVehicles >> _x >> "editorPreview")}];
	_ctrlPreviewImage ctrlSetText getText (_cfgVehicles >> _class # 0 >> "editorPreview");
	_ctrlPreviewLeft ctrlShow true;
	_ctrlPreviewRight ctrlShow true;
} else {
	_ctrlPreviewImage setVariable [QGVAR(images),[getText (_cfgVehicles >> _class >> "editorPreview")]];
	_ctrlPreviewImage ctrlSetText getText (_cfgVehicles >> _class >> "editorPreview");
	_ctrlPreviewLeft ctrlShow false;
	_ctrlPreviewRight ctrlShow false;
};

