#include "..\script_component.hpp"

private _entity = PVAR(guiEntity);

true call EFUNC(common,gui_close);

if (isRemoteControlling player || !isNull (missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit",objNull])) exitWith {
	player remoteControl objNull;
};

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];
private _turret = missionNamespace getVariable [QGVAR(remoteControlTarget),[]];
private _unit = _vehicle turretUnit _turret;

[_vehicle,_unit,_turret,"GUNNER"] call EFUNC(common,remoteControl);
