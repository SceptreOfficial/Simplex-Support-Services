#include "script_component.hpp"

params [
	["_classname","",["",objNull]],
	["_turretPath",[1],[[]]],
	["_callSign","",[""]],
	["_cooldownDefault",DEFAULT_COOLDOWN_GUNSHIPS,[0]],
	["_loiterTime",DEFAULT_LOITER_TIME_GUNSHIPS,[0]],
	["_customInit",{},[{},""]],
	["_side",sideEmpty,[sideEmpty]],
	["_accessItems",[],[[]]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]]
];

// Validation
if (_classname isEqualType objNull) then {
	_classname = typeOf _classname;
};

if (_classname isEqualTo "" || !(_classname isKindOf "Plane")) exitWith {
	SSS_ERROR_1(localize LSTRING(InvalidCASGunshipClassname),_classname);
	objNull
};

if (_turretPath isEqualTo []) exitWith {
	SSS_ERROR_1(localize LSTRING(InvalidCASGunshipTurretPath),_turretPath);
	objNull
};

if (_callsign isEqualTo "") then {
	_callsign = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
};

if (_customInit isEqualType "") then {
	_customInit = compile _customInit;
};

if (_accessCondition isEqualType "") then {
	_accessCondition = compile _accessCondition;
};

if (_requestCondition isEqualType "") then {
	_requestCondition = compile _requestCondition;
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addCASGunship),2];
	objNull
};

// Basic setup
private _entity = true call CBA_fnc_createNamespace;

BASE_TRAITS(_entity,_classname,_callsign,_side,ICON_GUNSHIP,_customInit,"CAS","CASGunship",_accessItems,_accessCondition,_requestCondition);
CREATE_TASK_MARKER(_entity,_callsign,"mil_end","CAS");

// Specifics
_entity setVariable ["SSS_cooldown",0,true];
_entity setVariable ["SSS_cooldownDefault",_cooldownDefault,true];
_entity setVariable ["SSS_loiterTime",_loiterTime,true];
_entity setVariable ["SSS_active",false,true];
_entity setVariable ["SSS_turretPath",_turretPath,true];

// Assignment
SSS_entities pushBack _entity;
publicVariable "SSS_entities";

[_entity,"Deleted",{_this call EFUNC(common,deletedEntity)}] call CBA_fnc_addBISEventHandler;

_entity
