#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_description","",["",[]]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _ctrlDescription = _ctrl getVariable [QGVAR(ctrlDescription),controlNull];
private _params = _ctrl getVariable QGVAR(parameters);

_description params [["_descriptionText","",[""]],["_descriptionTooltip","",[""]]];
if (isLocalized _descriptionText) then {_descriptionText = localize _descriptionText};
if (isLocalized _descriptionTooltip) then {_descriptionTooltip = localize _descriptionTooltip};
_description = [_descriptionText,_descriptionTooltip];

_params set [1,_description];
_ctrl setVariable [QGVAR(parameters),_params];

if (isNull _ctrlDescription) exitWith {};

switch (_ctrl getVariable QGVAR(ctrlDescriptionType)) do {
	case 1 : {_ctrlDescription ctrlSetStructuredText parseText _descriptionText};
	case 2 : {_ctrlDescription ctrlSetStructuredText parseText format ["<t align='center'>%1</t>",_descriptionText]};
	default {_ctrlDescription ctrlSetText _descriptionText};
};

_ctrlDescription ctrlSetTooltip _descriptionTooltip;
