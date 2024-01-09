#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_display"];

// Register display
uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(gui)];

// Plan header
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlPlanHeader = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN_HEADER;
_ctrlPlanHeader ctrlEnable false;
_ctrlPlanHeader lnbAddRow [];
{_ctrlPlanHeader lnbSetPicture [[0,_forEachIndex],_x]} forEach [
	ICON_INTEL,
	ICON_MAP,
	ICON_WAIT_GEAR
];

// Handle map
private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QEGVAR(sdf,override),GVAR(manualInput)];
_ctrlMap setVariable [QEGVAR(sdf,disableMarkers),!GVAR(visualAids)];
_ctrlMap setVariable [QEGVAR(sdf,skip),true];
//[_ctrlMap,[[getPos (PVAR(guiEntity) getVariable QPVAR(vehicle))]],[],[],0,FUNC(gui_map)] call EFUNC(sdf,manageMap);
[_ctrlMap,[[missionNamespace getVariable [QEGVAR(sdf,mapCenter),getPos player]]],[],[],0,FUNC(gui_map)] call EFUNC(sdf,manageMap);

_ctrlMap ctrlAddEventHandler ["Draw",{
	params ["_ctrlMap"];

	if (!GVAR(visualAids)) exitWith {};

	private _last = getPos (PVAR(guiEntity) getVariable QPVAR(vehicle));

	_ctrlMap drawIcon [PVAR(guiEntity) getVariable QPVAR(icon),RGBA_BLUE,_last,20,20,0,PVAR(guiEntity) getVariable QPVAR(callsign)];

	{
		private _posASL = _x get "posASL";
   		//_ctrlMap drawIcon [ICON_UNCHECKED,RGBA_BLUE,_posASL,10,10,0,GVAR(taskNames) get (_x get "task")];
   		_ctrlMap drawIcon [GVAR(taskIcons) get (_x get "task"),RGBA_BLUE,_posASL,15,15,0,GVAR(taskNames) get (_x get "task")];
		_ctrlMap drawLine [_last,_posASL,RGBA_BLUE];
		_last = _posASL;
	} forEach GVAR(plan);
}];

private _ctrlMapText = _display displayCtrl IDC_MAP_TEXT;
_ctrlMapText ctrlSetText "CTRL: Add task";
ctrlPosition _ctrlMapText params ["_cX","_cY"];
private _width = CTRL_W(4);
private _height = CTRL_H(1);
_ctrlMapText ctrlSetPosition [_cX - _width,_cY - _height,_width,_height];
_ctrlMapText ctrlCommit 0;

// Entity selection / initialize all controls
private _ctrlEntity = _display displayCtrl IDC_ENTITY;
_ctrlEntity setVariable [QEGVAR(common,onEntityChanged),FUNC(gui_entity)];
[_ctrlEntity,PVAR(guiEntity)] call FUNC(gui_entity);
