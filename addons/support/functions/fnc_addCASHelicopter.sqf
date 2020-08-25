#include "script_component.hpp"

params [
	["_vehicle",objNull,[objNull]],
	["_callsign","",[""]],
	["_respawnTime",DEFAULT_RESPAWN_TIME,[0]],
	["_customInit",{},[{},""]],
	["_accessItems",[],[[]]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]]
];

// Validation
if (_callsign isEqualTo "") then {
	_callsign = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
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

if (!isNull (_vehicle getVariable ["SSS_parentEntity",objNull])) exitWith {
	SSS_ERROR_2(localize LSTRING(VehicleAlreadyASupport),_callsign,_vehicle);
	objNull
};

if ({isPlayer _x} count crew _vehicle > 0) exitWith {
	SSS_ERROR_2(localize LSTRING(NoPlayersAllowed),_callsign,_vehicle);
	objNull
};

if (!alive driver _vehicle) exitWith {
	SSS_ERROR_2(localize LSTRING(NoDriverInVehicle),_callsign,_vehicle);
	objNull
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addCASHelicopter),2];
	objNull
};

// Basic setup
private _entity = true call CBA_fnc_createNamespace;
private _group = group _vehicle;
private _side = side _group;

BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,ICON_HELI,_customInit,"CAS","CASHelicopter",_accessItems,_accessCondition,_requestCondition);
PHYSICAL_TRAITS(_entity,_vehicle,_group,getPosASL _vehicle,_respawnTime);
CREATE_TASK_MARKER(_entity,_callsign,"mil_end","CAS");

// Specifics
_entity setVariable ["SSS_awayFromBase",false,true];
_entity setVariable ["SSS_onTask",false,true];
_entity setVariable ["SSS_interrupt",false,true];
_entity setVariable ["SSS_flyingHeight",180,true];
_entity setVariable ["SSS_lightsOn",isLightOn _vehicle,true];
_entity setVariable ["SSS_collisionLightsOn",isCollisionLightOn _vehicle,true];

// Assignment
SSS_entities pushBack _entity;
publicVariable "SSS_entities";

// Event handlers
[_entity,"Deleted",{_this call EFUNC(common,deletedEntity)}] call CBA_fnc_addBISEventHandler;
[_vehicle,"Deleted",{_this call EFUNC(common,deletedVehicle)}] call CBA_fnc_addBISEventHandler;
[_vehicle,"Killed",{(_this # 0) call EFUNC(common,respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
[driver _vehicle,"Killed",{vehicle (_this # 0) call EFUNC(common,respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
[_vehicle,"GetOut",{
	params ["_vehicle","_role"];

	if (_role == "driver") then {
		_vehicle removeEventHandler [_thisType,_thisID];
		_vehicle call EFUNC(common,respawn);
	};
}] call CBA_fnc_addBISEventHandler;

// Commission vehicle
[_entity,_vehicle] call EFUNC(common,commission);

// Execute custom code
_vehicle call _customInit;

_entity
