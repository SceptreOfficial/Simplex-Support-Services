#include "..\script_component.hpp"

params ["_group",["_stop",false]];

if (!isNull (_group getVariable [QPVAR(group),grpNull])) then {
	_group = _group getVariable QPVAR(group);
};

{deleteWaypoint [_group,0]} forEach (waypoints _group);

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicles = (_entity getVariable [QPVAR(vehicles),[]]) + [_entity getVariable [QPVAR(vehicle),objNull]];

if (_stop) then {
	private _wp = _group addWaypoint [getPosASL leader _group,-1,0];
	_wp setWaypointType "MOVE";
	//_group setCurrentWaypoint _wp;
	//_leader doMove (waypointPosition _wp);
	//(units _group) doFollow _leader;
	//{_x doFollow _x} forEach _vehicles;
};

{_x doFollow _x} forEach _vehicles;
