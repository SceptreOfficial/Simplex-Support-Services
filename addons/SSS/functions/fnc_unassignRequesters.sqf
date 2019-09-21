#include "script_component.hpp"

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(unassignRequesters),2];
};

params [["_candidates",[],[[]]],["_entities",[],[[]]]];

_candidates pushBackUnique objNull;
_entities pushBackUnique objNull;

{
	private _assignedEntities = _x getVariable ["SSS_assignedEntities",[]];
	_x setVariable ["SSS_assignedEntities",_assignedEntities - _entities,true];
} forEach _candidates;

{
	private _requesters = _x getVariable ["SSS_requesters",[]];
	_entity setVariable ["SSS_requesters",_requesters - _candidates,true];
} forEach _entities;
