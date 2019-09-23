#include "script_component.hpp"

params [
	["_requesters",[],[[]]],
	["_vehicle",objNull,[objNull]],
	["_callsign","",[""]],
	["_respawnTime",SSS_DEFAULT_RESPAWN_TIME,[0]],
	["_customInit","",["",{}]]
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
};

if ({isPlayer _x} count crew _vehicle > 0) exitWith {
	SSS_ERROR_2("No players allowed: %1 (%2)",_callsign,_vehicle);
};

if (!alive driver _vehicle) exitWith {
	SSS_ERROR_2("No driver in vehicle: %1 (%2)",_callsign,_vehicle);
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addCASHelicopter),2];
	nil
};

// Basic setup
private _entity = (createGroup sideLogic) createUnit ["Logic",[-69,-69,0],[],0,"CAN_COLLIDE"];
private _group = group _vehicle;
private _side = side _group;
private _base = createVehicle ["Land_HelipadEmpty_F",[0,0,0],[],0,"CAN_COLLIDE"];
_base setPosASL (getPosASL _vehicle);

BASE_TRAITS(_entity,typeOf _vehicle,_callsign,_side,ICON_HELI,ICON_HELI_YELLOW,ICON_HELI_GREEN,_customInit,"CAS","CASHelicopter");
PHYSICAL_TRAITS(_entity,_vehicle,_group,_base,_respawnTime);
CREATE_TASK_MARKER(_entity,_callsign,"mil_end","CAS");

// Specifics
_entity setVariable ["SSS_awayFromBase",false,true];
_entity setVariable ["SSS_onTask",false,true];
_entity setVariable ["SSS_interrupt",false,true];
_entity setVariable ["SSS_flyingHeight",180,true];
_entity setVariable ["SSS_lightsOn",isLightOn _vehicle,true];
_entity setVariable ["SSS_collisionLightsOn",isCollisionLightOn _vehicle,true];

// Assignment
[_requesters,[_entity]] call EFUNC(common,assignRequesters);
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

nil
