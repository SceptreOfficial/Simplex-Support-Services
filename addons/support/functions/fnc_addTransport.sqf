#include "script_component.hpp"

params [
	["_requesters",[],[[]]],
	["_vehicle",objNull,[objNull]],
	["_callsign","",[""]],
	["_respawnTime",DEFAULT_RESPAWN_TIME,[0]],
	["_customInit","",["",{}]],
	["_disableRespawn",false,[false]]
];

// Validation
if (_callsign isEqualTo "") then {
	_callsign = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
};

if (_customInit isEqualType "") then {
	_customInit = compile _customInit;
};

if (!isNull (_vehicle getVariable ["SSS_parentEntity",objNull])) exitWith {
	SSS_ERROR_2("Vehicle is already a support: %1 (%2)",_callsign,_vehicle);
	objNull
};

if ({isPlayer _x} count crew _vehicle > 0) exitWith {
	SSS_ERROR_2("No players allowed: %1 (%2)",_callsign,_vehicle);
	objNull
};

if (!alive driver _vehicle) exitWith {
	SSS_ERROR_2("No driver in vehicle: %1 (%2)",_callsign,_vehicle);
	objNull
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addTransport),2];
	objNull
};

// Basic setup
private _entity = true call CBA_fnc_createNamespace;
private _group = group _vehicle;
private _side = side _group;

switch (true) do {
	case (_vehicle isKindOf "Helicopter") : {
		BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,ICON_HELI,_customInit,"Transport","transportHelicopter");
		PHYSICAL_TRAITS(_entity,_vehicle,_group,getPosASL _vehicle,_respawnTime);
		CREATE_TASK_MARKER(_entity,_callsign,"mil_end","Air Transport");

		// Specifics
		_entity setVariable ["SSS_awayFromBase",false,true];
		_entity setVariable ["SSS_onTask",false,true];
		_entity setVariable ["SSS_interrupt",false,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
		_entity setVariable ["SSS_signalApproved",false,true];
		_entity setVariable ["SSS_deniedSignals",[],true];
		_entity setVariable ["SSS_slingLoadReady",false,true];
		_entity setVariable ["SSS_slingLoadObject",objNull,true];
		_entity setVariable ["SSS_flyingHeight",80,true];
		_entity setVariable ["SSS_speedMode",1,true];
		_entity setVariable ["SSS_combatMode",0,true];
		_entity setVariable ["SSS_lightsOn",isLightOn _vehicle,true];
		_entity setVariable ["SSS_collisionLightsOn",isCollisionLightOn _vehicle,true];
	};

	case (_vehicle isKindOf "VTOL_Base_F") : {
		BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,ICON_VTOL,_customInit,"Transport","transportVTOL");
		PHYSICAL_TRAITS(_entity,_vehicle,_group,getPosASL _vehicle,_respawnTime);
		CREATE_TASK_MARKER(_entity,_callsign,"mil_end","Air Transport");

		// Specifics
		_entity setVariable ["SSS_awayFromBase",false,true];
		_entity setVariable ["SSS_onTask",false,true];
		_entity setVariable ["SSS_interrupt",false,true];
		_entity setVariable ["SSS_needConfirmation",false,true];
		_entity setVariable ["SSS_signalApproved",false,true];
		_entity setVariable ["SSS_deniedSignals",[],true];
		_entity setVariable ["SSS_flyingHeight",250,true];
		_entity setVariable ["SSS_speedMode",1,true];
		_entity setVariable ["SSS_combatMode",0,true];
		_entity setVariable ["SSS_lightsOn",isLightOn _vehicle,true];
		_entity setVariable ["SSS_collisionLightsOn",isCollisionLightOn _vehicle,true];
	};

	case (_vehicle isKindOf "Plane") : {
		BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,ICON_PLANE,_customInit,"Transport","transportPlane");
		PHYSICAL_TRAITS(_entity,_vehicle,_group,getPosASL _vehicle,_respawnTime);
		CREATE_TASK_MARKER(_entity,_callsign,"mil_end","Air Transport");

		// Specifics
		_vehicle setFuel 0;
		_entity setVariable ["SSS_awayFromBase",false,true];
		_entity setVariable ["SSS_onTask",false,true];
		_entity setVariable ["SSS_interrupt",false,true];
		_entity setVariable ["SSS_flyingHeight",500,true];
		_entity setVariable ["SSS_speedMode",1,true];
		_entity setVariable ["SSS_combatMode",0,true];
		_entity setVariable ["SSS_lightsOn",isLightOn _vehicle,true];
		_entity setVariable ["SSS_collisionLightsOn",isCollisionLightOn _vehicle,true];
	};

	case (_vehicle isKindOf "Ship") : {
		BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,ICON_BOAT,_customInit,"Transport","transportMaritime");
		PHYSICAL_TRAITS(_entity,_vehicle,_group,getPosASL _vehicle,_respawnTime);
		CREATE_TASK_MARKER(_entity,_callsign,"mil_end","Sea Transport");

		// Specifics
		_entity setVariable ["SSS_awayFromBase",false,true];
		_entity setVariable ["SSS_onTask",false,true];
		_entity setVariable ["SSS_interrupt",false,true];
		_entity setVariable ["SSS_speedMode",2,true];
		_entity setVariable ["SSS_combatMode",0,true];
		_entity setVariable ["SSS_lightsOn",isLightOn _vehicle,true];
		_entity setVariable ["SSS_collisionLightsOn",isCollisionLightOn _vehicle,true];
	};

	case (_vehicle isKindOf "LandVehicle") : {
		BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,ICON_CAR,_customInit,"Transport","transportLandVehicle");
		PHYSICAL_TRAITS(_entity,_vehicle,_group,getPosASL _vehicle,_respawnTime);
		CREATE_TASK_MARKER(_entity,_callsign,"mil_end","Land Transport");

		// Specifics
		_entity setVariable ["SSS_awayFromBase",false,true];
		_entity setVariable ["SSS_onTask",false,true];
		_entity setVariable ["SSS_interrupt",false,true];
		_entity setVariable ["SSS_speedMode",2,true];
		_entity setVariable ["SSS_combatMode",0,true];
		_entity setVariable ["SSS_lightsOn",isLightOn _vehicle,true];
	};
};

