#include "script_component.hpp"

if (!isServer) exitWith {};

params ["_vehicle",["_crewDead",false]];

// Sometimes killed EH fires twice. Idk why
if (!isNil {_vehicle getVariable "SSS_respawning"}) exitWith {};
_vehicle setVariable ["SSS_respawning",true];

[
	_vehicle getVariable "SSS_base",_vehicle getVariable "SSS_classname",
	_vehicle getVariable "SSS_side",_vehicle getVariable "SSS_service",
	_vehicle getVariable "SSS_displayName",_vehicle getVariable "SSS_respawnTime",
	_vehicle getVariable "SSS_marker",_vehicle getVariable "SSS_addedJIPID"
] params ["_base","_classname","_side","_service","_callsign","_respawnTime","_marker","_JIPID"];

private _basePosASL = if (_base isEqualType objNull) then {
	private _basePosASL = getPosASL _base;
	deleteVehicle _base;
	_basePosASL
} else {
	_base
};

if (_respawnTime >= 0) then {
	private _message = format ["Support vehicle replacement will be available in %1 seconds.",_respawnTime];
	NOTIFY(_vehicle,_message)
} else {
	NOTIFY(_vehicle,"Support vehicle no longer available.")
};

// Cleanup
[_JIPID] call CBA_fnc_removeGlobalEventJIP;
deleteMarker _marker;
private _serviceString = format ["SSS_%1_%2",_service,_side];
private _serviceArray = missionNamespace getVariable _serviceString;
if (_crewDead) then {
	missionNamespace setVariable [_serviceString,_serviceArray - [_vehicle],true];

	{_vehicle setVariable [_x,nil,true];} forEach ((allVariables _vehicle) select {(_x select [0,4]) == "sss_"});
	{
		_x enableAI "SUPPRESSION";
		_x enableAI "COVER";
		_x enableAI "AUTOCOMBAT";
		_x enableAI "MOVE";
		[_x] orderGetIn false;
	} forEach units group _vehicle;
	group _vehicle enableAttack true;
	_vehicle lockTurret [[0],false];
	_vehicle lockCargo false;
	_vehicle lockDriver false;
} else {
	missionNamespace setVariable [_serviceString,_serviceArray select {alive _x},true];
};

// _respawnTime of -1 = no respawn
if (_respawnTime >= 0) then {
	[{
		params ["_classname","_callsign","_basePosASL","_respawnTime","_service"];

		// Clear obstructions
		private _obstructions = nearestObjects [ASLtoAGL _basePosASL,["LandVehicle","Air","Ship"],6,true];
		if !(_obstructions isEqualTo []) then {
			{
				private _vehicle = _x;
				{_vehicle deleteVehicleCrew _x} forEach crew _x;
				deleteVehicle _vehicle;
			} forEach _obstructions;
		};

		// Create new vehicle
		private _newVehicle = createVehicle [_classname,[0,0,0],[],0,"CAN_COLLIDE"];
		_newVehicle setPosASL _basePosASL;
		createVehicleCrew _newVehicle;

		// Assign vehicle
		switch (_service) do {
			case "artillery" : {[_newVehicle,_callsign,_respawnTime] call SSS_fnc_addArtillery;};
			case "CASHelis" : {[_newVehicle,_callsign,_respawnTime] call SSS_fnc_addCASHeli;};
			case "transport" : {[_newVehicle,_callsign,_respawnTime] call SSS_fnc_addTransport;};
		};
	},[_classname,_callsign,_basePosASL,_respawnTime,_service],_respawnTime] call CBA_fnc_waitAndExecute;
};
