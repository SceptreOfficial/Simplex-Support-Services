#include "script_component.hpp"

params ["_entity"];
if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];
private _message = format [LLSTRING(Sitrep_LocationGrid) + "<br />%2",mapGridPosition _vehicle,switch true do {
	case (!canMove _vehicle) : {LLSTRING(Sitrep_StatusDisabled)};
	case (damage _vehicle > 0) : {LLSTRING(Sitrep_StatusDamaged)};
	default {LLSTRING(Sitrep_StatusGreen)};
}];

NOTIFY_LOCAL(_entity,_message);

// Manage marker on map - Don't update a marker if option is enabled
if (SSS_setting_milsimHideMarkers) exitWith {};

private _marker = createMarkerLocal [format ["SSS_%1$%2$%3",_vehicle,CBA_missionTime,random 1],getPos _vehicle];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "mil_box";
_marker setMarkerColorLocal "ColorGrey";
_marker setMarkerTextLocal (_entity getVariable "SSS_callsign");
_marker setMarkerAlphaLocal 1;

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_marker"];

	private _alpha = markerAlpha _marker - 0.005;
	_marker setMarkerAlphaLocal _alpha;

	if (alive _vehicle) then {
		_marker setMarkerPosLocal getPosVisual _vehicle;
	};

	if (_alpha <= 0) then {
		_PFHID call CBA_fnc_removePerFrameHandler;
		deleteMarkerLocal _marker;
	};
},0.1,[_vehicle,_marker]] call CBA_fnc_addPerFrameHandler;
