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

// Type
private _ctrlType = CTRL(IDC_TYPE);
private _ctrlTypeAlt = CTRL(IDC_TYPE_ALT);

if (_entity getVariable [QPVAR(class),""] isKindOf "Helicopter") then {
	_ctrlType ctrlShow false;
	_ctrlTypeAlt ctrlShow true;
	_ctrlTypeAlt lbSetCurSel (["CIRCLE","CIRCLE_L","HOVER"] find (GVAR(request) getOrDefault ["type","CIRCLE_L"]));
} else {
	_ctrlTypeAlt ctrlShow false;
	_ctrlType ctrlShow true;
	_ctrlType lbSetCurSel (["CIRCLE","CIRCLE_L"] find (GVAR(request) getOrDefault ["type","CIRCLE_L"]));
};

// Speed mode
CTRL(IDC_SPEED_MODE) lbSetCurSel (["LIMITED","NORMAL"] find (GVAR(request) getOrDefault ["speedMode","NORMAL"]));

// Sliders
_entity getVariable QPVAR(guiLimits) params ["_altitudeMin","_altitudeMax","_radiusMin","_radiusMax"];
[CTRL(IDC_ALTITUDE),CTRL(IDC_ALTITUDE_EDIT),[_altitudeMin,_altitudeMax,0],"altitude",_altitudeMin max LOITER_ALTITUDE_DEFAULT min _altitudeMax,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_RADIUS),CTRL(IDC_RADIUS_EDIT),[_radiusMin,_radiusMax,0],"radius",_radiusMin max LOITER_RADIUS_DEFAULT min _radiusMax,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_SPREAD),CTRL(IDC_SPREAD_EDIT),[0,30,0],"spread",0,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_BURST_DURATION),CTRL(IDC_BURST_DURATION_EDIT),[0.1,10,1],"duration",3,LELSTRING(common,secondAcronym)] call FUNC(gui_slider);
[CTRL(IDC_BURST_INTERVAL),CTRL(IDC_BURST_INTERVAL_EDIT),[-1,30,0],"interval",-1,LELSTRING(common,secondAcronym)] call FUNC(gui_slider);

// Ingress/Egress
[_ctrlGroup,GVAR(request)] call FUNC(gui_initIngressEgress);

// Target search
private _ctrlTarget = CTRL(IDC_TARGET);
private _ctrlTargetDetail = CTRL(IDC_TARGET_DETAIL);
private _targetTypes = _entity getVariable [QPVAR(targetTypes),[]];
_targetTypes insert [0,[""],true];
lbClear _ctrlTarget;

{
	GVAR(targetFormatting) get _x params ["_name","_icon"];
	private _i = _ctrlTarget lbAdd _name;
	_ctrlTarget lbSetData [_i,_x];
	_ctrlTarget lbSetPicture [_i,_icon];
} forEach _targetTypes;

((GVAR(request) getOrDefault ["target",""]) splitString ":") params [["_type",""],["_typeDetail",""]];
_ctrlTarget lbSetCurSel (_targetTypes find _type) max 0;
_ctrlTargetDetail lbSetCurSel (["","WHITE","BLACK","RED","ORANGE","YELLOW","GREEN","BLUE","PURPLE"] find _typeDetail);

// Weapons
private _ctrlWeapon = CTRL(IDC_WEAPON);
lbClear _ctrlWeapon;

[_entity getVariable QPVAR(class),_entity getVariable [QPVAR(pylons),[]]] call EFUNC(common,getPylonSelections) params ["_validPylons","_formatPylons"];
GVAR(pylons) = _validPylons;
private _weapon = GVAR(request) getOrDefault ["weapon",[]];

if (_weapon isEqualTo [] || {!(_weapon in _validPylons)}) then {
	_weapon = _validPylons param [0,[]];
};

{
	_x params ["_pylon","_weaponName","_magazineName","_turretName"];

	private _i = _ctrlWeapon lbAdd _weaponName;
	_ctrlWeapon lbSetData [_i,str _pylon];
	_ctrlWeapon lbSetTextRight [_i,_magazineName];
	_ctrlWeapon lbSetTooltip [_i,_turretName];
	if (_weapon isEqualTo _pylon) then {_ctrlWeapon lbSetCurSel _i};
} forEach _formatPylons;

// Danger close
private _ctrlDangerClose = CTRL(IDC_DANGER_CLOSE);
_ctrlDangerClose lbSetCurSel parseNumber !(GVAR(request) getOrDefault ["dangerClose",false]);
private _tooltip = format [LLSTRING(dangerCloseTooltip),_entity getVariable QPVAR(friendlyRange)];
_ctrlDangerClose lbSetTooltip [0,_tooltip];
_ctrlDangerClose lbSetTooltip [1,_tooltip];

// Remote control
GVAR(remoteControlTurrets) = [];
private _class = _entity getVariable QPVAR(class);
private _cfg = configFile >> "CfgVehicles" >> _class;
private _ctrlRCSelect = _ctrlGroup controlsGroupCtrl IDC_REMOTE_CONTROL_SELECT;
lbClear _ctrlRCSelect;

{
	private _turret = _x;
	private _turretCfg = _cfg;
	
	{
		if (_x < 0) exitWith {_turretCfg = configNull};
		_turretCfg = ("true" configClasses (_turretCfg >> "turrets")) param [_x,configNull];
	} forEach _turret;

	if (isNull _turretCfg) then {continue};

	private _turretName = getText (_turretCfg >> "gunnerName");
	if (_turretName isEqualTo "") then {_turretName = configName _turretCfg};

	GVAR(remoteControlTurrets) pushBack _turret;

	private _i = _ctrlRCSelect lbAdd _turretName;
	_ctrlRCSelect lbSetTextRight [_i,str _turret];
} forEach ([_class,true] call BIS_fnc_allTurrets);

_ctrlRCSelect lbSetCurSel (_entity getVariable [QGVAR(rcIndex),0]);

FUNC(gui_verify) call CBA_fnc_execNextFrame;
