#include "script_component.hpp"

if (!isServer) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(addHelicopter)]] call CBA_fnc_serverEvent;
	objNull
};

params [
	["_vehicle",objNull,[objNull]],
	["_side",sideEmpty,[sideEmpty]],
	["_callsign","",[""]],
	["_respawnDelay",60,[0]],
	["_relocation",[true,60],[[]],2],
	["_taskTypes",HELO_TASK_TYPES,[[]]],
	["_altitudeLimits",[0,0],[[]],2],
	["_maxTasks",-1,[0]],
	["_maxTimeout",300,[0]],
	["_vehicleInit",{},[{},""]],
	["_remoteControl",false,[false]],
	["_remoteAccess",true,[false]],
	["_accessItems",[],[[]]],
	["_accessItemsLogic",false,[false]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]],
	["_authorizations",[],[[]]]
];

// Validation
if (!alive driver _vehicle) exitWith {
	ERROR_2(LLSTRING(NoDriverInVehicle),_callsign,_vehicle);
	objNull
};


// Defaults
if (_side isEqualTo sideEmpty) then {_side = side group _vehicle};
if (_callsign isEqualTo "") then {_callsign = getText (configOf _vehicle >> "displayName")};

// Make sure there is a task type available
_taskTypes = HELO_TASK_TYPES arrayIntersect (_taskTypes apply {toUpper _x});

if (_taskTypes isEqualTo []) exitWith {
	ERROR("NO VALID TASK TYPES");
	objNull
};

_taskTypes insert [0,["RTB"]];

// Register
private _entity = [
	QSERVICE,
	"HELICOPTER",
	QGVAR(gui),
	_callsign,
	typeOf _vehicle,
	_side,
	ICON_HELI,
	_vehicleInit,
	_remoteAccess,
	_accessItems,
	_accessItemsLogic,
	_accessCondition,
	_requestCondition,
	_authorizations,
	[_vehicle,_respawnDelay,_relocation]
] call EFUNC(common,registerSupport);

if (isNull _entity) exitWith {objNull};

// Extras
_entity setVariable [QPVAR(taskTypes),_taskTypes,true];
_entity setVariable [QPVAR(remoteControl),_remoteControl,true];
_entity setVariable [QPVAR(guiLimits),createHashMapFromArray [
	["altitudeMin",_altitudeLimits # 0],
	["altitudeMax",_altitudeLimits # 1],
	["tasks",_maxTasks],
	["timeout",0 max _maxTimeout]
],true];

[_entity,false,"",[ELSTRING(common,statusIdleAtBase),[1,1,1,1]]] call EFUNC(common,setStatus);

(_entity getVariable QPVAR(group)) addEventHandler ["WaypointComplete",FUNC(waypointComplete)];

// Commission vehicle
[_vehicle,_entity] call EFUNC(common,commission);

_entity
