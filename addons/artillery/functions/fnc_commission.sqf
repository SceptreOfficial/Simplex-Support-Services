#include "..\script_component.hpp"

params ["_entity","_vehicle"];

if (!local _vehicle || _entity getVariable QPVAR(service) != QSERVICE) exitWith {};

// Handle deletion
[QEGVAR(common,addEventHandler),[_vehicle,"Deleted",{call EFUNC(common,deletedVehicle)}]] call CBA_fnc_serverEvent;

// Respawn on death
[
	[QEGVAR(common,addEventHandler),[_vehicle,"Killed",{call EFUNC(common,respawn)}]] call CBA_fnc_globalEventJIP,
	_vehicle
] call CBA_fnc_removeGlobalEventJIP;

private _gunner = gunner _vehicle;
_gunner setVariable [QPVAR(assignedVehicle),_vehicle,true];

[
	[QEGVAR(common,addEventHandler),[_gunner,"Killed",{
		params ["_unit"];
		(_unit getVariable [QPVAR(assignedVehicle),objNull]) call EFUNC(common,respawn);
		_unit setVariable [QPVAR(assignedVehicle),nil,true];
	}]] call CBA_fnc_globalEventJIP,
	_gunner
] call CBA_fnc_removeGlobalEventJIP;

// Respawn if gunner leaves
[QEGVAR(common,addEventHandler),[_vehicle,"GetOut",{
	params ["_vehicle","_role"];

	if (_role == "gunner") then {
		_vehicle removeEventHandler [_thisType,_thisID];
		_vehicle call EFUNC(common,respawn);
	};
}]] call CBA_fnc_serverEvent;

// Handle round limits
[
	[QEGVAR(common,addEventHandler),[_vehicle,"Fired",{
		params ["_vehicle","","","","","_magazine"];
		
		if (!local _vehicle) exitWith {};

		private _entity = _vehicle getVariable [QPVAR(entity),objNull];

		if (isNull _entity) exitWith {
			_vehicle removeEventHandler [_thisEvent,_thisEventHandler];
		};

		[QGVAR(fired),[_entity,_vehicle,_magazine]] call CBA_fnc_serverEvent;
	}]] call CBA_fnc_globalEventJIP,
	_vehicle
] call CBA_fnc_removeGlobalEventJIP;

if (GVAR(autoTerminals)) then {
	[_vehicle,_entity] call EFUNC(common,terminal);
};

// Vehicle specifics
[{
	params ["_entity","_vehicle"];

	[QEGVAR(common,enableAIFeature),[_vehicle,["PATH",(_entity getVariable [QPVAR(task),""]) == "RELOCATE"]]] call CBA_fnc_localEvent;
	[QEGVAR(common,enableAIFeature),[_vehicle,["TARGET",false]]] call CBA_fnc_localEvent;
	[QEGVAR(common,enableAIFeature),[_vehicle,["AUTOTARGET",false]]] call CBA_fnc_localEvent;
	[QEGVAR(common,enableAIFeature),[_vehicle,["AUTOCOMBAT",false]]] call CBA_fnc_localEvent;
	
	_vehicle lockTurret [[0],true];
	_vehicle lockCargo true;
	_vehicle setVariable [QGVAR(velocityOverride),_entity getVariable QPVAR(velocityOverride),true];
},_this,1] call CBA_fnc_waitAndExecute;

_vehicle setVariable [QGVAR(formOffset),getPosASL _vehicle vectorDiff (_entity getVariable QPVAR(formCenter))];

// Set up valid magazines
private _turret = _vehicle unitTurret gunner _vehicle;
{_vehicle removeMagazineTurret [_x,_turret]} forEach (_vehicle magazinesTurret _turret);

{
	_x params ["_class","_roundLimit"];
	
	if (_roundLimit == 0) then {continue};

	if (_roundLimit > 0) then {
		_vehicle addMagazineTurret [_class,_turret,_roundLimit];
	} else {
		_vehicle addMagazineTurret [_class,_turret];
	};
} forEach (_entity getVariable QPVAR(ammunition));
