#include "..\script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"

params ["_display"];

// Register display
uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(guiBombing)];

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

	if (!GVAR(visualAids)) exitWith {};

	private _entity = PVAR(guiEntity);
	private _center = GVAR(request) getOrDefault ["posASL",[0,0,0]];
	private _ingress = GVAR(request) getOrDefault ["ingress",0];
	private _egress = GVAR(request) getOrDefault ["egress",0];
	private _spread = GVAR(request) getOrDefault ["spread",250 min (_entity getVariable QPVAR(maxSpread))];
	private _spacing = GVAR(request) getOrDefault ["spacing",50];
	private _aircraft = GVAR(request) getOrDefault ["aircraft",3 min (_entity getVariable QPVAR(maxAircraft))];
	
	private _prg1 = (CBA_missionTime - (_ctrlMap getVariable QGVAR(drawStart1))) / 4;
	private _prg2 = (CBA_missionTime - (_ctrlMap getVariable QGVAR(drawStart2))) / 2;
	if (_prg1 >= 1) then {_ctrlMap setVariable [QGVAR(drawStart1),CBA_missionTime]; _prg1 = 0};
	if (_prg2 >= 1) then {_ctrlMap setVariable [QGVAR(drawStart2),CBA_missionTime]; _prg2 = 0};

	{
		if (!alive _vehicle) then {continue};
		_ctrlMap drawIcon [ICON_MOVE,RGBA_BLUE,getPos _x,10,10,0,""];
	} forEach (_entity getVariable [QPVAR(vehicles),[]]);

	//#define CSIZE _spread
	#define TSIZE 20
	#define LEAVE 300
	#define FILL "#(rgb,1,1,1)color(1,1,1,1)"

	private ["_dir","_pos"];

	private _size = (_entity getVariable [QPVAR(class),""]) call EFUNC(common,sizeOf);

	_size = _size / 2;
	_spacing = _size + _spacing;

	private _laneCenter = _center getPos [_spacing * (_aircraft - 1) / 2,_ingress - 90];

	for "_i" from 1 to _aircraft do {
		_ctrlMap drawRectangle [_laneCenter,_size,_spread,_ingress,RGBA_RED,""];
		
		_pos = (_laneCenter getPos [_spread + LEAVE,_ingress]) getPos [(LEAVE - TSIZE) * _prg1,_ingress - 180];
		_dir = _ingress - 180;
		_ctrlMap drawTriangle [[_pos getPos [TSIZE,_dir + 135],_pos getPos [TSIZE,_dir],_pos getPos [TSIZE,_dir - 135]],RGBA_BLUE,FILL];

		_laneCenter = _laneCenter getPos [_spacing,_ingress + 90];
	};

	_ctrlMap drawArrow [_center getPos [_spread + LEAVE,_ingress],_center getPos [_spread,_ingress],RGBA_BLUE];
	_ctrlMap drawArrow [_center getPos [_spread,_ingress - 180],(_center getPos [_spread,_ingress - 180]) getPos [LEAVE,_egress],RGBA_PURPLE];

	_pos = (_center getPos [_spread,_ingress - 180]) getPos [(LEAVE - TSIZE) * _prg1,_egress];
	_dir = _egress;
	_ctrlMap drawTriangle [[_pos getPos [TSIZE,_dir + 135],_pos getPos [TSIZE,_dir],_pos getPos [TSIZE,_dir - 135]],RGBA_PURPLE,FILL];
}];

// Entity selection / initialize all controls
private _ctrlEntity = _display displayCtrl IDC_ENTITY;
_ctrlEntity setVariable [QEGVAR(common,onEntityChanged),FUNC(guiBombing_entity)];
[_ctrlEntity,PVAR(guiEntity)] call FUNC(guiBombing_entity);
