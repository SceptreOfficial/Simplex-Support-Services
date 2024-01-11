#include "script_component.hpp"
#define ORDER "UNLOAD"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_ejectTypes",[]],
	["_ejectionsID",""],
	["_ejectInterval",OPTION(ejectInterval)]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

private _moveTick = 0;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;
		_vehicle doMove _wpPos;
	};

	sleep WAYPOINT_SLEEP;

	unitReady _vehicle
};

_ejectTypes params [["_allPlayers",true,[true]],["_allAI",true,[true]],["_allCargo",true,[true]]];

private _ejections = _group getVariable [_ejectionsID,[]];
_ejections append ([[],getVehicleCargo _vehicle] select _allCargo);
_ejections append (SECONDARY_CREW(_vehicle) select {(_allPlayers && isPlayer _x) || (_allAI && !isPlayer _x)});

[_vehicle,_ejections,_ejectInterval] call EFUNC(common,unloadTransport);

waitUntil {
	sleep WAYPOINT_SLEEP;
	_vehicle getVariable [QEGVAR(common,unloadEnd),false]
};

_group setVariable [_ejectionsID,nil,true];

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
