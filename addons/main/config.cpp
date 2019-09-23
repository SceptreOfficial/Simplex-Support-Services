#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {
            "A3_Modules_F",
			"A3_Modules_F_Curator",
			"ace_common",
			"ace_fastroping",
			"ace_interact_menu",
			"cba_common",
			"cba_events",
			"cba_main",
			"cba_settings",
			"cba_xeh"
		};
		author = "Simplex Team";
		url = "https://github.com/SceptreOfficial/Simplex-Support-Services";
		VERSION_CONFIG;
	};

	// Dependency fix
	class SSS {
		name = SSS;
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {"A3_data_f"};
		author = "Simplex Team";
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgSounds.hpp"
