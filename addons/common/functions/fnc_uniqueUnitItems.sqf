#include "script_component.hpp"

params ["_unit"];

private _items = _unit getVariable QGVAR(uniqueItems);

if (isNil "_items") then {
	_items = uniqueUnitItems _unit apply {toLower _x};
	_unit setVariable [QGVAR(uniqueItems),_items];
};

_items
