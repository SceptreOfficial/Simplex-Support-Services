#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {};
		author = "Simplex Team";
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "gui.hpp"
