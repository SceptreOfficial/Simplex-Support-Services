#include "script_component.hpp"

disableSerialization;
params [["_ctrlMap",0,[0,controlNull]],["_mode",0,[0]],["_skip",false,[false]]];

if (_ctrlMap isEqualType 0) then {
	_ctrlMap = (uiNamespace getVariable QGVAR(controls)) # _ctrlMap;
};

private _value = _ctrlMap getVariable QGVAR(value);
private _modeCache = _ctrlMap getVariable QGVAR(modeCache);
private _markers = _ctrlMap getVariable [QGVAR(markers),[]];

_modeCache set [_ctrlMap getVariable QGVAR(mode),+_value];
_ctrlMap setVariable [QGVAR(mode),_mode];
_ctrlMap setVariable [QGVAR(modeCache),+_modeCache];

_value = _modeCache # _mode;

{deleteMarkerLocal _x} forEach _markers;
_markers = [];

if !(_ctrlMap getVariable [QGVAR(disableMarkers),false]) then {
	switch _mode do {
		case 0 : {
			_ctrlMap getVariable QGVAR(pointData) params ["",["_type","mil_destroy"],["_text",""],["_color","Default"],["_angle",0],["_size",[0.8,0.8]],["_alpha",1]];

			{
				private _marker = createMarkerLocal [format ["%1:%2:%3",QGVAR(marker),_forEachIndex,CBA_missionTime],_x];
				_marker setMarkerShapeLocal "ICON";
				_marker setMarkerTypeLocal _type;
				_marker setMarkerTextLocal _text;
				_marker setMarkerColorLocal _color;
				_marker setMarkerDirLocal _angle;
				_marker setMarkerSizeLocal _size;
				_marker setMarkerAlphaLocal _alpha;
				_markers pushBack _marker;
			} forEach _value;
		};
		case 1 : {
			_ctrlMap getVariable QGVAR(areaData) params ["",["_brush","Solid"],["_color","Default"],["_alpha",1]];
			
			private _marker = createMarkerLocal [format ["%1:%2:%3",QGVAR(marker),random 1,CBA_missionTime],_value # 0];
			_marker setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select (_value # 4));
			_marker setMarkerSizeLocal [_value # 1,_value # 2];
			_marker setMarkerDirLocal (_value # 3);
			_marker setMarkerBrushLocal _brush;
			_marker setMarkerColorLocal _color;
			_marker setMarkerAlphaLocal _alpha;
			_markers pushBack _marker;
		};
		case 2 : {
			_ctrlMap getVariable QGVAR(lineData) params ["",["_color","Default"],["_alpha",1]];

			private _marker = createMarkerLocal [format ["%1:%2:%3",QGVAR(marker),random 1,CBA_missionTime],[0,0,0]];
			_marker setMarkerShapeLocal "POLYLINE";
			_marker setMarkerColorLocal _color;
			_marker setMarkerAlphaLocal _alpha;
			_markers pushBack _marker;

			if (count _value > 1) then {
				_marker setMarkerPolyline flatten (_value apply {[_x # 0,_x # 1]});
			};
		};
	};
};

_ctrlMap setVariable [QGVAR(value),_value];
_ctrlMap setVariable [QGVAR(markers),_markers];

if (_ctrlMap getVariable [QGVAR(skip),false]) exitWith {
	_ctrlMap setVariable [QGVAR(skip),nil];
};

if (GVAR(skipOnValueChanged) || _skip) exitWith {};

if (_ctrlMap getVariable [QGVAR(custom),false]) then {
	[_ctrlMap,_value] call (_ctrlMap getVariable QGVAR(onValueChanged));
} else {
	[_value,uiNamespace getVariable QGVAR(arguments),_ctrlMap] call (_ctrlMap getVariable QGVAR(onValueChanged));	
};
