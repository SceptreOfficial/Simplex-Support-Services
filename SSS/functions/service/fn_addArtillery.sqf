#include "script_component.hpp"

params [
	["_vehicle",objNull,[objNull]],
	["_callsign","",[""]],
	["_respawnTime",SSS_setting_respawnTimeDefault,[0]],
	["_cooldownDefault",SSS_setting_artilleryCooldownDefault,[[]],2]
];

if (!SSS_postInitDone) exitWith {
	[{SSS_postInitDone},{
		_this remoteExecCall ["SSS_fnc_addArtillery",_this # 0];
	},_this] call CBA_fnc_waitUntilAndExecute;
};

if (!local _vehicle) exitWith {_this remoteExecCall ["SSS_fnc_addArtillery",_vehicle];};

// Validation
if (_callsign isEqualTo "") then {_callsign = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");};
private _side = side _vehicle;
if (_side == sideLogic || _side == sideEmpty) exitWith {SSS_ERROR_2("Invalid artillery vehicle: %1 (%2)",_callsign,_vehicle)};
if !((leader _vehicle) in _vehicle) exitWith {SSS_ERROR_2("Leader is not in artillery vehicle: %1 (%2)",_callsign,_vehicle)};
if (!isNil {_vehicle getVariable "SSS_displayName"}) exitWith {SSS_ERROR_2("Vehicle is already assigned a service: %1 (%2)",_callsign,_vehicle)};

// Basic setup
private _group = group _vehicle;
_group setVariable ["SSS_protectWaypoints",true,true];
SET_VEHICLE_TRAITS_PHYSICAL(_vehicle,_group,getPosASL _vehicle,_side,"artillery",_callsign,_respawnTime)
CREATE_TASK_MARKER(_vehicle,"mil_warning","artillery",_callsign)

// Service specific setup
_vehicle setVariable ["SSS_awayFromBase",false,true];
_vehicle setVariable ["SSS_onTask",false,true];
_vehicle setVariable ["SSS_interrupt",false,true];
_vehicle setVariable ["SSS_cooldown",0,true];
_vehicle setVariable ["SSS_cooldownDefault",_cooldownDefault,true];
_vehicle lockTurret [[0],true];
_vehicle lockCargo true;
{_x disableAI "MOVE";} forEach units _group;

// Assignment
ADD_SUPPORT_VEHICLE(_vehicle,_side,"artillery")
_vehicle addMPEventHandler ["MPKilled",{[_this # 0] call SSS_fnc_respawn;}];
(gunner _vehicle) addMPEventHandler ["MPKilled",{[vehicle (_this # 0),true] call SSS_fnc_respawn;}];

// CBA Event
private _JIPID = ["SSS_supportVehicleAdded",_vehicle] call CBA_fnc_globalEventJIP;
[_JIPID,_vehicle] call CBA_fnc_removeGlobalEventJIP;
_vehicle setVariable ["SSS_addedJIPID",_JIPID,true];
