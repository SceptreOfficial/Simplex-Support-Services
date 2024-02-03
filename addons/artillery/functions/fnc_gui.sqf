#include "..\script_component.hpp"
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
	ICON_TARGET,
	ICON_INTEL,
	ICON_DESTROY,
	ICON_HASH,
	ICON_WAIT_GEAR,
	ICON_WAIT_CYCLE
];

// Handle map
private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QEGVAR(sdf,override),GVAR(manualInput)];
_ctrlMap setVariable [QEGVAR(sdf,disableMarkers),!GVAR(visualAids)];
_ctrlMap setVariable [QEGVAR(sdf,skip),true];
[_ctrlMap,[[missionNamespace getVariable [QEGVAR(sdf,mapCenter),getPos player]]],[],[],0,FUNC(gui_map)] call EFUNC(sdf,manageMap);

_ctrlMap ctrlAddEventHandler ["Draw",{ // Range circles
	params ["_ctrlMap"];
	
	if (GVAR(visualAids)) then {
		private _pos = (PVAR(guiEntity) getVariable QPVAR(vehicles)) call EFUNC(common,positionAvg);
		private _icon = PVAR(guiEntity) getVariable QPVAR(icon);

		_ctrlMap drawIcon ["#(rgb,8,8,1)color(0,0,0,0)",RGBA_BLUE,_pos,10,10,0,PVAR(guiEntity) getVariable QPVAR(callsign)];

		{
			_ctrlMap drawIcon [_icon,RGBA_BLUE,getPos _x,10,10,0,""];			
		} forEach (PVAR(guiEntity) getVariable QPVAR(vehicles));
	};

	if (GVAR(plan) isEqualTo [] || !GVAR(rangeIndicators)) exitWith {};

	private _magazine = (GVAR(plan) # GVAR(planIndex) # 2) param [0,""];
	if (_magazine isEqualTo "") exitWith {};

	{
		private _vehicles = _x getVariable [QPVAR(vehicles),[_x]];

		{
			if (!alive _x) then {continue};
			
			([_x,_magazine] call FUNC(calculateRanges)) params ["_min","_max"];
			
			_ctrlMap drawEllipse [_x,_min,_min,0,RGBA_ORANGE,""];
			_ctrlMap drawEllipse [_x,_max,_max,0,RGBA_RED,""];
		} forEach _vehicles;
	} forEach ([PVAR(guiEntity)] + GVAR(coordinated));
}];

// Entity selection / initialize all controls
private _ctrlEntity = _display displayCtrl IDC_ENTITY;
_ctrlEntity setVariable [QEGVAR(common,onEntityChanged),FUNC(gui_entity)];
[_ctrlEntity,PVAR(guiEntity)] call FUNC(gui_entity);
