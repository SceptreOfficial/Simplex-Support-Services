#include "script_component.hpp"

params [["_string",""],["_simple",true]];

if (_string isEqualType []) exitWith {_string};
if (_string isEqualTo "") exitWith {[]};

if (_simple) then {	
	parseSimpleArray _string
} else {
	0 call compile _string
};