// Assignment
[_requesters,[_entity]] call EFUNC(common,assignRequesters);
SSS_entities pushBack _entity;
publicVariable "SSS_entities";

// Event handlers
[_entity,"Deleted",{_this call EFUNC(common,deletedEntity)}] call CBA_fnc_addBISEventHandler;
[_vehicle,"Deleted",{_this call EFUNC(common,deletedVehicle)}] call CBA_fnc_addBISEventHandler;

private _addEH = {
	params ["_vehicle", "_entity", "_vehicleKilledCallback", "_driverKilledCallback", "_getOutCallback"];

	[_vehicle,"Killed",_vehicleKilledCallback,_entity] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
	[driver _vehicle,"Killed",_driverKilledCallback,_entity] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
	[_vehicle,"GetOut",_getOutCallback] call CBA_fnc_addBISEventHandler;
};

private _vehicleKilledCallback = {(_this # 0) call EFUNC(common,respawn)};
private _driverKilledCallback = {vehicle (_this # 0) call EFUNC(common,respawn)};
private _getOutCallback = {
	params ["_vehicle","_role"];

	if (_role == "driver" && {!(isPlayer (driver _vehicle))}) then {
		_vehicle removeEventHandler [_thisType,_thisID];
		_vehicle call EFUNC(common,respawn);
	};
};

if (_disableRespawn) then {
	_vehicleKilledCallback = {_thisArgs call EFUNC(common,deletedEntity)};
	_driverKilledCallback = {_thisArgs call EFUNC(common,deletedEntity)};
	[_vehicle, _entity, _vehicleKilledCallback, _driverKilledCallback, _getOutCallback] call _addEH;
} else {
	[_vehicle, _entity, _vehicleKilledCallback, _driverKilledCallback, _getOutCallback] call _addEH;
};

// Commission vehicle
[_entity,_vehicle] call EFUNC(common,commission);

// Execute custom code
_vehicle call _customInit;

_entity
