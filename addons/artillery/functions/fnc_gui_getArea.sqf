#include "..\script_component.hpp"

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlMap = _display displayCtrl IDC_MAP;
private _ctrlTaskGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_TASK_GROUP;

if (GVAR(manualInput)) exitWith {
	private _easting = ctrlText (_ctrlTaskGroup controlsGroupCtrl IDC_GRID_E);
	private _northing = ctrlText (_ctrlTaskGroup controlsGroupCtrl IDC_GRID_N);
	private _center = AGLToASL ([_easting + _northing] call EFUNC(common,getMapPosFromGrid));
	private _sheaf = (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF) lbData (0 max lbCurSel (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF));

	if (_sheaf in ["CONVERGED","PARALLEL"]) then {
		private _dispersion = sliderPosition (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_DISPERSION);
		[_center,_dispersion,_dispersion,0,true]
	} else {
		[
			_center,
			999999 min parseNumber ctrlText (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_WIDTH),
			999999 min parseNumber ctrlText (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_HEIGHT),
			360 min parseNumber ctrlText (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_ANGLE),
			true
		]
	};
};

private _area = +(_ctrlMap getVariable [QEGVAR(sdf,value),[[0,0,0]]]);
(_area # 0) set [2,0];

if (_area isEqualTypeParams [[],0,0,0,true]) then {
	_area set [0,AGLToASL (_area # 0)];
	_area set [1,round (_area # 1)];
	_area set [2,round (_area # 2)];
	_area set [3,round (_area # 3)];
} else {
	private _dispersion = sliderPosition (_ctrlTaskGroup controlsGroupCtrl IDC_SHEAF_DISPERSION);
	_area = [AGLToASL (_area # 0),_dispersion,_dispersion,0,true];
};

_area
