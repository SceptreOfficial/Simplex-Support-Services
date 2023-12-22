#include "script_component.hpp"

params ["_ctrl"];

private _ctrlGroup = ctrlParent _ctrl displayCtrl IDC_INSTRUCTIONS_GROUP;
private _isDuration = cbChecked _ctrl;

if (ctrlClassName _ctrl == QGVAR(primaryDistribution)) then {
	GVAR(request) set ["distribution1",_isDuration];
	[_ctrlGroup controlsGroupCtrl IDC_PRIMARY_QUANTITY,"quantity1"]
} else {
	GVAR(request) set ["distribution2",_isDuration];
	[_ctrlGroup controlsGroupCtrl IDC_SECONDARY_QUANTITY,"quantity2"]
} params ["_ctrlQuantity","_key"];

_ctrlQuantity setVariable [QGVAR(valueKey),_key];

[_ctrlQuantity,GVAR(request) getOrDefault [_key,0],{
	params ["_ctrl","_value"];
	GVAR(request) set [_ctrl getVariable QGVAR(valueKey),_value];
	call FUNC(gui_verify);
},["",LELSTRING(common,secondAcronym)] select _isDuration] call EFUNC(sdf,manageNumberbox);

call FUNC(gui_verify);
