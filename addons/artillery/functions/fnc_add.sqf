#include "script_component.hpp"

if (!isServer) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(add)]] call CBA_fnc_serverEvent;
	objNull
};

params [
	["_battery",objNull,[objNull,[]]],
	["_callsign","",[""]],
	["_respawnDelay",60,[0]],
	["_relocation",[true,60],[[]],2],
	["_cooldowns",[60,10],[[]],2],
	["_ammunition",[],[[]]],
	["_velocityOverride",false,[false]],
	["_coordinationDistance",1000,[0]],
	["_coordinationType",2,[0]],
	["_icon","",[""]],
	["_executionDelay",[0,0],[[]],2],
	["_firingDelay",[0,0],[[]],2],
	["_sheafTypes",SHEAF_TYPES,[[]]],
	["_maxLoops",10,[0]],
	["_maxLoopDelay",300,[0]],
	["_maxTasks",-1,[0]],
	["_maxRounds",50,[0]],
	["_maxExecDelay",300,[0]],
	["_maxFiringDelay",30,[0]],
	["_vehicleInit",{},[{},""]],
	["_remoteControl",false,[false]],
	["_side",sideEmpty,[sideEmpty]],
	["_remoteAccess",true,[false]],
	["_accessItems",[],[[]]],
	["_accessItemsLogic",false,[false]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]],
	["_authorizations",[],[[]]]
];

// Validation
if (_battery isEqualType objNull) then {
	_battery = [_battery];
};

private _vehicle = _battery # 0;

{
	if (!alive gunner _x) then {
		LOG_ERROR_2(LLSTRING(NoGunnerInVehicle),_callsign,_x)
	};
} forEach _battery;

// Defaults
if (_side isEqualTo sideEmpty) then {_side = side group _vehicle};
if (_callsign isEqualTo "") then {_callsign = getText (configOf _vehicle >> "displayName")};

// Verify and compile ammunitions
if (_ammunition isEqualTo []) then {
	_ammunition = if (_vehicle isKindOf "B_Ship_MRLS_01_base_F") then {
		["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18"]
	} else {
		getArtilleryAmmo [_vehicle]
	};
};

private _revisedAmmunition = [];
private _cfgMagazines = configFile >> "CfgMagazines";

{
	_x params ["_class",["_roundLimit",-1]];

	if (isClass (_cfgMagazines >> _class)) then {
		_revisedAmmunition pushBack [_class,_roundLimit];
	} else {
		LOG_ERROR_1(LLSTRING(InvalidMagazineClass),_class);
	};
} forEach _ammunition;

// Icon detection
if (_icon isEqualTo "") then {
	_icon = ICON_SELF_PROPELLED;

	{
		if (_vehicle isKindOf (_x # 0)) exitWith {_icon = _x # 1}
	} forEach [
		// Mod compat
		["RHS_M119_Base",ICON_HOWITZER],

		// Defaults
		["B_Ship_MRLS_01_base_F",ICON_MISSILE],
		["StaticWeapon",ICON_MORTAR],
		["B_MBT_01_mlrs_base_F",ICON_MRLS],
		["Truck_02_MRL_base_F",ICON_MRLS_TRUCK]
	];
};

// Make sure there is a sheaf type available
_sheafTypes = SHEAF_TYPES arrayIntersect (_sheafTypes apply {toUpper _x});

if (_sheafTypes isEqualTo []) exitWith {
	LOG_ERROR("NO VALID SHEAF TYPES");
	objNull
};

// Register
private _entity = [
	QSERVICE,
	"ARTILLERY",
	QGVAR(gui),
	_callsign,
	typeOf _vehicle,
	_side,
	_icon,
	_vehicleInit,
	_remoteAccess,
	_accessItems,
	_accessItemsLogic,
	_accessCondition,
	_requestCondition,
	_authorizations,
	[_battery,_respawnDelay,_relocation]
] call EFUNC(common,registerSupport);

if (isNull _entity) exitWith {objNull};

// Extras
_entity setVariable [QPVAR(cooldown),_cooldowns # 0,true];
_entity setVariable [QPVAR(roundCooldown),_cooldowns # 1,true];
_entity setVariable [QPVAR(cooldownTimer),0,true];
_entity setVariable [QPVAR(ammunition),_revisedAmmunition,true];
_entity setVariable [QPVAR(velocityOverride),_velocityOverride,true];
_entity setVariable [QPVAR(coordinationDistance),_coordinationDistance,true];
_entity setVariable [QPVAR(coordinationType),_coordinationType,true];
_entity setVariable [QPVAR(executionDelay),_executionDelay,true];
_entity setVariable [QPVAR(firingDelay),_firingDelay,true];
_entity setVariable [QPVAR(sheafTypes),_sheafTypes,true];
_entity setVariable [QPVAR(remoteControl),_remoteControl,true];
_entity setVariable [QPVAR(formCenter),_battery call EFUNC(common,positionAvg),true];
_entity setVariable [QPVAR(guiLimits),createHashMapFromArray [
	["loops",0 max _maxLoops],
	["loopDelay",0 max _maxLoopDelay],
	["tasks",_maxTasks],
	["rounds",1 max _maxRounds],
	["executionDelay",0 max _maxExecDelay],
	["firingDelay",0 max _maxFiringDelay]
],true];

// Commission vehicles
{[_x,_entity] call EFUNC(common,commission)} forEach _battery;

_entity
