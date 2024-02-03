#include "..\script_component.hpp"

params ["_ctrl","_index"];

PVAR(guiEntity) setVariable [QGVAR(rcIndex),_index];

GVAR(remoteControlTarget) = GVAR(remoteControlTurrets) param [_index,[]];

call FUNC(gui_verify);
