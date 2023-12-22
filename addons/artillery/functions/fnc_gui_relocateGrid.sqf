#include "script_component.hpp"

params ["_ctrl"];

private _display = ctrlParent _ctrl;
private _ctrlRelocateGroup = ctrlParentControlsGroup _ctrl;
private _ctrlE = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_E;
private _ctrlN = _ctrlRelocateGroup controlsGroupCtrl IDC_RELOCATE_GRID_N;

private _easting = ctrlText _ctrlE;
if (count _easting > 5) then {
	_easting = _easting select [0,5];
	_ctrlE ctrlSetText _easting;
};

private _northing = ctrlText _ctrlN;
if (count _northing > 5) then {
	_northing = _northing select [0,5];
	_ctrlN ctrlSetText _northing;
};

GVAR(relocatePosASL) = AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid));

private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QGVAR(viaGrid),true];
[_ctrlMap,[[[GVAR(relocatePosASL)]],[],[],0]] call EFUNC(sdf,setValueData);

call FUNC(gui_verify);
