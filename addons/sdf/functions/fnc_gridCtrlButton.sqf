#include "script_component.hpp"

params [["_center",true,[true]]];
_valueData params [["_code",{},[{},""]]];

if (_code isEqualType "") then {
	_code = compile _code;
};

parsingNamespace setVariable [QGVAR(buttonTextLeft),0];
parsingNamespace setVariable [QGVAR(buttonTextTop),0];

private _ctrl = _display ctrlCreate [QGVAR(Button),-1,_ctrlGroup];
_ctrl ctrlSetPosition _position;

if (_center) then {
	_ctrl ctrlSetStructuredText parseText format ["<t align='center'>%1</t>",_descriptionText];
} else {
	_ctrl ctrlSetStructuredText parseText _descriptionText;	
};

_ctrl ctrlSetTooltip _descriptionTooltip;
_ctrl ctrlCommit 0;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_code]];
_ctrl setVariable [QGVAR(position),_position];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_code];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrl];
_ctrl setVariable [QGVAR(ctrlDescriptionType),[1,2] select _center];

_controls pushBack _ctrl;

[_ctrl,"ButtonClick",{
	params ["_ctrl"];
	[_ctrl getVariable QGVAR(value),uiNamespace getVariable QGVAR(arguments)] call CBA_fnc_directCall;
}] call CBA_fnc_addBISEventHandler;
