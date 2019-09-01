#include "script_component.hpp"

params [["_array",[],[[]]],["_order",true,[true]],["_valueFnc",{},[{}]]];

if (_array isEqualTo []) exitWith {};
if (_valueFnc isEqualTo {}) exitWith {
	_array sort _order;
	_array
};

private _nestedArray = _array apply {[_x call _valueFnc,_x]};
_nestedArray sort _order;

_nestedArray apply {_x # 1}

