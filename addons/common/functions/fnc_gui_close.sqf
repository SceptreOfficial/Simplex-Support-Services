#include "script_component.hpp"

params [["_reset",true,[false]]];

private _display = uiNamespace getVariable [QEGVAR(sdf,display),displayNull];
_display setVariable [QPVAR(resetTerminalEntity),_reset];

closeDialog 0;
