#include "script_component.hpp"

params [
	["_requesters",[],[[]]],
	["_classname","",["",objNull]],
	["_callSign","",[""]],
	["_side",sideEmpty,[sideEmpty]],
	["_cooldownDefault",SSS_DEFAULT_COOLDOWN_DRONES,[0]],
	["_loiterTime",SSS_DEFAULT_LOITER_TIME_DRONES,[0]],
	["_customInit","",["",{}]]
];

// Validation
if (_classname isEqualType objNull) then {
	_classname = typeOf _classname;
};

if (_classname isEqualTo "" || !(_classname isKindOf "Plane")) exitWith {
	SSS_ERROR_1("Invalid CAS Drone classname: %1",_classname);
	objNull
};

if (_callsign isEqualTo "") then {
	_callsign = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
};

if (_customInit isEqualType "") then {
	_customInit = compile _customInit;
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addCASDrone),2];
	objNull
};

// Basic setup
private _entity = true call CBA_fnc_createNamespace;

BASE_TRAITS(_entity,_classname,_callsign,_side,ICON_DRONE,_customInit,"CAS","CASDrone");
CREATE_TASK_MARKER(_entity,_callsign,"mil_end","CAS");

// Specifics
_entity setVariable ["SSS_cooldown",0,true];
_entity setVariable ["SSS_cooldownDefault",_cooldownDefault,true];
_entity setVariable ["SSS_loiterTime",_loiterTime,true];
_entity setVariable ["SSS_active",false,true];

// Assignment
[_requesters,[_entity]] call EFUNC(common,assignRequesters);
SSS_entities pushBack _entity;
publicVariable "SSS_entities";

[_entity,"Deleted",{_this call EFUNC(common,deletedEntity)}] call CBA_fnc_addBISEventHandler;

_entity
