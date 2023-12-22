#include "script_component.hpp"

if (!isServer) exitWith {[QEGVAR(common,execute),[_this,QFUNC(addTasks)]] call CBA_fnc_serverEvent};

params ["_entity","_plan","_logic",["_updateData",true]];

_entity setVariable [QPVAR(planLogic),_logic];

private _group = _entity getVariable QPVAR(group);
private _type = _entity getVariable QPVAR(supportType);
private _prevCount = 0;

if (_logic == 1) then {
	_entity setVariable [QPVAR(postponeIndex),nil,true];
	[_group,true] call EFUNC(common,clearWaypoints);

	if (_updateData) then {
		_entity setVariable [QPVAR(request),+_plan,true];
	};
} else {
	_prevCount = count (_entity getVariable [QPVAR(request),[]]);

	if (_prevCount > 0) then {
		NOTIFY(_entity,LSTRING(notifyAppend));
	};
	
	if (_updateData) then {
		_entity setVariable [QPVAR(request),(_entity getVariable [QPVAR(request),[]]) + _plan,true];
	};
};

private _postponeIndex = _entity getVariable [QPVAR(postponeIndex),-1];

// Stop here if postponed for loitering
if (_postponeIndex > -1) exitWith {};

{
	[_group,_x] call FUNC(formatTask) params ["_task","_posASL","_attachedObject","_taskArgs"];

	private _wp = _group addWaypoint [_posASL,0];
	_wp setWaypointType "SCRIPTED";
	_wp setWaypointScript format ["%1 %2",format ["%1%2%3.sqf",QPATHTOF(waypoints\),_type,_task],_taskArgs];
	_wp setWaypointPosition [_posASL,-1];
	_wp setWaypointDescription _task;

	if (!isNull _attachedObject) then {
		_wp waypointAttachVehicle _attachedObject;
	};

	if (_task in ["LOITER","LANDSIGNAL"]) exitWith {
		_postponeIndex = _prevCount + _forEachIndex + 1;
	};
} forEach _plan;

if (_postponeIndex > -1) then {
	_entity setVariable [QPVAR(postponeIndex),_postponeIndex,true];
} else {
	_entity setVariable [QPVAR(postponeIndex),nil,true];
};
