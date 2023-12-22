#include "script_component.hpp"

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlMap = _display displayCtrl IDC_MAP;
private _ctrlItemsGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_ITEMS_GROUP;

if (GVAR(manualInput)) exitWith {
	private _easting = ctrlText (_ctrlItemsGroup controlsGroupCtrl IDC_GRID_E);
	private _northing = ctrlText (_ctrlItemsGroup controlsGroupCtrl IDC_GRID_N);
	
	AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid))
};

private _pos = +(_ctrlMap getVariable [QEGVAR(sdf,value),[[0,0,0]]]) # 0;
_pos set [2,0];

AGLToASL _pos
