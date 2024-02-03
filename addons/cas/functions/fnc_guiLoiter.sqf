#include "..\script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_display"];

// Register display
uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(guiLoiter)];

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

	_entity getVariable QPVAR(guiLimits) params ["_altitudeMin","_altitudeMax","_radiusMin","_radiusMax"];
	private _center = GVAR(request) getOrDefault ["posASL",[0,0,0]];
	private _ingress = GVAR(request) getOrDefault ["ingress",-1];
	private _egress = GVAR(request) getOrDefault ["egress",-1];
	private _radius = GVAR(request) getOrDefault ["radius",_radiusMin max LOITER_RADIUS_DEFAULT min _radiusMax];
	private _type = GVAR(request) getOrDefault ["type","CIRCLE_L"];
	
	private _start1 = _ctrlMap getVariable QGVAR(drawStart1);
	private _start2 = _ctrlMap getVariable QGVAR(drawStart2);
	private _prg1 = (CBA_missionTime - _start1) / (5 * (_radius / 300) max 5);
	private _prg2 = (CBA_missionTime - _start2) / 2;

	if (_prg1 >= 1) then {_ctrlMap setVariable [QGVAR(drawStart1),CBA_missionTime]};
	if (_prg2 >= 1) then {_ctrlMap setVariable [QGVAR(drawStart2),CBA_missionTime]};

	if (_type != "HOVER") then {
		_ctrlMap drawEllipse [_center,_radius,_radius,0,RGBA_BLUE,""];
	};

	_radius = _radius max 300;

	#define CSIZE _radius
	#define TSIZE 20
	#define LEAVE 300
	#define FILL "#(rgb,1,1,1)color(1,1,1,1)"

	private ["_dir","_pos"];
	if (_ingress < 0) then {
		_dir = 360 * _prg1;
		_pos = _center getPos [CSIZE,_dir];
		_ctrlMap drawTriangle [[_pos getPos [-TSIZE,_dir + 135],_pos getPos [-TSIZE,_dir],_pos getPos [-TSIZE,_dir - 135]],RGBA_BLUE,FILL];
		_dir = _dir - 180;
		_pos = _center getPos [CSIZE,_dir];
		_ctrlMap drawTriangle [[_pos getPos [-TSIZE,_dir + 135],_pos getPos [-TSIZE,_dir],_pos getPos [-TSIZE,_dir - 135]],RGBA_BLUE,FILL];
	} else {
		if (_egress < 0) then {_egress = _ingress call CBA_fnc_simplifyAngle};
		_dir = _ingress;
		_pos = (_center getPos [CSIZE+LEAVE,_dir]) getPos [LEAVE * _prg2,_dir-180];
		_ctrlMap drawTriangle [[_pos getPos [-TSIZE,_dir + 135],_pos getPos [-TSIZE,_dir],_pos getPos [-TSIZE,_dir - 135]],RGBA_BLUE,FILL];
		_ctrlMap drawArrow [_center getPos [CSIZE+LEAVE,_dir],_center getPos [CSIZE,_dir],RGBA_BLUE];
	};

	if (_egress < 0) then {
		_dir = 90 + 360 * _prg1;
		_pos = _center getPos [CSIZE,_dir];
		_ctrlMap drawTriangle [[_pos getPos [TSIZE,_dir + 135],_pos getPos [TSIZE,_dir],_pos getPos [TSIZE,_dir - 135]],RGBA_ORANGE,FILL];
		_dir = _dir - 180;
		_pos = _center getPos [CSIZE,_dir];
		_ctrlMap drawTriangle [[_pos getPos [TSIZE,_dir + 135],_pos getPos [TSIZE,_dir],_pos getPos [TSIZE,_dir - 135]],RGBA_ORANGE,FILL];
	} else {
		_dir = _egress;
		_pos = (_center getPos [CSIZE,_dir]) getPos [LEAVE * _prg2,_dir];
		_ctrlMap drawTriangle [[_pos getPos [TSIZE,_dir + 135],_pos getPos [TSIZE,_dir],_pos getPos [TSIZE,_dir - 135]],RGBA_ORANGE,FILL];
		_ctrlMap drawArrow [_center getPos [CSIZE,_dir],_center getPos [CSIZE+LEAVE,_dir],RGBA_ORANGE];
	};
}];

// Entity selection / initialize all controls
private _ctrlEntity = _display displayCtrl IDC_ENTITY;
_ctrlEntity setVariable [QEGVAR(common,onEntityChanged),FUNC(guiLoiter_entity)];
[_ctrlEntity,PVAR(guiEntity)] call FUNC(guiLoiter_entity);
