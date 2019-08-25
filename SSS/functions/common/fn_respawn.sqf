#include "script_component.hpp"

if (!isServer) exitWith {};

params ["_vehicle",["_primaryGone",false]];

// Sometimes killed EH fires twice. Idk why
if (!isNil {_vehicle getVariable "SSS_respawning"}) exitWith {};
_vehicle setVariable ["SSS_respawning",true];

[
	_vehicle getVariable "SSS_base",_vehicle getVariable "SSS_classname",
	_vehicle getVariable "SSS_side",_vehicle getVariable "SSS_service",
	_vehicle getVariable "SSS_displayName",_vehicle getVariable "SSS_respawnTime"
] params ["_base","_classname","_side","_service","_callsign","_respawnTime"];

if (isNil "_service") exitWith {};

private _basePosASL = if (_base isEqualType objNull) then {getPosASL _base} else {_base};

if (_respawnTime >= 0) then {
	private _message = format ["Support vehicle replacement will be available in %1 seconds.",_respawnTime];
	NOTIFY(_vehicle,_message)
} else {
	NOTIFY(_vehicle,"Support vehicle no longer available.")
};

// Cleanup
_vehicle call SSS_fnc_remove;
if (_primaryGone) then {
	group _vehicle leaveVehicle _vehicle;
	PRIMARY_CREW(_vehicle) orderGetIn false;
};

// _respawnTime of -1 disables respawn
if (_respawnTime >= 0) then {
	[{
		params ["_basePosASL","_classname","_side","_service","_callsign","_respawnTime"];

		// Clear obstructions
		{
			systemChat str _x;
			private _obj = _x;
			if ((_obj isKindOf "LandVehicle" || _obj isKindOf "Air" || _obj isKindOf "Ship") && {}) then {
				{_obj deleteVehicleCrew _x} forEach crew _obj;
				deleteVehicle _obj;
			};
		} forEach (ASLToAGL _basePosASL nearObjects ((sizeOf _classname) / 2));

		// Create new vehicle
		private _newGroup = createGroup [_side,true];
		private _newVehicle = createVehicle [_classname,[0,0,0],[],0,"NONE"];
		_newVehicle setPosASL _basePosASL;
		(createVehicleCrew _newVehicle) deleteGroupWhenEmpty true;
		crew _newVehicle joinSilent _newGroup;
		_newGroup addVehicle _newVehicle;

		// Assign vehicle
		switch (_service) do {
			case "artillery" : {[_newVehicle,_callsign,_respawnTime] call SSS_fnc_addArtillery;};
			case "CASHelis" : {[_newVehicle,_callsign,_respawnTime] call SSS_fnc_addCASHeli;};
			case "transport" : {[_newVehicle,_callsign,_respawnTime] call SSS_fnc_addTransport;};
		};
	},[_basePosASL,_classname,_side,_service,_callsign,_respawnTime],_respawnTime] call CBA_fnc_waitAndExecute;
};
