#include "..\script_component.hpp"

switch (uiNamespace getVariable [QEGVAR(sdf,displayClass),""]) do {
	case QGVAR(guiStrafe) : FUNC(guiStrafe_verify);
	case QGVAR(guiLoiter) : FUNC(guiLoiter_verify);
	//case QGVAR(guiBombing) : FUNC(guiBombing_verify);
};
