#include "script_component.hpp"

// Don't update a marker if option is enabled
if (SSS_setting_milsimHideMarkers) exitWith {};

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

		if (side group player == _side) then {
			_marker setMarkerPosLocal _position;
			_marker setMarkerAlphaLocal 0.8;
		} else {
			_marker setMarkerAlphaLocal 0;
		};
	}] remoteExecCall ["call",0];
} else {
	_marker setMarkerAlpha 0;
};
