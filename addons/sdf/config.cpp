#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = QUOTE(COMPONENT);
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {QPVAR(main),"A3_ui_f"};
		author = "Simplex Team";
		url = "";
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "gui.hpp"
