#include "script_component.hpp"

params ["_array",["_order",true],["_primaryValueFnc",{}],["_secondaryValueFnc",{}]];

if (_array isEqualTo []) exitWith {[]};

if (_primaryValueFnc isEqualTo {}) exitWith {
	_array = +_array;
	_array sort _order;
	_array
};

if (_secondaryValueFnc isEqualTo {}) then {
	_array = _array apply {[_x call _primaryValueFnc,_x]};
	_array sort _order;
	_array apply {_x # 1}
} else {
	_array = _array apply {[_x call _primaryValueFnc,_x call _secondaryValueFnc,_x]};
	_array sort _order;
	_array apply {_x # 2}
};
