#include "script_component.hpp"

params ["_sheaf"];

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _ctrlMap = _display displayCtrl IDC_MAP;
private _showDispersion = _sheaf in ["CONVERGED","PARALLEL"];

{[_ctrlTaskGroup controlsGroupCtrl _x,_showDispersion] call EFUNC(sdf,show)} forEach [
	IDC_SHEAF_DISPERSION_TEXT,
	IDC_SHEAF_DISPERSION,
	IDC_SHEAF_DISPERSION_EDIT
];

{[_ctrlTaskGroup controlsGroupCtrl _x,!_showDispersion] call EFUNC(sdf,show)} forEach [
	IDC_SHEAF_WIDTH_TEXT,
	IDC_SHEAF_WIDTH,
	IDC_SHEAF_HEIGHT_TEXT,
	IDC_SHEAF_HEIGHT,
	IDC_SHEAF_ANGLE_TEXT,
	IDC_SHEAF_ANGLE
];

if (_showDispersion) then {
	[_ctrlMap,0] call EFUNC(SDF,mapMode);

	private _dispersion = GVAR(plan) # GVAR(planIndex) # 0 # 1;
	
	{
		if (markerShape _x == "ELLIPSE") then {
			_x setMarkerSizeLocal [_dispersion,_dispersion];
		};
	} forEach PVAR(guiMarkers);
} else {
	[_ctrlMap,1] call EFUNC(SDF,mapMode);
	DELETE_GUI_MARKERS;
};

if (!isNil QGVAR(drawArrowID)) then {
	_ctrlMap ctrlRemoveEventHandler ["Draw",GVAR(drawArrowID)];
	GVAR(drawArrowID) = nil;
};

if (_sheaf == "CREEPING" && isNil QGVAR(drawArrowID)) then {
	GVAR(drawArrowID) = _ctrlMap ctrlAddEventHandler ["Draw",{
		params ["_ctrlMap"];

		if (GVAR(plan) isEqualTo [] || !GVAR(visualAids) || GVAR(guiTab) == 1) exitWith {};

		GVAR(plan) # GVAR(planIndex) params ["_area","_sheaf","_magazines","_rounds","_exec","_firing"];
		_area params ["_center","_width","_height","_dir"];

		if (_width <= 0 || _height <= 0) exitWith {};

		_ctrlMap drawArrow [_center getPos [_height * 0.9,_dir - 180],_center getPos [_height * 0.9,_dir],RGBA_YELLOW];

		private _rowHeight = (_height / _rounds) * 2;
		private _rowWidth = _width / 4;
		private _rowCenter = _center getPos [_height,_dir - 180];

		for "_i" from 2 to _rounds do {
			_rowCenter = _rowCenter getPos [_rowHeight,_dir];
			_ctrlMap drawLine [_rowCenter getPos [_width,_dir - 90],_rowCenter getPos [_rowWidth,_dir - 90],RGBA_YELLOW];
			_ctrlMap drawLine [_rowCenter getPos [_rowWidth,_dir + 90],_rowCenter getPos [_width,_dir + 90],RGBA_YELLOW];
		};
	}];
};
