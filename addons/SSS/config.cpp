#include "script_component.hpp"

class CfgPatches {
	class SSS {
		name = COMPONENT;
		units[] = {
			"SSS_Module_AddArtillery",
			"SSS_Module_AddCASDrone",
			"SSS_Module_AddCASGunship",
			"SSS_Module_AddCASHeli",
			"SSS_Module_AddCASPlane",
			"SSS_Module_AddTransport",
			"SSS_Module_AssignRequesters",
			"SSS_Module_RemoveSupports"
		};
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
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
