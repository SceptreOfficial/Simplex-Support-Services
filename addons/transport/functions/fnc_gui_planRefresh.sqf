#include "script_component.hpp"

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlPlan = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;
private _entity = PVAR(guiEntity);

lnbClear _ctrlPlan;

{
	[_x get "posASL"] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

	private _index = _ctrlPlan lnbAddRow [
		GVAR(taskNames) get (_x get "task"),
		format ["%1 E %2 N",_easting,_northing],
		str (_x get "timeout")
	];
	_ctrlPlan lnbSetPicture [[_index,0],GVAR(taskIcons) get (_x get "task")];
} forEach GVAR(plan);
