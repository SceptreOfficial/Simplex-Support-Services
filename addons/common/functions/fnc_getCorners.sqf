#include "..\script_component.hpp"

params ["_center","_width","_height","_dir"];
_center params ["_cX","_cY","_cZ"];

private _cosDir = cos _dir;
private _sinDir = sin _dir;
private _x1 = (_cosDir * _width) + (_sinDir * _height);
private _x2 = (_cosDir * _width) - (_sinDir * _height);
private _y1 = (_sinDir * _width) + (_cosDir * _height);
private _y2 = (_sinDir * _width) - (_cosDir * _height);

[
	[_cX - _x2,_cY - _y2,_cZ],
	[_cX - _x1,_cY - _y1,_cZ],
	[_cX + _x2,_cY + _y2,_cZ],
	[_cX + _x1,_cY + _y1,_cZ]
]
