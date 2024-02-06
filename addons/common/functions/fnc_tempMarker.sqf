#include "..\script_component.hpp"

if (!isServer) exitWith {[QGVAR(execute),[_this,QFUNC(tempMarker)]] call CBA_fnc_serverEvent};

params ["_entity","_position","_type","_color","_message",["_lifetime",-1,[0]]];

private _marker = createMarker [GEN_STR(_entity),_position];
_marker setMarkerShape "ICON";
_marker setMarkerType _type;
_marker setMarkerColor _color;
_marker setMarkerSize [0.8,0.8];
_marker setMarkerAlpha 0;

private _tempMarkers = _entity getVariable [QPVAR(tempMarkers),[]];
_tempMarkers pushBack _marker;
_entity setVariable [QPVAR(tempMarkers),_tempMarkers];

[QGVAR(tempMarkerCreated),[_entity,_marker,_message,_lifetime],_marker] call CBA_fnc_globalEventJIP;
