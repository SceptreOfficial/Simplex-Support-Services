#include "script_component.hpp"

params ["_entity","_vehicle"];

if (!local _vehicle || _entity getVariable QPVAR(service) != QSERVICE) exitWith {};

// Handle deletion
[QEGVAR(common,addEventHandler),[_vehicle,"Deleted",{call EFUNC(common,deletedVehicle)}]] call CBA_fnc_serverEvent;

// Respawn on death
[
	[QEGVAR(common,addEventHandler),[_vehicle,"Killed",{call EFUNC(common,respawn)}]] call CBA_fnc_globalEventJIP,
	_vehicle
] call CBA_fnc_removeGlobalEventJIP;

private _driver = driver _vehicle;
_driver setVariable [QPVAR(assignedVehicle),_vehicle,true];

// Respawn if driver leaves
[QEGVAR(common,addEventHandler),[_vehicle,"GetOut",{
	params ["_vehicle","_role"];

	if (_role == "driver") then {
		_vehicle removeEventHandler [_thisType,_thisID];
		_vehicle call EFUNC(common,respawn);
	};
}]] call CBA_fnc_serverEvent;

[
	[QEGVAR(common,addEventHandler),[_driver,"Killed",{
		params ["_unit"];
		(_unit getVariable [QPVAR(assignedVehicle),objNull]) call EFUNC(common,respawn);
		_unit setVariable [QPVAR(assignedVehicle),nil,true];
	}]] call CBA_fnc_globalEventJIP,
	_driver
] call CBA_fnc_removeGlobalEventJIP;

if (GVAR(autoTerminals)) then {
	[_vehicle,_entity] call EFUNC(common,terminal);
};

switch (_entity getVariable QPVAR(supportType)) do {
	case "HELICOPTER" : {
		[FUNC(changeBehavior),[_entity,[
			["combatMode","YELLOW"],
			["lights",true],
			["collisionLights",true],
			["altitudeATL",100],
			["altitudeASL",100]
		]],1] call CBA_fnc_waitAndExecute;

		deleteVehicle (_vehicle getVariable ["ace_fastroping_FRIES",objnull]);
	};
	case "VTOL" : {
		[FUNC(changeBehavior),[_entity,[
			["combatMode","YELLOW"],
			["lights",true],
			["collisionLights",true],
			["altitudeATL",500],
			["altitudeASL",500]
		]],1] call CBA_fnc_waitAndExecute;
	};
	case "PLANE" : {
		[FUNC(changeBehavior),[_entity,[
			["combatMode","YELLOW"],
			["lights",true],
			["collisionLights",true],
			["altitudeATL",1000],
			["altitudeASL",1000]
		]],1] call CBA_fnc_waitAndExecute;

		_vehicle setFuel 0;
	};
	case "LAND" : {
		[FUNC(changeBehavior),[_entity,[
			["combatMode","YELLOW"],
			["lights",true],
			["collisionLights",true]
		]],1] call CBA_fnc_waitAndExecute;
	};
	case "BOAT" : {
		[FUNC(changeBehavior),[_entity,[
			["combatMode","YELLOW"],
			["lights",true],
			["collisionLights",true]
		]],1] call CBA_fnc_waitAndExecute;
	};
};

