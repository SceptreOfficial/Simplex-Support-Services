#include "script_component.hpp"

params ["_namespace","_activateMarker",["_position",[0,0]]];

private _marker = _namespace getVariable "SSS_marker";

if (_activateMarker) then {
	_marker setMarkerPos _position;
	_marker setMarkerAlpha 0.7;
} else {
	_marker setMarkerAlpha 0;
};
