#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_y","_text","_options","_value","_key","_symbol","_textHash"];

private _ctrlText = _display ctrlCreate [QEGVAR(sdf,Text),-1,_ctrlTaskGroup];
_ctrlText ctrlSetPosition [CTRL_X(0),CTRL_Y(_y),CTRL_W(7),CTRL_H(1)];
_ctrlText ctrlCommit 0;
_ctrlText ctrlSetText _text;

private _ctrlSlider = _display ctrlCreate [QEGVAR(sdf,Slider),-1,_ctrlTaskGroup];
_ctrlSlider ctrlSetPosition [CTRL_X(7),CTRL_Y(_y),CTRL_W(11),CTRL_H(1)];
_ctrlSlider ctrlCommit 0;

private _ctrlEdit = _display ctrlCreate [QEGVAR(sdf,SliderEdit),-1,_ctrlTaskGroup];
_ctrlEdit ctrlSetPosition [CTRL_X(18),CTRL_Y(_y),CTRL_W(2),CTRL_H(1)];
_ctrlEdit ctrlCommit 0;

_ctrlSlider setVariable [QGVAR(key),_key];

_value = GVAR(plan) # GVAR(planIndex) getOrDefault [_key,_value];

[_ctrlSlider,_ctrlEdit,_options,_value,{
	params ["_ctrlSlider","_value"];
	GVAR(plan) # GVAR(planIndex) set [_ctrlSlider getVariable QGVAR(key),_value];
	call FUNC(gui_verify);
},_symbol,_textHash] call EFUNC(sdf,manageSlider);

[_ctrlText,_ctrlSlider,_ctrlEdit]
