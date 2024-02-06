#include "..\script_component.hpp"

params ["_ctrl","_index"];

GVAR(request) set ["type",["CIRCLE","CIRCLE_L","HOVER"] param [_index,"CIRCLE_L"]];

call FUNC(gui_verify);
