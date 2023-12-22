#include "script_component.hpp"

params ["_array",["_order",true],["_primaryValueFnc",{}],["_secondaryValueFnc",{}]];

if (_array isEqualTo []) exitWith {[]};

if (_primaryValueFnc isEqualTo {}) exitWith {
	_array sort _order;
	_array
};

if (_secondaryValueFnc isEqualTo {}) then {
	private _sortArray = _array apply {[_x call _primaryValueFnc,_x]};
	_sortArray sort _order;
	_sortArray apply {_x # 1}
} else {
	private _sortArray = _array apply {[_x call _primaryValueFnc,_x call _secondaryValueFnc,_x]};
	_sortArray sort _order;
	_sortArray apply {_x # 2}
};
