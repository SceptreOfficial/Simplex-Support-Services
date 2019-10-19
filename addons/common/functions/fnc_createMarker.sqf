#include "script_component.hpp"

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(createMarker),2];
};

params ["_entity","_callsign","_icon","_string"];

private _marker = format ["SSS_%1_%2$%3",_callsign,CBA_missionTime,random 1];
_entity setVariable ["SSS_marker",_marker,true];

createMarker [_marker,[0,0,0]];
_marker setMarkerShape "ICON";
_marker setMarkerType _icon;
_marker setMarkerColor "ColorGrey";
_marker setMarkerText format ["%1 - %2",_string,_callsign];
_marker setMarkerAlpha 0;
