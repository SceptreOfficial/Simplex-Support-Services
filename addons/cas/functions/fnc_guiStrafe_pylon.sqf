#include "script_component.hpp"

params ["_ctrl","_index"];

if (ctrlClassName _ctrl == QGVAR(primary)) then {
	GVAR(request) set ["pylon1",(_ctrl lbData _index) call EFUNC(common,parseArray)];
} else {
	GVAR(request) set ["pylon2",(_ctrl lbData _index) call EFUNC(common,parseArray)];
};

call FUNC(gui_verify);
