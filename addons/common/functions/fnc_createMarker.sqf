#include "script_component.hpp"

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(createMarker),2];
};

params ["_entity","_callsign","_icon","_string"];

private _marker = format ["SSS_%1_%2",_entity,_callsign];
_entity setVariable ["SSS_marker",_marker,true];

[[_marker,_callsign,_icon,_string],{
	params ["_marker","_callsign","_icon","_string"];

	createMarkerLocal [_marker,[0,0,0]];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal _icon;
	_marker setMarkerColorLocal "ColorGrey";
	_marker setMarkerTextLocal format ["%1 - %2",_string,_callsign];
	_marker setMarkerAlphaLocal 0;
}] remoteExecCall ["call",0];
