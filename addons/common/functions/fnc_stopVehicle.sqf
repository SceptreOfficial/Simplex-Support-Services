#include "script_component.hpp"

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(stopVehicle),2];
};

params ["_entity"];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];
 
//INTERRUPT(_entity,_vehicle);

// Clean waypoints
[_vehicle] call FUNC(clearWaypoints);
// Use CBA function to neatly stop the vehicle
[_vehicle] call CBA_fnc_clearWaypoints;

_vehicle setVariable [QPVAR(WPDone),true,true];

//END_ORDER(_entity,{LLSTRING(NotifyStopVehicle)});
