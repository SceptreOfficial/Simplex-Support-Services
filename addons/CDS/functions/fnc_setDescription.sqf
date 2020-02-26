#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_description","",["",[]]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _ctrlDescription = _ctrl getVariable [QGVAR(ctrlDescription),controlNull];
private _data = _ctrl getVariable QGVAR(data);

_description params [["_descriptionText","",[""]],["_descriptionTooltip","",[""]]];
_description = [_descriptionText,_descriptionTooltip];

_data set [1,_description];
_ctrl setVariable [QGVAR(data),_data];

if (isNull _ctrlDescription) exitWith {};

_ctrlDescription ctrlSetText _descriptionText;
_ctrlDescription ctrlSetTooltip _descriptionTooltip;
