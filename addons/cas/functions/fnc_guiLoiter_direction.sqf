#include "script_component.hpp"

params ["_ctrl","_index"];

GVAR(request) set ["direction",["CIRCLE","CIRCLE_L"] param [_index,"CIRCLE_L"]];

call FUNC(gui_verify);
