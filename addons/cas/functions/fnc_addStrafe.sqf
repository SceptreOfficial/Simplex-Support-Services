#include "script_component.hpp"

if (!isServer) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(addStrafe)]] call CBA_fnc_serverEvent;
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
	["_maxSpread",200,[0]],
	["_pylons",[],[[]]],
	["_infiniteAmmo",false,[false]],
	["_targetTypes",STRAFE_TARGETS,[[]]],
	["_countermeasures",true,[false]],
	["_vehicleInit",{},[{},""]],
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

// Defaults
if (_side isEqualTo sideEmpty) then {_side = west};
if (_callsign isEqualTo "") then {_callsign = getText (configFile >> "CfgVehicles" >> _class >> "displayName")};

// Register
private _entity = [
	QSERVICE,
	"STRAFE",
	QGVAR(guiStrafe),
	_callsign,
	_class,
	_side,
	ICON_CAS,
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
	_pylons = _class call EFUNC(common,getPylons);
};

// Extras
_entity setVariable [QPVAR(cooldown),_cooldowns # 0,true];
//_entity setVariable [QPVAR(reservedCooldown),_cooldowns # 1,true];
_entity setVariable [QPVAR(cooldownTimer),0,true];
_entity setVariable [QPVAR(virtualRunway),_virtualRunway,true];
_entity setVariable [QPVAR(spawnDistance),_spawnDistance,true];
_entity setVariable [QPVAR(spawnDelay),_spawnDelay,true];
_entity setVariable [QPVAR(maxSpread),_maxSpread,true];
_entity setVariable [QPVAR(pylons),_pylons,true];
_entity setVariable [QPVAR(infiniteAmmo),_infiniteAmmo,true];
_entity setVariable [QPVAR(targetTypes),_targetTypes,true];
_entity setVariable [QPVAR(countermeasures),_countermeasures,true];

_entity
