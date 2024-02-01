#include "script_component.hpp"
#include "\z\sss\addons\sdf\gui_macros.hpp"
#define CTRL(IDC) _ctrlGroup controlsGroupCtrl IDC

params ["_ctrlEntity","_entity"];

private _display = ctrlParent _ctrlEntity;
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;

GVAR(request) = _entity getVariable [QGVAR(cache),createHashMap];

// Grid
private _posASL = GVAR(request) getOrDefault ["posASL",call FUNC(gui_getPos)];
[_posASL] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];
(CTRL(IDC_GRID_E)) ctrlSetText _easting;
(CTRL(IDC_GRID_N)) ctrlSetText _northing;
[_display displayCtrl IDC_MAP,[[[_posASL]],[],[],0]] call EFUNC(sdf,setValueData);

// Sliders
private _isHelicopter = _entity getVariable [QPVAR(class),""] isKindOf "Helicopter";
[CTRL(IDC_ALTITUDE),CTRL(IDC_ALTITUDE_EDIT),[[800,300] select _isHelicopter,6000,0],"altitude",[2000,500] select _isHelicopter,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_RANGE),CTRL(IDC_RANGE_EDIT),[600,[3500,2500] select _isHelicopter,0],"range",[2000,1000] select _isHelicopter,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_SPREAD),CTRL(IDC_SPREAD_EDIT),[0,_entity getVariable QPVAR(maxSpread),0],"spread",0,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_SEARCH_RADIUS),CTRL(IDC_SEARCH_RADIUS_EDIT),[1,1000,0],"searchRadius",500,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);

// Intervals
[CTRL(IDC_PRIMARY_INTERVAL),GVAR(request) getOrDefault ["interval1",0],{
	params ["_ctrl","_value"];
	GVAR(request) set ["interval1",_value];
	call FUNC(gui_verify);
},LELSTRING(common,secondAcronym)] call EFUNC(sdf,manageNumberbox);

[CTRL(IDC_SECONDARY_INTERVAL),GVAR(request) getOrDefault ["interval2",0],{
	params ["_ctrl","_value"];
	GVAR(request) set ["interval2",_value];
	call FUNC(gui_verify);
},LELSTRING(common,secondAcronym)] call EFUNC(sdf,manageNumberbox);

// Ingress/Egress
[_ctrlGroup,GVAR(request)] call FUNC(gui_initIngressEgress);

// Target search
private _ctrlTarget = CTRL(IDC_TARGET);
private _targetTypes = _entity getVariable [QPVAR(targetTypes),[]];
lbClear _ctrlTarget;

{
	EGVAR(common,targetFormatting) get _x params ["_name","_icon"];
	private _i = _ctrlTarget lbAdd _name;
	_ctrlTarget lbSetPicture [_i,_icon];
	_ctrlTarget lbSetData [_i,_x];
} forEach _targetTypes;

((GVAR(request) getOrDefault ["target",""]) splitString ":") params [["_type",""],["_typeDetail",""]];
_ctrlTarget lbSetCurSel (_targetTypes find _type) max 0;
CTRL(IDC_TARGET_DETAIL) lbSetCurSel ((switch _type do {
	case "LASER" : {["","MATCH"]};
	case "SMOKE";
	case "FLARE" : {["","WHITE","BLACK","RED","ORANGE","YELLOW","GREEN","BLUE","PURPLE"]};
	case "VEHICLES" : {["","STATIC","WHEELED","TRACKED","RADAR"]};
	default {[""]};
}) find _typeDetail);

// Danger close
private _ctrlDangerClose = CTRL(IDC_DANGER_CLOSE);
_ctrlDangerClose lbSetCurSel parseNumber !(GVAR(request) getOrDefault ["dangerClose",false]);
private _tooltip = format [LLSTRING(dangerCloseTooltip),_entity getVariable QPVAR(friendlyRange)];
_ctrlDangerClose lbSetTooltip [0,_tooltip];
_ctrlDangerClose lbSetTooltip [1,_tooltip];

// Distribution toggles
private _ctrlDistribution1 = CTRL(IDC_PRIMARY_DISTRIBUTION);
_ctrlDistribution1 cbSetChecked (GVAR(request) getOrDefault ["distribution1",false]);
_ctrlDistribution1 call FUNC(guiStrafe_distribution);
private _ctrlDistribution2 = CTRL(IDC_SECONDARY_DISTRIBUTION);
_ctrlDistribution2 cbSetChecked (GVAR(request) getOrDefault ["distribution2",false]);
_ctrlDistribution2 call FUNC(guiStrafe_distribution);

// Weapons
private _ctrl1 = CTRL(IDC_PRIMARY);
private _ctrl2 = CTRL(IDC_SECONDARY);
lbClear _ctrl1;
lbClear _ctrl2;
_ctrl2 lbAdd LLSTRING(none);
_ctrl2 lbSetTooltip [0,""];

[_entity getVariable QPVAR(class),_entity getVariable [QPVAR(pylons),[]]] call EFUNC(common,getPylonSelections) params ["_validPylons","_formatPylons"];

GVAR(pylons) = _validPylons;
private _pylon1 = GVAR(request) getOrDefault ["pylon1",[]];
private _pylon2 = GVAR(request) getOrDefault ["pylon2",[]];

if (_pylon1 isEqualTo [] || {!(_pylon1 in _validPylons)}) then {
	_pylon1 = _validPylons param [0,[]];
};

if (_pylon2 isEqualTo []) then {
	_ctrl2 lbSetCurSel 0;
};

{
	_x params ["_pylon","_weaponName","_magazineName","_turretName"];

	private _index1 = _ctrl1 lbAdd _weaponName;
	_ctrl1 lbSetData [_index1,str _pylon];
	_ctrl1 lbSetTextRight [_index1,_magazineName];
	_ctrl1 lbSetTooltip [_index1,_turretName];
	if (_pylon1 isEqualTo _pylon) then {_ctrl1 lbSetCurSel _index1};
	
	private _index2 = _ctrl2 lbAdd _weaponName;
	_ctrl2 lbSetData [_index2,str _pylon];
	_ctrl2 lbSetTextRight [_index2,_magazineName];
	_ctrl2 lbSetTooltip [_index2,_turretName];
	if (_pylon2 isEqualTo _pylon) then {_ctrl2 lbSetCurSel _index2};
} forEach _formatPylons;

FUNC(gui_verify) call CBA_fnc_execNextFrame;
