#include "..\script_component.hpp"

params [["_area",false,[[],false]],["_color",[1,0,0,1],[[]],4]];

if (_area isEqualType false) exitWith {
	if (isNil QGVAR(drawShape3D)) exitWith {};
	removeMissionEventHandler ["Draw3D",GVAR(drawShape3D)];
	GVAR(drawShape3D) = nil;
};

_area params [["_posASL",[0,0,0],[[],objNull]],["_width",10,[0]],["_length",10,[0]],["_dir",0,[0,objNull]],["_isRectangle",true,[false]],["_height",10,[0]]];

if (_posASL isEqualType objNull) then {_posASL = getPosASL _posASL};
if (_dir isEqualType objNull) then {_dir = getDir _dir};

if (!isNil QGVAR(drawShape3D)) then {
	removeMissionEventHandler ["Draw3D",GVAR(drawShape3D)];
	GVAR(drawShape3D) = nil;
};

_height = _height max 0;
_posASL = _posASL vectorAdd [0,0,-_height];
_height = _height * 2;

if (_isRectangle) then {
	private _x1 = ASLtoAGL (_posASL vectorAdd ([[-_width,-_length,0],_dir] call FUNC(rotateVector2D)));
	private _x2 = ASLtoAGL (_posASL vectorAdd ([[_width,-_length,0],_dir] call FUNC(rotateVector2D)));
	private _x3 = ASLtoAGL (_posASL vectorAdd ([[_width,_length,0],_dir] call FUNC(rotateVector2D)));
	private _x4 = ASLtoAGL (_posASL vectorAdd ([[-_width,_length,0],_dir] call FUNC(rotateVector2D)));
	private _y1 = _x1 vectorAdd [0,0,_height];
	private _y2 = _x2 vectorAdd [0,0,_height];
	private _y3 = _x3 vectorAdd [0,0,_height];
	private _y4 = _x4 vectorAdd [0,0,_height];

	private _dots = [_x1,_x2,_x3,_x4,_y1,_y2,_y3,_y4] apply {["\A3\ui_f\data\map\markers\military\dot_CA.paa",_color,_x,1,1,0]};
	private _lines = [
		[_x1,_x2,_color],
		[_x2,_x3,_color],
		[_x3,_x4,_color],
		[_x4,_x1,_color],
		[_y1,_y2,_color],
		[_y2,_y3,_color],
		[_y3,_y4,_color],
		[_y4,_y1,_color],
		[_x1,_y1,_color],
		[_x2,_y2,_color],
		[_x3,_y3,_color],
		[_x4,_y4,_color]
	];

	GVAR(drawShape3D) = addMissionEventHandler ["Draw3D",{
		{drawLine3D _x} forEach (_thisArgs # 0);
		{drawIcon3D _x} forEach (_thisArgs # 1);
	},[_lines,_dots]];
} else {
	private _lastX = ASLtoAGL (_posASL vectorAdd ([[_width,0,0],_dir] call FUNC(rotateVector2D)));
	private _lastY = _lastX vectorAdd [0,0,_height];
	private _lines = [];
	private _dots = [];

	for "_i" from 1 to 12 do {
		private _a = 360 * (_i / 12);
		private _newX = ASLtoAGL (_posASL vectorAdd ([[cos _a * _width,sin _a * _length,0],_dir] call FUNC(rotateVector2D)));
		private _newY = _newX vectorAdd [0,0,_height];

		_dots pushBack ["\A3\ui_f\data\map\markers\military\dot_CA.paa",_color,_newX,1,1,0];
		_dots pushBack ["\A3\ui_f\data\map\markers\military\dot_CA.paa",_color,_newY,1,1,0];

		_lines pushBack [_lastX,_newX,_color];
		_lines pushBack [_lastX vectorAdd [0,0,_height],_newY,_color];

		if (_i % 2 == 1) then {
			_lines pushBack [_newX,_newY,_color];
		};

		_lastX = _newX;
		_lastY = _newY;
	};

	GVAR(drawShape3D) = addMissionEventHandler ["Draw3D",{
		{drawLine3D _x} forEach (_thisArgs # 0);
		{drawIcon3D _x} forEach (_thisArgs # 1);
	},[_lines,_dots]];
};
