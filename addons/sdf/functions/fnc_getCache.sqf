#include "script_component.hpp"

disableSerialization;

params ["_ctrl",["_uid",""],"_defaultValue",["_set",false,[false]]];

if (_uid isEqualTo "") then {
	_uid = [uiNamespace getVariable [QGVAR(displayClass),""],ctrlClassName _ctrl,ctrlIDC _ctrl] joinString "#";
};

private _value = GVAR(customCache) getVariable [[ctrlType _ctrl,_uid] joinString "~",_defaultValue];

if (_set && !isNil "_value") then {
	switch (ctrlType _ctrl) do {
		case CT_STATIC;
		case CT_EDIT : {_ctrl ctrlSetText _value};
		case CT_STRUCTURED_TEXT : {_ctrl ctrlSetStructuredText parseText _value};
		case CT_CHECKBOX : {_ctrl cbSetChecked _value};
		case CT_SLIDER;
		case CT_XSLIDER : {_ctrl sliderSetPosition _value};
		case CT_COMBO;
		case CT_XCOMBO;
		case CT_LISTBOX;
		case CT_TOOLBOX;
		case CT_XLISTBOX : {_ctrl lbSetCurSel _value};
		case CT_LISTNBOX : {_ctrl lnbSetCurSelRow _value};
		case CT_TREE : {_ctrl tvSetCurSel _value};
	};
};

_value