#include "script_component.hpp"
#define ORDER "PATH"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_path",[]]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

private _points = [getPos _vehicle,_wpPos];
_vehicle setDriveOnPath _points;

//(_path # -1) params ["_pX","_pY","_pZ","_pSpeed"];
//private _lastPos = [_pX,_pY,_pZ];

waitUntil {
	sleep WAYPOINT_SLEEP;
	!alive _vehicle || !canMove _vehicle || _vehicle distance _wpPos < 8
};

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
