#include "script_component.hpp"

params ["_ctrl","_index"];

GVAR(request) set ["speedMode",["LIMITED","NORMAL"] param [_index,"NORMAL"]];

call FUNC(gui_verify);
