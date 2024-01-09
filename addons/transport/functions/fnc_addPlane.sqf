#include "script_component.hpp"

if (!isServer) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(addPlane)]] call CBA_fnc_serverEvent;
	objNull
};

params [
	["_vehicle",objNull,[objNull]],
	["_side",sideEmpty,[sideEmpty]],
	["_callsign","",[""]],
	["_respawnDelay",60,[0]],
	//["_relocation",[true,60],[[]],2],
	["_taskTypes",PLANE_TASK_TYPES,[[]]],
	["_altitudeLimits",[0,0],[[]],2],
	["_virtualRunway",[0,0,0],[[]],3],
	["_maxTasks",-1,[0]],
	["_maxTimeout",300,[0]],
	["_vehicleInit",{},[{},""]],
	["_remoteAccess",true,[false]],
	["_accessItems",[],[[]]],
	["_accessItemsLogic",false,[false]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]],
	["_authorizations",[],[[]]]
];

// Validation
if (!alive driver _vehicle) exitWith {
	LOG_ERROR_2(LLSTRING(NoDriverInVehicle),_callsign,_vehicle);
	objNull
};

// Defaults
if (_side isEqualTo sideEmpty) then {_side = side group _vehicle};
if (_callsign isEqualTo "") then {_callsign = getText (configOf _vehicle >> "displayName")};

// Make sure there is a task type available
_taskTypes = PLANE_TASK_TYPES arrayIntersect (_taskTypes apply {toUpper _x});

if (_taskTypes isEqualTo []) exitWith {
	LOG_ERROR("NO VALID TASK TYPES");
	objNull
};

_taskTypes insert [0,["RTB"]];

// Register
private _entity = [
	QSERVICE,
	"PLANE",
	QGVAR(gui),
	_callsign,
	typeOf _vehicle,
	_side,
	ICON_PLANE,
	_vehicleInit,
	_remoteAccess,
	_accessItems,
	_accessItemsLogic,
	_accessCondition,
	_requestCondition,
	_authorizations,
	[_vehicle,_respawnDelay]//,_relocation]
] call EFUNC(common,registerSupport);

if (isNull _entity) exitWith {objNull};

// Extras
_entity setVariable [QPVAR(virtualRunway),_virtualRunway,true];
_entity setVariable [QPVAR(virtualRunwayDir),0,true];
_entity setVariable [QPVAR(taskTypes),_taskTypes,true];
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
