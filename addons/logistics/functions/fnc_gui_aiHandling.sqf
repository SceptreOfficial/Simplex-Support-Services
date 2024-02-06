#include "..\script_component.hpp"

params ["_ctrl","_index"];

GVAR(request) set ["aiHandling",_index];

switch (uiNamespace getVariable [QEGVAR(sdf,displayClass),""]) do {
	case QGVAR(gui) : FUNC(gui_verify);
	case QGVAR(guiStation) : FUNC(guiStation_verify);
};
