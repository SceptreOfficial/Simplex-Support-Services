#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_display"];

// Register display
uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(guiStrafe)];

// Handle map
private _ctrlMap = _display displayCtrl IDC_MAP;
_ctrlMap setVariable [QEGVAR(sdf,override),GVAR(manualInput)];
_ctrlMap setVariable [QEGVAR(sdf,disableMarkers),!GVAR(visualAids)];
_ctrlMap setVariable [QEGVAR(sdf,skip),true];
[_ctrlMap,[[missionNamespace getVariable [QEGVAR(sdf,mapCenter),getPos player]]],[],[],0,FUNC(gui_map)] call EFUNC(sdf,manageMap);

_ctrlMap setVariable [QGVAR(drawStart1),CBA_missionTime];
_ctrlMap setVariable [QGVAR(drawStart2),CBA_missionTime];
_ctrlMap ctrlAddEventHandler ["Draw",{
	params ["_ctrlMap"];

	private _entity = PVAR(guiEntity);

	if (GVAR(visualAidsLive)) then {
		private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

		if (alive _vehicle) then {
			_ctrlMap drawIcon [ICON_MOVE,RGBA_BLUE,getPos _vehicle,10,10,0,""];
		};
	};

	if (!GVAR(visualAids)) exitWith {};
	
	private _start1 = _ctrlMap getVariable QGVAR(drawStart1);
	private _start2 = _ctrlMap getVariable QGVAR(drawStart2);
	private _prg1 = (CBA_missionTime - _start1) / 5;
	private _prg2 = (CBA_missionTime - _start2) / 2;

	if (_prg1 >= 1) then {_ctrlMap setVariable [QGVAR(drawStart1),CBA_missionTime]};
	if (_prg2 >= 1) then {_ctrlMap setVariable [QGVAR(drawStart2),CBA_missionTime]};

	private _center = GVAR(request) getOrDefault ["posASL",[0,0,0]];
	private _ingress = GVAR(request) getOrDefault ["ingress",-1];
	private _egress = GVAR(request) getOrDefault ["egress",-1];
	private _spread = GVAR(request) getOrDefault ["spread",0];
	private ["_dir","_pos"];

	#define D1 100
	#define D2 20
	#define D3 300
	#define FILL "#(rgb,1,1,1)color(1,1,1,1)"

	if (_ingress < 0) then {
		_dir = 360 * _prg1;
		_pos = _center getPos [D1,_dir];
		_ctrlMap drawTriangle [[_pos getPos [-D2,_dir + 135],_pos getPos [-D2,_dir],_pos getPos [-D2,_dir - 135]],RGBA_BLUE,FILL];
		_dir = _dir - 180;
		_pos = _center getPos [D1,_dir];
		_ctrlMap drawTriangle [[_pos getPos [-D2,_dir + 135],_pos getPos [-D2,_dir],_pos getPos [-D2,_dir - 135]],RGBA_BLUE,FILL];

		if (_spread > 0) then {
			_ctrlMap drawEllipse [_center,_spread,_spread,0,RGBA_RED,""];
		};
	} else {
		if (_egress < 0) then {_egress = (_ingress - 180) call CBA_fnc_simplifyAngle};
		_dir = _ingress;
		_pos = (_center getPos [D2+D3,_dir]) getPos [D3 * _prg2,_dir-180];
		_ctrlMap drawTriangle [[_pos getPos [-D2,_dir + 135],_pos getPos [-D2,_dir],_pos getPos [-D2,_dir - 135]],RGBA_BLUE,FILL];
		_ctrlMap drawArrow [_center getPos [D2+D3,_dir],_center getPos [D2,_dir],RGBA_BLUE];

		if (_spread > 0) then {
			_ctrlMap drawRectangle [_center,10,_spread,_ingress,RGBA_RED,""];
		};
	};

	if (_egress < 0) then {
		_dir = 90 + 360 * _prg1;
		_pos = _center getPos [D1,_dir];
		_ctrlMap drawTriangle [[_pos getPos [D2,_dir + 135],_pos getPos [D2,_dir],_pos getPos [D2,_dir - 135]],RGBA_ORANGE,FILL];
		_dir = _dir - 180;
		_pos = _center getPos [D1,_dir];
		_ctrlMap drawTriangle [[_pos getPos [D2,_dir + 135],_pos getPos [D2,_dir],_pos getPos [D2,_dir - 135]],RGBA_ORANGE,FILL];
	} else {
		_dir = _egress;
		_pos = (_center getPos [D2,_dir]) getPos [D3 * _prg2,_dir];
		_ctrlMap drawTriangle [[_pos getPos [D2,_dir + 135],_pos getPos [D2,_dir],_pos getPos [D2,_dir - 135]],RGBA_ORANGE,FILL];
		_ctrlMap drawArrow [_center getPos [D2,_dir],_center getPos [D2+D3,_dir],RGBA_ORANGE];
	};
}];

// Entity selection / initialize all controls
private _ctrlEntity = _display displayCtrl IDC_ENTITY;
_ctrlEntity setVariable [QEGVAR(common,onEntityChanged),FUNC(guiStrafe_entity)];
[_ctrlEntity,PVAR(guiEntity)] call FUNC(guiStrafe_entity);
