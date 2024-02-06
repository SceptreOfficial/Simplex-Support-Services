#include "..\script_component.hpp"

params ["_ctrl","_index"];

GVAR(request) set ["weapon",(_ctrl lbData _index) call EFUNC(common,parseArray)];

call FUNC(gui_verify);
