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

		if (isTouchingGround _vehicle && _vehicle distance2D _wpPos < 200) then {
			_vehicle doMove (_vehicle getPos [200,getDir _vehicle]);
		} else {
			_vehicle doMove _wpPos;
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < HELO_PILOT_DISTANCE
};

if (driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

[
	_vehicle,
	[_vehicle,ATLtoASL waypointPosition [_group,currentWaypoint _group],"LAND"] call EFUNC(common,surfacePosASL),
	[-1],
	(getPos _vehicle # 2) max 50,
	100,
	nil,
	[EFUNC(common,pilotHelicopterLand),[-1,true]]
] call EFUNC(common,pilotHelicopter);

waitUntil {
	sleep WAYPOINT_SLEEP;
	isTouchingGround _vehicle ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

if (!isTouchingGround _vehicle || driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

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
