#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_display"];

// Register display
uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(guiStation)];

// Handle map
private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap ctrlMapAnimAdd [0,missionNamespace getVariable [QEGVAR(sdf,mapScale),(ctrlMapScale _ctrlMap) * 2],missionNamespace getVariable [QEGVAR(sdf,mapCenter),getPos player]];
ctrlMapAnimCommit _ctrlMap;

_ctrlMap setVariable [QGVAR(drawStart),CBA_missionTime];
_ctrlMap ctrlAddEventHandler ["Draw",{
	params ["_ctrlMap"];

	if (!GVAR(visualAids)) exitWith {};

	private _center = PVAR(guiEntity) getVariable QPVAR(base);
	private _start = _ctrlMap getVariable QGVAR(drawStart);
	private _progress = (CBA_missionTime - _start) / 5;

	if (_progress >= 1) then {
		_ctrlMap setVariable [QGVAR(drawStart),CBA_missionTime];
	};

	_ctrlMap drawIcon ["\A3\ui_f\data\map\groupicons\selector_selectable_ca.paa",RGBA_BLUE,_center,20,20,360 * _progress,""];
}];

// Entity selection / initialize all controls
private _ctrlEntity = _display displayCtrl IDC_ENTITY;
_ctrlEntity setVariable [QEGVAR(common,onEntityChanged),FUNC(guiStation_entity)];
[_ctrlEntity,PVAR(guiEntity)] call FUNC(guiStation_entity);
