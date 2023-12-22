#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = QUOTE(COMPONENT);
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "https://github.com/SceptreOfficial/Simplex-Support-Services";
		units[] = {
			QGVAR(moduleRestrictAccess),
			QGVAR(moduleManage),
			QGVAR(moduleTerminal)
		};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {QPVAR(main),QPVAR(sdf)};
		VERSION_CONFIG;
	};
};

#include "Cfg3DEN.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgMoves.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
#include "gui.hpp"
#include "CfgUIGrids.hpp"
#include "RscTitles.hpp"