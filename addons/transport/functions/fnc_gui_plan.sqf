#include "script_component.hpp"

params ["_ctrlPlan","_index"];

GVAR(planIndex) = _index;

private _display = ctrlParent _ctrlPlan;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlTaskGroup = _ctrlGroup controlsGroupCtrl IDC_TASK_GROUP;
private _entity = PVAR(guiEntity);
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];
private _item = GVAR(plan) # GVAR(planIndex);

private _ctrlTask = _ctrlTaskGroup controlsGroupCtrl IDC_TASK;
_ctrlTask lbSetCurSel (_ctrlTask getVariable [_item get "task",0]);

[_item get "posASL"] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_E) ctrlSetText _easting;
(_ctrlTaskGroup controlsGroupCtrl IDC_GRID_N) ctrlSetText _northing;
[_display displayCtrl IDC_MAP,[[[_item get "posASL"]],[],[],0]] call EFUNC(sdf,setValueData);

private _ctrlTimeout = _ctrlTaskGroup controlsGroupCtrl IDC_TIMEOUT;
private _ctrlTimeoutEdit = _ctrlTaskGroup controlsGroupCtrl IDC_TIMEOUT_EDIT;

[_ctrlTimeout,_ctrlTimeoutEdit,[0,GVAR(limits) get "timeout",0],_item getOrDefault ["timeout",0],{
	params ["_ctrl","_value"];
	GVAR(plan) # GVAR(planIndex) set ["timeout",_value];
	
	private _ctrlPlan = (ctrlParent _ctrl) displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;
	_ctrlPlan lnbSetText [[GVAR(planIndex),2],str _value];
},LELSTRING(common,secondAcronym)] call EFUNC(sdf,manageSlider);

private _ctrlSpeed = _ctrlTaskGroup controlsGroupCtrl IDC_SPEED;
private _ctrlSpeedEdit = _ctrlTaskGroup controlsGroupCtrl IDC_SPEED_EDIT;
private _maxSpeed = getNumber (configOf _vehicle >> "maxSpeed");

[_ctrlSpeed,_ctrlSpeedEdit,[0,_maxSpeed,0],_item get "behaviors" getOrDefault ["speed",_entity getVariable QPVAR(speed)],{
	params ["_ctrl","_value"];
	GVAR(plan) # GVAR(planIndex) get "behaviors" set ["speed",_value];
},LELSTRING(common,kmh),[[0,"∞"]]] call EFUNC(sdf,manageSlider);

private _ctrlCombatMode = _ctrlTaskGroup controlsGroupCtrl IDC_COMBAT_MODE;
_ctrlCombatMode lbSetCurSel (COMBAT_MODES find (_item get "behaviors" getOrDefault ["combatMode",_entity getVariable QPVAR(combatMode)]));

[_ctrlCombatMode,"LBSelChanged",{
	params ["_ctrl","_index"];
	GVAR(plan) # GVAR(planIndex) get "behaviors" set ["combatMode",COMBAT_MODES # _index];
}] call CBA_fnc_addBISEventHandler;

private _ctrlLights = _ctrlTaskGroup controlsGroupCtrl IDC_LIGHTS;
_ctrlLights lbSetCurSel parseNumber (_item get "behaviors" getOrDefault ["lights",_entity getVariable QPVAR(lights)]);

[_ctrlLights,"ToolBoxSelChanged",{
	params ["_ctrl","_index"];
	GVAR(plan) # GVAR(planIndex) get "behaviors" set ["lights",_index == 1];
}] call CBA_fnc_addBISEventHandler;

private _ctrlCollisionLights = _ctrlTaskGroup controlsGroupCtrl IDC_COLLISION_LIGHTS;
_ctrlCollisionLights lbSetCurSel parseNumber (_item get "behaviors" getOrDefault ["collisionLights",_entity getVariable QPVAR(collisionLights)]);

[_ctrlCollisionLights,"ToolBoxSelChanged",{
	params ["_ctrl","_index"];
	GVAR(plan) # GVAR(planIndex) get "behaviors" set ["collisionLights",_index == 1];
}] call CBA_fnc_addBISEventHandler;

private _ctrlAltitudeATL = _ctrlTaskGroup controlsGroupCtrl IDC_ALTITUDE_ATL;
private _ctrlAltitudeATLEdit = _ctrlTaskGroup controlsGroupCtrl IDC_ALTITUDE_ATL_EDIT;

[
	_ctrlAltitudeATL,
	_ctrlAltitudeATLEdit,
	[GVAR(limits) get "altitudeMin",GVAR(limits) get "altitudeMax",0],
	_item get "behaviors" getOrDefault ["altitudeATL",_entity getVariable QPVAR(altitudeATL)],{
		params ["_ctrl","_value"];
		GVAR(plan) # GVAR(planIndex) get "behaviors" set ["altitudeATL",_value];
	},
	LELSTRING(common,meterAcronym)
] call EFUNC(sdf,manageSlider);

private _ctrlAltitudeASL = _ctrlTaskGroup controlsGroupCtrl IDC_ALTITUDE_ASL;
private _ctrlAltitudeASLEdit = _ctrlTaskGroup controlsGroupCtrl IDC_ALTITUDE_ASL_EDIT;

[
	_ctrlAltitudeASL,
	_ctrlAltitudeASLEdit,
	[GVAR(limits) get "altitudeMin",GVAR(limits) get "altitudeMax",0],
	_item get "behaviors" getOrDefault ["altitudeASL",_entity getVariable QPVAR(altitudeASL)],{
		params ["_ctrl","_value"];
		GVAR(plan) # GVAR(planIndex) get "behaviors" set ["altitudeASL",_value];
	},
	LELSTRING(common,meterAcronym)
] call EFUNC(sdf,manageSlider);


