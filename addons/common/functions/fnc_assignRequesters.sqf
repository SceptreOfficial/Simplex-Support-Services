#include "script_component.hpp"

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(assignRequesters),2];
};

params [["_candidates",[],[[]]],["_entities",[],[[]]]];

{
	private _assignedEntities = _x getVariable ["SSS_assignedEntities",[]];
	{_assignedEntities pushBackUnique _x} forEach _entities;
	_x setVariable ["SSS_assignedEntities",_assignedEntities - [objNull],true];
} forEach _candidates;

{
	private _requesters = _x getVariable ["SSS_requesters",[]];
	{_requesters pushBackUnique _x} forEach _candidates;
	_entity setVariable ["SSS_requesters",_requesters - [objNull],true];
} forEach _entities;
