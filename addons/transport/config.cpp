#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = QUOTE(COMPONENT);
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "https://github.com/SceptreOfficial/Simplex-Support-Services";
		units[] = {
			QGVAR(moduleAddBoat),
			QGVAR(moduleAddHelicopter),
			QGVAR(moduleAddLand),
			QGVAR(moduleAddPlane),
			QGVAR(moduleAddVTOL)
		};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {QPVAR(common)};
		VERSION_CONFIG;
	};
};

class PVAR(services) {
	class Transport {
		name = CSTRING(service);
		icon = ICON_SERVICE;
		childActions = QFUNC(childActions);
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "gui.hpp"
