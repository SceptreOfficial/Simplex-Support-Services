#include "script_component.hpp"

params ["_ctrl"];

_ctrl ctrlEnable false;

[QPVAR(guiConfirm),[GVAR(guiService),PVAR(guiEntity),ctrlParent _ctrl]] call CBA_fnc_localEvent;

if (OPTION(closeOnConfirm)) then {
	true call FUNC(gui_close);
};
