#include "..\script_component.hpp"

params ["_ctrlCoordination","_lnbCurSel"];

_ctrlCoordination lnbSetPicture [
	[_lnbCurSel,0],
	[ICON_CHECKED2,ICON_UNCHECKED2] select (_ctrlCoordination lnbPicture [_lnbCurSel,0] == ICON_CHECKED2)
];

private _nearbyBatteries = _ctrlCoordination getVariable [QGVAR(nearbyBatteries),[]];
GVAR(coordinated) = [];

for "_i" from 0 to ((lnbSize _ctrlCoordination) # 0 - 1) do {
	if (_ctrlCoordination lnbPicture [_i,0] == ICON_CHECKED2) then {
		GVAR(coordinated) pushBack (_nearbyBatteries # _i);
	};
};

call FUNC(gui_verify);