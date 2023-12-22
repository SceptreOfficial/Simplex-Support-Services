#include "script_component.hpp"

params ["_entity"];
if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];
private _message_code = {format [LLSTRING(Sitrep_LocationGrid) + "<br />%2",mapGridPosition (_this # 0),switch true do {
	case (!canMove (_this # 0)) : {LLSTRING(Sitrep_StatusDisabled)};
	case (damage (_this # 0) > 0) : {LLSTRING(Sitrep_StatusDamaged)};
	default {LLSTRING(Sitrep_StatusGreen)};
}]};

NOTIFY_LOCAL_1(_entity,_message_code,_vehicle);

// Manage marker on map - Don't update a marker if option is enabled
if (OPTION(milsimHideMarkers)) exitWith {};

private _marker = createMarkerLocal [format [QPVAR(%1$%2$%3),_vehicle,CBA_missionTime,random 1],getPos _vehicle];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "mil_box";
_marker setMarkerColorLocal "ColorGrey";
_marker setMarkerTextLocal (_entity getVariable QPVAR(callsign));
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
