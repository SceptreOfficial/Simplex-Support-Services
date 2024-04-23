#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(surfacePosASL),_this] call CBA_fnc_directCall};

params ["_vehicle","_posASL",["_procedure","LAND"],"_args"];

switch (toUpper _procedure) do {
	case "LAND" : {
		private _ix = lineIntersectsSurfaces [_posASL vectorAdd [0,0,50],_posASL vectorAdd [0,0,-10],_vehicle,objNull,true,1,"GEOM","FIRE"];
		if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};

		private _height = 1;
		if (getNumber (configOf _vehicle >> "gearRetracting") == 1) then {
			_height = _height + (1.5 max (1.5 * getNumber (configOf _vehicle >> "gearDownTime")));
		};

		_posASL = _posASL vectorAdd [0,0,_height];
		_posASL set [2,0 max (_posASL # 2)];
		_posASL
	};
	case "HOVER";
	case "FASTROPE" : {
		_args params [["_hoverHeight",0]];

		private _ix = lineIntersectsSurfaces [_posASL vectorAdd [0,0,50],_posASL vectorAdd [0,0,-10],_vehicle,objNull,true,1,"GEOM","FIRE"];
		
		if (_ix isNotEqualTo []) then {
			_posASL = (_ix # 0 # 0) vectorAdd [0,0,_hoverHeight];
		};

		_posASL set [2,0 max (_posASL # 2)];
		_posASL
	};
	case "SEA" : {
		_args params [["_hoverHeight",0]];

		private _waveHeight = linearConversion [0,1,waves,0,getNumber (configFile >> "CfgWorlds" >> worldName >> "Sea" >> "maxTide")];
		private _maxDepth = getNumber (configOf _vehicle >> "maxFordingDepth");
		_posASL set [2,(getTerrainHeightASL _posASL) max (_waveHeight - _maxDepth * 0.4)];

		_posASL vectorAdd [0,0,_hoverHeight]
	};
	default {
		LOG_WARNING_1("Invalid procedure: %1",_procedure);
		_posASL
	};
};
