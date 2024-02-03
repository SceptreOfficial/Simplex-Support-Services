#include "..\script_component.hpp"

params ["_posASL"];

private _pos = ASLToAGL _posASL;
private _isRectangle = false;
private _width = 100;
private _height = 100;
private _direction = 0;
private _markers = allMapMarkers select {markerPos _x distance2D _posASL < 100 && {toUpper markerShape _x in ["ELLIPSE","RECTANGLE"]}};
private _markerFound = false;

if (_markers isNotEqualTo []) then {
	_markers = _markers apply {[markerPos _x distance2D _posASL,_x]};
	_markers sort true;
	private _nearestMarker = _markers # 0 # 1;
	_pos = markerPos _nearestMarker;
	_isRectangle = markerShape _nearestMarker == "RECTANGLE";
	_width = markerSize _nearestMarker # 0;
	_height = markerSize _nearestMarker # 1;
	_direction = markerDir _nearestMarker;
	_markerFound = true;
};

private _tempMarker = createMarkerLocal ["tempMarker" + str CBA_missionTime + str random 1,_pos];
_tempMarker setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _isRectangle);
_tempMarker setMarkerSizeLocal [_width,_height];
_tempMarker setMarkerDirLocal _direction;

[_pos,_width,_height,_direction,_isRectangle,_markerFound,_tempMarker]
