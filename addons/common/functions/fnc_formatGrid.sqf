#include "..\script_component.hpp"
/*
	Authors: Sceptre
	Formats a position to a grid readout
*/

private _grid = [_this] call FUNC(getMapGridFromPos);

format [LLSTRING(gridFormat),_grid # 0,_grid # 1];
