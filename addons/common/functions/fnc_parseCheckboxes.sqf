#include "script_component.hpp"

params [["_data",[],[[]]],["_booleans",[],[[]]]];

private _return = [];

{
	if (_booleans param [_forEachIndex,true]) then {
		_return pushBack _x;
	};
} forEach _data;

_return
