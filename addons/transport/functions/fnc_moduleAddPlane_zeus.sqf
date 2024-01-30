#include "script_component.hpp"

params ["_selection"];

private _vehicles = (_selection param [0,[]]) select {
	alive _x &&
	alive driver _x &&
	_x isKindOf "AllVehicles" &&
	!(_x isKindOf "CAManBase")
};

if (_vehicles isEqualTo []) exitWith {
	ZEUS_MESSAGE("INVALID SELECTION");
};

private _side = side group (_vehicles # 0);

[LLSTRING(ModuleAddPlane_name),[
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,respawnDelay),60],
	["LISTNBOXCB",DESC(taskTypes),[PLANE_TASK_TYPES apply {GVAR(taskNames) get _x},true,5,PLANE_TASK_TYPES]],
	["ARRAY",DESC(altitudeLimits),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,3000]]],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(maxTasks),-1],
	["EDITBOX",DESC(maxTimeout),300],
	["EDITBOX",EDESC(common,vehicleInit),""],
	FINAL_ATTRIBUTES_ZEUS
],{
	params ["_values","_vehicles"];
	_values params [
		"_callsign",
		"_respawnDelay",
		"_taskTypes",
		"_altitudeLimits",
		"_virtualRunway",
		"_maxTasks",
		"_maxTimeout",
		"_vehicleInit",
		"_side",
		"_remoteAccess",
		"_accessItems",
		"_accessItemsLogic",
		"_accessCondition",
		"_requestCondition",
		"_authorizations"
	];

	{
		[
			_x,
			_callsign,
			parseNumber _respawnDelay,
			_taskTypes,
			_altitudeLimits,
			_virtualRunway,
			parseNumber _maxTasks,
			parseNumber _maxTimeout,
			_vehicleInit,
			_side,
			_remoteAccess,
			_accessItems call EFUNC(common,parseList),
			_accessItemsLogic,
			_accessCondition,
			_requestCondition
		] call FUNC(addPlane);
	} forEach _vehicles;

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
},_vehicles] call EFUNC(sdf,dialog);
