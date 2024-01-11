#include "script_component.hpp"
#define ORDER "RTB"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER]] call CBA_fnc_directCall;

private _moveTick = 0;
private _liftoff = false;
private _posASL = _entity getVariable QPVAR(base);
private _posAGL = ASLToAGL _posASL;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 10;

		if (isTouchingGround _vehicle) then {
			if (_liftoff) exitWith {};
			_liftoff = true;
			_vehicle doMove (_vehicle getRelPos [200,0]);
		} else {
			_vehicle doMove _wpPos;
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && _vehicle distance2D _posAGL < VTOL_PILOT_DISTANCE
};

(_entity getVariable [QPVAR(baseNormal),[[0,1,0],[0,0,1]]]) # 0 params ["_vDX","_vDY"];

[
	_vehicle,
	[_vehicle,_posASL] call EFUNC(common,surfacePosASL),
	[(_vDX atan2 _vDY) call CBA_fnc_simplifyAngle],
	(getPos _vehicle # 2) max 150,
	75,
	nil,
	[EFUNC(common,pilotHelicopterLand),[60,false]]
] call EFUNC(common,pilotHelicopter);

waitUntil {
	sleep WAYPOINT_SLEEP;
	isTouchingGround _vehicle ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

if (isTouchingGround _vehicle && getPosASL _vehicle distance _posASL < 10) then {
	[_entity,_vehicle,GVAR(RTBReset),GVAR(RTBRestoreCrew)] call EFUNC(common,reset);
};

if (_timeout > 0) then {
	_vehicle call FUNC(landedStop);
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
