#include "script_component.hpp"

params ["_ctrlDispersion","_dispersion"];

private _area = GVAR(plan) # GVAR(planIndex) # 0;
_area set [1,_dispersion];
_area set [2,_dispersion];

call FUNC(gui_verify);
