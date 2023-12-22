#include "script_component.hpp"

params ["_vehicle","_callsign"];

if (!alive _vehicle) exitWith {
	ERROR_2(LLSTRING(VehicleNotAlive),_callsign,_vehicle);
	true
};

if (!isNull (_vehicle getVariable [QPVAR(entity),objNull])) exitWith {
	ERROR_2(LLSTRING(VehicleAlreadyASupport),_callsign,_vehicle);
	true
};

if (PRIMARY_CREW(_vehicle) findIf {isPlayer _x} > -1) exitWith {
	ERROR_2(LLSTRING(NoPlayersAllowed),_callsign,_vehicle);
	true
};

false
