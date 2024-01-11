#include "script_component.hpp"
#define ORDER "RELOCATE"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_posASL",[0,0,0]]
];

private _entity = _group getVariable [QPVAR(entity),objNull];

if (isNull _entity) exitWith {true};

_group allowFleeing 0;

private _moveTick = 0;
private _relocationDelay = (_entity getVariable [QPVAR(relocation),[false,60]]) # 1;
private _relocationTick = _relocationDelay + CBA_missionTime;

waitUntil {
	private _vehiclesReady = [_entity,_wpPos] call FUNC(vehiclesReady);

	if (!_vehiclesReady) then {
		_relocationTick = _relocationDelay + CBA_missionTime;
	};

	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 10;
		
		{
			doStop _x;
			[QEGVAR(common,enableAIFeature),[_x,["PATH",true]],_x] call CBA_fnc_targetEvent;
			sleep WAYPOINT_SLEEP;
			_x doMove (_wpPos vectorAdd (_x getVariable [QGVAR(formOffset),[0,0,0]]));
		} forEach (_entity getVariable QPVAR(vehicles));
	};

	sleep WAYPOINT_SLEEP;

	isNull _entity || {CBA_missionTime >= _relocationTick && _vehiclesReady}
};

{
	[QEGVAR(common,enableAIFeature),[_x,["PATH",false]],_x] call CBA_fnc_targetEvent;
	_x setVariable [QPVAR(base),getPosASL _x,true];
	_x setVariable [QPVAR(baseNormal),[vectorDir _x,vectorUp _x],true];
} forEach (_entity getVariable QPVAR(vehicles));

_entity setVariable [QPVAR(formCenter),(_entity getVariable QPVAR(vehicles)) call EFUNC(common,positionAvg),true];

if (GVAR(relocateCooldown)) then {
	[_entity,true] call EFUNC(common,cooldown);
} else {
	_entity call EFUNC(common,setStatus);
};

[QPVAR(requestCompleted),[_entity getVariable [QPVAR(requester),objNull],_entity,["RELOCATE",[_posASL]]]] call CBA_fnc_globalEvent;

NOTIFY(_entity,LSTRING(notifyRelocateComplete));

true
