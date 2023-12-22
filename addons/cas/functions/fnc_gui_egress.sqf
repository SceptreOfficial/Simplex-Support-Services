#include "script_component.hpp"

params ["_ctrl"];

private _hashKey = "egress";
private _ctrlGroup = ctrlParent _ctrl displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlToolbox = _ctrlGroup controlsGroupCtrl IDC_EGRESS;
private _ctrlSlider = _ctrlGroup controlsGroupCtrl IDC_EGRESS_SLIDER;
private _ctrlSliderEdit = _ctrlGroup controlsGroupCtrl IDC_EGRESS_SLIDER_EDIT;
private _ctrlToggle = _ctrlGroup controlsGroupCtrl IDC_EGRESS_TOGGLE;

switch true do {
	case (_ctrl == _ctrlToolbox) : {
		private _value = _ctrl lbValue (_this # 1);
		
		GVAR(request) set [_hashKey,_value];
		_ctrlSlider sliderSetPosition _value;

		if (_value < 0) then {
			_ctrlSliderEdit ctrlSetText LELSTRING(common,dirAuto);
		} else {
			_ctrlSliderEdit ctrlSetText (str _value + "°");
		};
	};
	case (_ctrl == _ctrlSlider) : {
		private _value = _this # 1;
		GVAR(request) set [_hashKey,_value];

		private _nearestAngle = [round (0 max round _value / 45) * 45,-1] select (_value < 0);
		_ctrlToolbox lbSetCurSel ((_ctrlToolbox getVariable QGVAR(angles)) find _nearestAngle);
	};
	case (_ctrl == _ctrlToggle) : {
		private _showSlider = cbChecked _ctrl;
		_ctrlToolbox ctrlShow !_showSlider;
		_ctrlSlider ctrlShow _showSlider;
		_ctrlSliderEdit ctrlShow _showSlider;
		GVAR(request) set [_hashKey + "Toggle",_showSlider];
	};
};

call FUNC(gui_verify);
