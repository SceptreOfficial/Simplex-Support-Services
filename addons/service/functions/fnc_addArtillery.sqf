#include "script_component.hpp"

params [
	["_vehicle",objNull,[objNull]],
	["_callsign","",[""]],
	["_respawnTime",parseNumber SSS_DEFAULT_RESPAWN_TIME,[0]],
	["_cooldownDefault",[parseNumber SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN,parseNumber SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND],[[]],2]
];

if (!local _vehicle) exitWith {_this remoteExecCall [QFUNC(addArtillery),_vehicle];};

// Validation
private _side = side _vehicle;
if (_callsign isEqualTo "") then {_callsign = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");};

if !(_side in [west,east,resistance]) exitWith {SSS_ERROR_2("Invalid side: %1 (%2)",_callsign,_vehicle)};
if ({isPlayer _x} count crew _vehicle > 0) exitWith {SSS_ERROR_2("Cannot assign players: %1 (%2)",_callsign,_vehicle)};
if (_vehicle in (missionNamespace getVariable [format ["SSS_artillery_%1",_side],[]])) exitWith {SSS_ERROR_2("Vehicle already assigned: %1 (%2)",_callsign,_vehicle)};
if (!alive gunner _vehicle) exitWith {SSS_ERROR_2("No gunner in vehicle: %1 (%2)",_callsign,_vehicle)};

// Basic setup
private _group = group _vehicle;
SET_VEHICLE_TRAITS_PHYSICAL(_vehicle,_group,getPosASL _vehicle,_side,"artillery",_callsign,_respawnTime)
CREATE_TASK_MARKER(_vehicle,"mil_warning","artillery",_callsign)

// Service specific setup
_vehicle setVariable ["SSS_icon",[ICON_SELF_PROPELLED,ICON_MORTAR] select (_vehicle isKindOf "StaticWeapon"),true];
_vehicle setVariable ["SSS_awayFromBase",false,true];
_vehicle setVariable ["SSS_onTask",false,true];
_vehicle setVariable ["SSS_interrupt",false,true];
_vehicle setVariable ["SSS_cooldown",0,true];
_vehicle setVariable ["SSS_cooldownDefault",_cooldownDefault,true];
_vehicle lockTurret [[0],true];
_vehicle lockCargo true;
{_x disableAI "MOVE";} forEach units _group;

// Assignment
[true,format ["SSS_artillery_%1",_side],_vehicle] remoteExecCall [QEFUNC(common,editServiceArray),2];
[_vehicle,["Deleted",{_this call EFUNC(common,deleted);}]] remoteExecCall ["addEventHandler",0];
_vehicle addMPEventHandler ["MPKilled",{[_this # 0] call EFUNC(common,respawn);}];
(gunner _vehicle) addMPEventHandler ["MPKilled",{[vehicle (_this # 0),true] call EFUNC(common,respawn);}];
[_vehicle,"GetOut",{
	params ["_vehicle","_role","_unit","_turret"];

	if (_role == "gunner") then {
		_vehicle removeEventHandler [_thisType,_thisID];
		[_vehicle,true] call EFUNC(common,respawn);
	};
}] remoteExecCall ["CBA_fnc_addBISEventHandler",2];

// CBA Event
private _JIPID = ["SSS_supportVehicleAdded",_vehicle] call CBA_fnc_globalEventJIP;
[_JIPID,_vehicle] call CBA_fnc_removeGlobalEventJIP;
_vehicle setVariable ["SSS_addedJIPID",_JIPID,true];
