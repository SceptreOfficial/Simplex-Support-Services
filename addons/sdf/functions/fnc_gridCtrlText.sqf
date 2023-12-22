#include "script_component.hpp"

params [["_structuredText",false,[false]]];

if (_valueData isEqualTo []) then {
	_valueData = [0,0,0,0.6];
};

private _ctrl = if (_structuredText) then {
	private _ctrl = _display ctrlCreate [QGVAR(StructuredText),-1,_ctrlGroup];
	_ctrl ctrlSetStructuredText parseText format ["<t size='%1'>&#160;<br/></t>%2",GRID_H(5),_descriptionText];
	_ctrl
} else {
	private _ctrl = _display ctrlCreate [QGVAR(Text),-1,_ctrlGroup];
	_ctrl ctrlSetText _descriptionText;
	_ctrl
};

_ctrl ctrlSetPosition _position;
_ctrl ctrlSetTextColor _descriptionTextColor;
_ctrl ctrlSetTooltip _descriptionTooltip;
_ctrl ctrlSetBackgroundColor _valueData;
_ctrl ctrlCommit 0;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_descriptionText]];
_ctrl setVariable [QGVAR(position),_position];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),_descriptionText];
_ctrl setVariable [QGVAR(ctrlDescription),_ctrl];
_ctrl setVariable [QGVAR(ctrlDescriptionType),[0,1] select _structuredText];

_controls pushBack _ctrl;
