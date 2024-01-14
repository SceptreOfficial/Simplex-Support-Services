#include "script_component.hpp"

params ["_ctrl","_index"];

GVAR(request) set ["dangerClose",_index == 0];

call FUNC(gui_verify);
