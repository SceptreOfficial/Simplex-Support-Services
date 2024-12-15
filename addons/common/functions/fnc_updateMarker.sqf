#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(updateMarker),_this] call CBA_fnc_directCall};
if (!isServer) exitWith {[QGVAR(updateMarker),_this] call CBA_fnc_serverEvent};

params ["_entity",["_position",[0,0,0]],"_message"];

if (isNull _entity) exitWith {};

private _marker = _entity getVariable [QPVAR(marker),""];

if (_position isEqualType objNull) then {
	_position = getPosASL _position;
};

if (_marker isEqualTo "" && _position isEqualTo [0,0,0]) exitWith {};

if (_marker isEqualTo "") then {
	_marker = createMarker [GEN_STR(_entity),_position];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal "mil_end_noShadow";
	_marker setMarkerColorLocal "ColorBlue";
	_marker setMarkerSizeLocal [0.8,0.8];
	_marker setMarkerAlpha 0;
	_entity setVariable [QPVAR(marker),_marker];
};

if (_position isEqualTo [0,0,0]) exitWith {
	_marker setMarkerAlpha 0;
};

_marker setMarkerPos _position;

[QGVAR(markerUpdate),[_entity,_marker,_message],_marker] call CBA_fnc_globalEventJIP;
