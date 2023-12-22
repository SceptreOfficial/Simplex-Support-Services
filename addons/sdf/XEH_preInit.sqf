#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

// Make profile background colors easy to access
GVAR(profileRGBA) = [
	PROFILE_COLORS_R,
	PROFILE_COLORS_G,
	PROFILE_COLORS_B,
	1
];

parsingNamespace setVariable [QGVAR(profileR),GVAR(profileRGBA) # 0];
parsingNamespace setVariable [QGVAR(profileG),GVAR(profileRGBA) # 1];
parsingNamespace setVariable [QGVAR(profileB),GVAR(profileRGBA) # 2];
parsingNamespace setVariable [QGVAR(profileA),1];

// Initialize caches
GVAR(listCache) = [] call CBA_fnc_createNamespace;
GVAR(gridCache) = [] call CBA_fnc_createNamespace;
GVAR(customCache) = [] call CBA_fnc_createNamespace;

GVAR(skipOnValueChanged) = false;

ADDON = true;
