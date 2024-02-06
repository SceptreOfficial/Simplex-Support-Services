#include "..\script_component.hpp"

private _entity = PVAR(guiEntity);

true call EFUNC(common,gui_close);

if (isRemoteControlling player || !isNull (missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit",objNull])) exitWith {
	player remoteControl objNull;
};

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if ([_vehicle,driver _vehicle,[-1]] call EFUNC(common,remoteControl)) then {
	[_vehicle,true] call FUNC(abortControlScripts);
};
