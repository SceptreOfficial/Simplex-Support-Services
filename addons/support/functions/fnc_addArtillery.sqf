#include "script_component.hpp"

params [
	["_requesters",[],[[]]],
	["_vehicle",objNull,[objNull]],
	["_callsign","",[""]],
	["_respawnTime",SSS_DEFAULT_RESPAWN_TIME,[0]],
	["_cooldownDefault",[SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN,SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND],[[]],2],
	["_maxRounds",SSS_DEFAULT_ARTILLERY_MAX_ROUNDS,[0]],
	["_coordinationDistance",SSS_DEFAULT_ARTILLERY_COORDINATION_DISTANCE,[0]],
	["_customInit","",["",{}]]
];

// Validation
if (_callsign isEqualTo "") then {
	_callsign = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
};

if (_maxRounds < 0) then {
	_maxRounds = SSS_DEFAULT_ARTILLERY_MAX_ROUNDS;
};

if (_customInit isEqualType "") then {
	_customInit = compile _customInit;
};

if (!isNull (_vehicle getVariable ["SSS_parentEntity",objNull])) exitWith {
	SSS_ERROR_2("Vehicle is already a support: %1 (%2)",_callsign,_vehicle);
};

if ({isPlayer _x} count crew _vehicle > 0) exitWith {
	SSS_ERROR_2("No players allowed: %1 (%2)",_callsign,_vehicle);
};

if (!alive gunner _vehicle) exitWith {
	SSS_ERROR_2("No gunner in vehicle: %1 (%2)",_callsign,_vehicle);
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addArtillery),2];
	nil
};

// Basic setup
private _entity = true call CBA_fnc_createNamespace;
private _group = group _vehicle;
private _side = side _group;
private _icon = switch (true) do {
	case (_vehicle isKindOf "B_Ship_MRLS_01_base_F") : {ICON_MISSILE};
	case (_vehicle isKindOf "StaticWeapon") : {ICON_MORTAR};
	default {ICON_SELF_PROPELLED};
};

BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,_icon,_customInit,"artillery","artillery");
PHYSICAL_TRAITS(_entity,_vehicle,_group,getPosASL _vehicle,_respawnTime);
CREATE_TASK_MARKER(_entity,_callsign,"mil_warning","Artillery");

// Specifics
_entity setVariable ["SSS_cooldown",0,true];
_entity setVariable ["SSS_cooldownDefault",_cooldownDefault,true];
_entity setVariable ["SSS_maxRounds",_maxRounds,true];
_entity setVariable ["SSS_coordinationDistance",_coordinationDistance,true];

// Assignment
[_requesters,[_entity]] call EFUNC(common,assignRequesters);
SSS_entities pushBack _entity;
publicVariable "SSS_entities";

// Event handlers
[_entity,"Deleted",{_this call EFUNC(common,deletedEntity)}] call CBA_fnc_addBISEventHandler;
[_vehicle,"Deleted",{_this call EFUNC(common,deletedVehicle)}] call CBA_fnc_addBISEventHandler;
[_vehicle,"Killed",{(_this # 0) call EFUNC(common,respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
[gunner _vehicle,"Killed",{vehicle (_this # 0) call EFUNC(common,respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
[_vehicle,"GetOut",{
	params ["_vehicle","_role"];

	if (_role == "gunner") then {
		_vehicle removeEventHandler [_thisType,_thisID];
		_vehicle call EFUNC(common,respawn);
	};
}] call CBA_fnc_addBISEventHandler;

// Commission vehicle
[_entity,_vehicle] call EFUNC(common,commission);

// Execute custom code
_vehicle call _customInit;

_entity
