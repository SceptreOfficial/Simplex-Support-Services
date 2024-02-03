#include "..\script_component.hpp"
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
[CTRL(IDC_ALTITUDE),CTRL(IDC_ALTITUDE_EDIT),[1000,6000,0],"altitude",2000,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_SPREAD),CTRL(IDC_SPREAD_EDIT),[0,_entity getVariable QPVAR(maxSpread),0],"spread",250,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_SPACING),CTRL(IDC_SPACING_EDIT),[20,250,0],"spacing",50,LELSTRING(common,meterAcronym)] call FUNC(gui_slider);
[CTRL(IDC_AIRCRAFT),CTRL(IDC_AIRCRAFT_EDIT),[1,_entity getVariable QPVAR(maxAircraft),0],"aircraft",3] call FUNC(gui_slider);
[CTRL(IDC_INTERVAL),CTRL(IDC_INTERVAL_EDIT),[0.2,10,1],"interval",0.5,LELSTRING(common,secondAcronym)] call FUNC(gui_slider);

// Ingress/Egress
[_ctrlGroup,GVAR(request),false] call FUNC(gui_initIngressEgress);

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
	//_ctrlWeapon lbSetTooltip [_i,_turretName];
	if (_weapon isEqualTo _pylon) then {_ctrlWeapon lbSetCurSel _i};
} forEach _formatPylons;

FUNC(gui_verify) call CBA_fnc_execNextFrame;
