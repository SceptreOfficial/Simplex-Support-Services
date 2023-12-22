#include "script_component.hpp"

params [["_primary","",["",[]]]];

if (_primary isEqualType "") then {
	_this call FUNC(listDialog);
} else {
	_this call FUNC(gridDialog);
};
