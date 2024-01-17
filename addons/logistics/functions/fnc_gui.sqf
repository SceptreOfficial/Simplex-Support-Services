#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_display"];

// Register display
uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(gui)];

// Handle map
private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QEGVAR(sdf,override),GVAR(manualInput)];
_ctrlMap setVariable [QEGVAR(sdf,disableMarkers),!GVAR(visualAids)];
_ctrlMap setVariable [QEGVAR(sdf,skip),true];
[_ctrlMap,[[missionNamespace getVariable [QEGVAR(sdf,mapCenter),getPos player]]],[],[],0,FUNC(gui_map)] call EFUNC(sdf,manageMap);

_ctrlMap ctrlAddEventHandler ["Draw",{
	params ["_ctrlMap"];

	private _entity = PVAR(guiEntity);

	if (GVAR(visualAidsLive)) then {
		{
			if (alive _x) then {
				_ctrlMap drawIcon [ICON_MOVE,RGBA_BLUE,getPos _x,10,10,0,""];
			};
		} forEach ((_entity getVariable [QPVAR(vehicles),[]]) + [_entity getVariable [QPVAR(vehicle),objNull]]);
	};

	if (!GVAR(visualAids)) exitWith {};

	if (_entity getVariable QPVAR(supportType) != "STATION") then {
		if (_entity getVariable [QPVAR(virtualRunway),[0,0,0]] isNotEqualTo [0,0,0]) then {
			private _center = call FUNC(gui_getPos);
			private _dir = (_entity getVariable QPVAR(virtualRunway)) getDir _center;
			
			_ctrlMap drawArrow [_center getPos [200,_dir - 180],_center getPos [200,_dir],RGBA_BLUE];
		} else {
			
		};
	};
}];

// Entity selection / initialize all controls
private _ctrlEntity = _display displayCtrl IDC_ENTITY;
_ctrlEntity setVariable [QEGVAR(common,onEntityChanged),FUNC(gui_entity)];
[_ctrlEntity,PVAR(guiEntity)] call FUNC(gui_entity);
