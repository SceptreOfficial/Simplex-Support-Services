#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		units[] = {
			QGVAR(AddArtillery),
			QGVAR(AddCASDrone),
			QGVAR(AddCASGunship),
			QGVAR(AddCASHeli),
			QGVAR(AddCASPlane),
			QGVAR(AddTransport),
			QGVAR(AddLogisticsAirdrop),
			QGVAR(AddLogisticsStation),
			QGVAR(RemoveSupports)
		};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {"SSS_main"};
		author = "Simplex Team";
		url = "https://github.com/SceptreOfficial/Simplex-Support-Services";
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
