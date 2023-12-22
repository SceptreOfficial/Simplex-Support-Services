#include "script_component.hpp"

params ["_ctrl"];

//_ctrl ctrlEnable false;

[QPVAR(guiAbort),[GVAR(guiService),PVAR(guiEntity),ctrlParent _ctrl]] call CBA_fnc_localEvent;
