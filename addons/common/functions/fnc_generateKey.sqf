#include "..\script_component.hpp"

if (isNil QGVAR(keys)) then {
	GVAR(keys) = 0;
};

GVAR(keys) = GVAR(keys) + 1;
publicVariable QGVAR(keys);

format ["%1#%2#%3",ceil random 99,GVAR(keys),systemTime joinString ""]
