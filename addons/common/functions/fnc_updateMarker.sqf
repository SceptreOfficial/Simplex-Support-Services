#include "script_component.hpp"

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(updateMarker),2];
};

params ["_entity","_activateMarker",["_position",[0,0,0]]];

if (isNull _entity) exitWith {};

private _marker = _entity getVariable "SSS_marker";
private _side = _entity getVariable "SSS_side";

if (_activateMarker) then {
	[[_entity,_marker,_side,_position],{
		params ["_entity","_marker","_side","_position"];

		if (side player == _side || _entity in (player getVariable ["SSS_assignedEntities",[]])) then {
			_marker setMarkerPosLocal _position;
			_marker setMarkerAlphaLocal 0.8;
		} else {
			_marker setMarkerAlphaLocal 0;
		};
	}] remoteExecCall ["call",0];
} else {
	[_marker,0] remoteExecCall ["setMarkerAlphaLocal",0];
};
