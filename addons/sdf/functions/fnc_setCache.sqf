#include "script_component.hpp"

disableSerialization;

params ["_ctrl",["_uid",""],"_currentValue"];

if (_uid isEqualTo "") then {
	_uid = [uiNamespace getVariable [QGVAR(displayClass),""],ctrlClassName _ctrl,ctrlIDC _ctrl] joinString "#";
};

if (isNil "_currentValue") then {
	_currentValue = switch (ctrlType _ctrl) do {
		case CT_STATIC;
		case CT_EDIT;
		case CT_STRUCTURED_TEXT : {ctrlText _ctrl};
		case CT_CHECKBOX : {cbChecked _ctrl};
		case CT_SLIDER;
		case CT_XSLIDER : {sliderPosition _ctrl};
		case CT_COMBO;
		case CT_XCOMBO;
		case CT_LISTBOX;
		case CT_TOOLBOX;
		case CT_XLISTBOX : {lbCurSel _ctrl};
		case CT_LISTNBOX : {lnbCurSelRow _ctrl};
		case CT_TREE : {tvCurSel _ctrl};
		default {nil};
	};
};

GVAR(customCache) setVariable [[ctrlType _ctrl,_uid] joinString "~",_currentValue];

_currentValue
