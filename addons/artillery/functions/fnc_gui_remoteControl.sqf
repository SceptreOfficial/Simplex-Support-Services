#include "script_component.hpp"

private _entity = PVAR(guiEntity);

true call EFUNC(common,gui_close);

if (isRemoteControlling player || !isNull (missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit",objNull])) exitWith {
	player remoteControl objNull;
};

private _vehicles = _entity getVariable [QPVAR(vehicles),[]];
private _index = _vehicles findIf {
	private _gunner = effectiveCommander gunner _x;
	alive _gunner && !(_gunner call EFUNC(common,isRemoteControlled))
};

if (_index == -1) exitWith {
	LOG_WARNING(LLSTRING(noRecipientsAvailable));
};

private _vehicle = _vehicles # _index;

[_vehicle,gunner _vehicle] call EFUNC(common,remoteControl);
