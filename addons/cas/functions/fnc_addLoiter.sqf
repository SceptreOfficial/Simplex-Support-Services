#include "script_component.hpp"

if (!isServer) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(addLoiter)]] call CBA_fnc_serverEvent;
	objNull
};

params [
	["_class","",[""]],
	["_side",sideEmpty,[sideEmpty]],
	["_callsign","",[""]],
	["_cooldowns",[60,0],[[]],2],
	["_virtualRunway",[0,0,0],[[]],3],
	["_spawnDistance",6000,[0]],
	["_spawnDelay",[0,0],[[]],2],
	["_altitudeLimits",[500,3000],[[]],2],
	["_radiusLimits",[0,2500],[[]],2],
	["_duration",600,[0]],
	["_repositioning",true,[false]],
	["_pylons",[],[[]]],
	["_infiniteAmmo",false,[false]],
	["_friendlyRange",200,[0]],
	["_targetTypes",LOITER_TARGETS,[[]]],
	["_vehicleInit",{},[{},""]],
	["_remoteControl",true,[false]],
	["_remoteAccess",true,[false]],
	["_accessItems",[],[[]]],
	["_accessItemsLogic",false,[false]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]],
	["_authorizations",[],[[]]]
];

// Validation
if !(_class isKindOf "Air") exitWith {
	LOG_ERROR_2(LELSTRING(common,InvalidClass),_callsign,_class);
	objNull
};

if ([_class,true] call BIS_fnc_allTurrets isEqualTo []) exitWith {
	LOG_ERROR_1("CAS Loiter: Invalid class (no turrets available): %1",_class);
	objNull
};

// Defaults
if (_side isEqualTo sideEmpty) then {_side = west};
if (_callsign isEqualTo "") then {_callsign = getText (configFile >> "CfgVehicles" >> _class >> "displayName")};

// Register
private _entity = [
	QSERVICE,
	"LOITER",
	QGVAR(guiLoiter),
	_callsign,
	_class,
	_side,
	ICON_COUNTER_CLOCKWISE,
	_vehicleInit,
	_remoteAccess,
	_accessItems,
	_accessItemsLogic,
	_accessCondition,
	_requestCondition,
	_authorizations
] call EFUNC(common,registerSupport);

if (isNull _entity) exitWith {objNull};

if (_pylons isEqualTo []) then {
	_pylons = [_class,{_turret isNotEqualTo [-1]}] call EFUNC(common,getPylons);
};

// Extras
_entity setVariable [QPVAR(cooldown),_cooldowns # 0,true];
//_entity setVariable [QPVAR(reservedCooldown),_cooldowns # 1,true];
_entity setVariable [QPVAR(cooldownTimer),0,true];
_entity setVariable [QPVAR(virtualRunway),_virtualRunway,true];
_entity setVariable [QPVAR(spawnDistance),_spawnDistance,true];
_entity setVariable [QPVAR(spawnDelay),_spawnDelay,true];
_entity setVariable [QPVAR(duration),_duration,true];
_entity setVariable [QPVAR(repositioning),_repositioning,true];
_entity setVariable [QPVAR(pylons),_pylons,true];
_entity setVariable [QPVAR(infiniteAmmo),_infiniteAmmo,true];
_entity setVariable [QPVAR(friendlyRange),_friendlyRange,true];
_entity setVariable [QPVAR(targetTypes),_targetTypes,true];
_entity setVariable [QPVAR(guiLimits),[
	_altitudeLimits # 0,
	_altitudeLimits # 1,
	_radiusLimits # 0,
	_radiusLimits # 1
],true];

_entity
