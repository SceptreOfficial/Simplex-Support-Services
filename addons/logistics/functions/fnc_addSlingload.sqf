#include "script_component.hpp"

if (!isServer) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(addSlingload)]] call CBA_fnc_serverEvent;
	objNull
};

params [
	["_class","",[""]],
	["_side",sideEmpty,[sideEmpty]],
	["_callsign","",[""]],
	["_cooldowns",[60,10],[[]],2],
	["_altitude",500,[0]],
	["_unloadAltitude",15,[0]],
	["_virtualRunway",[0,0,0],[[]],3],
	["_spawnDistance",6000,[0]],
	["_spawnDelay",[0,0],[[]],2],
	["_capacity",10,[0]],
	["_fulfillment","MULTI",[""]],
	["_referenceAreas",[],[[]]],
	["_listFunction",{},["",{}]],
	["_itemInit",{},["",{}]],
	["_vehicleInit",{},[{},""]],
	["_remoteAccess",true,[false]],
	["_accessItems",[],[[]]],
	["_accessItemsLogic",false,[false]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]],
	["_authorizations",[],[[]]]
];

// Validation
if !(_class isKindOf "Helicopter") exitWith {
	LOG_ERROR_2(LELSTRING(common,InvalidClass),_callsign,_class);
	objNull
};

// Defaults
if (_side isEqualTo sideEmpty) then {_side = west};
if (_callsign isEqualTo "") then {_callsign = getText (configFile >> "CfgVehicles" >> _class >> "displayName")};
if (_listFunction isEqualType "") then {_listFunction = compile _listFunction};
if (_itemInit isEqualType "") then {_itemInit = compile _itemInit};

// Register
private _entity = [
	QSERVICE,
	"SLINGLOAD",
	QGVAR(gui),
	_callsign,
	_class,
	_side,
	ICON_SLINGLOAD,
	_vehicleInit,
	_remoteAccess,
	_accessItems,
	_accessItemsLogic,
	_accessCondition,
	_requestCondition,
	_authorizations
] call EFUNC(common,registerSupport);

if (isNull _entity) exitWith {objNull};

// Extras
_entity setVariable [QPVAR(cooldown),_cooldowns # 0,true];
_entity setVariable [QPVAR(itemCooldown),_cooldowns # 1,true];
_entity setVariable [QPVAR(cooldownTimer),0,true];
_entity setVariable [QPVAR(altitude),_altitude,true];
_entity setVariable [QPVAR(unloadAltitude),_unloadAltitude,true];
_entity setVariable [QPVAR(virtualRunway),_virtualRunway,true];
_entity setVariable [QPVAR(spawnDistance),_spawnDistance,true];
_entity setVariable [QPVAR(spawnDelay),_spawnDelay,true];
_entity setVariable [QPVAR(capacity),_capacity,true];
_entity setVariable [QPVAR(fulfillment),_fulfillment,true];
_entity setVariable [QPVAR(referenceAreas),_referenceAreas,true];
_entity setVariable [QPVAR(listFunction),_listFunction,true];
_entity setVariable [QPVAR(itemInit),_itemInit,true];

_entity
