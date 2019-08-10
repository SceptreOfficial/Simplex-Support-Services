#include "script_component.hpp"

class CfgPatches {
	class SSS {
		name = COMPONENT;
		author = "Sceptre";
		authors[] = {"Sceptre"};
		url = "";
		units[] = {
			"SSS_Module_AddArtillery",
			"SSS_Module_AddCASDrone",
			"SSS_Module_AddCASGunship",
			"SSS_Module_AddCASHeli",
			"SSS_Module_AddCASPlane",
			"SSS_Module_AddTransport",
			"SSS_Module_RemoveCASDrone",
			"SSS_Module_RemoveCASGunship",
			"SSS_Module_RemoveCASPlane"
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
		VERSION_CONFIG;
	};
};

#include "CDS\gui.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgFunctions.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
