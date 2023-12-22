#include "script_component.hpp"

if (!isServer) exitWith {[QGVAR(respawn),_this] call CBA_fnc_serverEvent};

params ["_vehicle"];

private _entity = _vehicle getVariable [QPVAR(entity),objNull];

if (isNull _vehicle || isNull _entity) exitWith {};

_vehicle setVariable [QPVAR(entity),nil,true];

private _respawnDelay = _entity getVariable [QPVAR(respawnDelay),-1];

if (_respawnDelay < 0) exitWith {
	_entity call FUNC(removeEntity);
};

if (isNil {_entity getVariable QPVAR(vehicles)}) then {
	_entity setVariable [QPVAR(vehicle),objNull,true];

	private _group = _entity getVariable [QPVAR(group),group _vehicle];
	{deleteWaypoint [_group,0]} forEach (waypoints _group);
	private _wp = _group addWaypoint [_entity getVariable QPVAR(base),-1,0];
	_wp setWaypointType "MOVE";

	[_entity,true,"RESPAWN",[LSTRING(statusRespawn),RGBA_RED]] call FUNC(setStatus);
	
	[_entity getVariable QPVAR(base),_entity getVariable QPVAR(baseNormal),_entity getVariable QPVAR(class),_entity getVariable QPVAR(vehicleCustomization)]
} else {
	private _vehicles = _entity getVariable QPVAR(vehicles);
	_vehicles deleteAt (_vehicles find _vehicle);
	_entity setVariable [QPVAR(vehicles),_vehicles,true];

	if ({alive _x} count _vehicles == 0) then {
		[_entity,true,"RESPAWN",[LSTRING(statusRespawn),RGBA_RED]] call FUNC(setStatus);
	};

	[_vehicle getVariable QPVAR(base),_vehicle getVariable QPVAR(baseNormal),typeOf _vehicle,_vehicle getVariable QPVAR(vehicleCustomization)]
} params ["_base","_normal","_class","_customization"];

_vehicle call FUNC(decommission);

private _group = group _vehicle;
private _units = PRIMARY_CREW(_vehicle) + (_vehicle getVariable [QPVAR(crew),[]]);

if (OPTION(cleanupCrew)) then {
	{
		_vehicle deleteVehicleCrew _x;
		deleteVehicle _x;
	} forEach _units;
} else {
	[QEGVAR(common,leaveVehicle),[_group,_vehicle],_group] call CBA_fnc_targetEvent;
	[QEGVAR(common,orderGetIn),[PRIMARY_CREW(_vehicle),false],_vehicle] call CBA_fnc_targetEvent;
	_units joinSilent createGroup [side _group,true];
};

[_entity,[0,0,0]] call EFUNC(common,updateMarker);

NOTIFY_1(_entity,LSTRING(VehicleReplacementETA),_respawnDelay call EFUNC(common,formatTime));
DEBUG_2("%1: Vehicle respawning in %2s",_entity getVariable QPVAR(callsign),_respawnDelay);

[QGVAR(respawnStart),[_entity]] call CBA_fnc_serverEvent;

[{
	params ["_entity","_base","_normal","_class","_customization"];

	if (isNull _entity) exitWith {};

	[_base,_class] call FUNC(clearObstructions);

	[{
		params ["_entity","_base","_normal","_class","_customization"];

		if (isNull _entity) exitWith {};

		private _vehicle = _class createVehicle [0,0,0];
		[_vehicle,_base] call FUNC(placementSearch) params ["_safePos","_safeUp"];

		if (!isNil "_safePos") then {
			_vehicle setPosASL _safePos;
			_vehicle setVectorDirAndUp [_normal # 0,_safeUp];
		} else {
			_vehicle setPosASL _base;
			_vehicle setVectorDirAndUp _normal;
		};

		([_vehicle] + (_entity getVariable [QPVAR(vehicleCustomization),_customization])) call BIS_fnc_initVehicle;
		[_entity,_vehicle] call FUNC(restoreCrew);

		private _vehicles = _entity getVariable QPVAR(vehicles);

		if (isNil "_vehicles") then {
			_entity setVariable [QPVAR(vehicle),_vehicle,true];
			[_entity] call FUNC(setStatus);
		} else {
			if ({alive _x} count _vehicles == 0) then {
				[_entity] call FUNC(setStatus);
			};
			
			_entity setVariable [QPVAR(vehicles),_vehicles + [_vehicle],true];
		};

		_vehicle setVariable [QPVAR(base),_base,true];
		_vehicle setVariable [QPVAR(baseNormal),_normal,true];

		[_vehicle,_entity] call EFUNC(common,commission);

		NOTIFY(_entity,LSTRING(VehicleReplacementArrived));

		[QGVAR(respawnComplete),[_entity,_vehicle]] call CBA_fnc_serverEvent;
	},_this,1] call CBA_fnc_waitAndExecute;
},[_entity,_base,_normal,_class,_customization],_respawnDelay] call CBA_fnc_waitAndExecute;
