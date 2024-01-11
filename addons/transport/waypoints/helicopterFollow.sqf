#include "script_component.hpp"
#define ORDER "FOLLOW"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",30]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_attachedObject]] call CBA_fnc_directCall;

private _moveTick = 0;
private _endTick = CBA_missionTime + _timeout;
private _condition = [{_vehicle getVariable [QGVAR(endHold),false]},{_endTick < CBA_missionTime}] select (_timeout > 0);

_vehicle setVariable [QGVAR(endHold),nil,true];
_vehicle setVariable [QGVAR(hold),LSTRING(stopFollowing),true];

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;

		if (isTouchingGround _vehicle && _vehicle distance2D _attachedObject < 200) then {
			_vehicle doMove (_vehicle getPos [200,getDir _vehicle]);
		} else {
			private _expectedPos = (expectedDestination _attachedObject) # 0;
			private _pos = getPos _vehicle;

			if (isNil "_expectedPos" || {_expectedPos distance2D [0,0] < 1}) then {
				_pos = getPos _attachedObject vectorAdd velocity _attachedObject;
				_pos set [2,0];
			} else {
				_pos = _attachedObject getPos [(_expectedPos distance2D _attachedObject) min ([250,1000] select (_attachedObject isKindOf "Air")),_attachedObject getDir _expectedPos];
			};

			if (_vehicle distance2D _pos < 20) exitWith {};

			_vehicle doMove _pos;
		};
	};

	sleep WAYPOINT_SLEEP;

	!alive _attachedObject || _condition
};

if (driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

_vehicle setVariable [QGVAR(endHold),nil,true];
_vehicle setVariable [QGVAR(hold),nil,true];

true
