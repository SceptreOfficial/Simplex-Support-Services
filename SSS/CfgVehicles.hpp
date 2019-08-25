class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class ModuleDescription;
	};
	class SSS_Module_Base: Module_F {
		category = "SSS";
		author = "SSS Team";
		displayName = "";
		icon = "";
		portrait = "";
		side = 7;
		scope = 1;
		scopeCurator = 1;
		curatorCanAttach = 1;
		function = "";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;
	};

	class SSS_Module_AddArtillery : SSS_Module_Base {
		displayName = "Add Artillery";
		icon = ICON_ARTILLERY;
		function = "SSS_fnc_addArtilleryModule";
		scope = 2;
		scopeCurator = 2;
		class Arguments {
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "";
			};
			class RespawnTime {
				displayName = "Respawn Time";
				description = "-1 will disable respawn";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_RESPAWN_TIME;
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Minimum time between requests";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN;
			};
			class RoundCooldown {
				displayName = "Extra cooldown time per round";
				description = "Additional time incremented per round fired";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND;
			};
		};
		class ModuleDescription: ModuleDescription {
			description = "Add artillery support vehicle";
		};
	};

	class SSS_Module_AddCASDrone : SSS_Module_Base {
		displayName = "Add CAS Drone";
		icon = ICON_DRONE;
		function = "SSS_fnc_addCASDroneModule";
		scope = 2;
		scopeCurator = 2;
		class Arguments {
			class Classname {
				displayName = "Classname";
				description = "Classname of drone vehicle";
				typeName = "STRING";
				defaultValue = "B_UAV_02_F";
			};
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = "Side";
				description = "Side which support will be available to";
				typeName = "NUMBER";
				class values {
					class BLUFOR {
						default = 1;
						name = "BLUFOR";
						value = 0;
					};
					class OPFOR {
						name = "OPFOR";
						value = 1;
					};
					class Independent {
						name = "Independent";
						value = 2;
					};
				};
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Time between requests (after loiter is finished)";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_COOLDOWN_DRONES;
			};
			class LoiterTime {
				displayName = "Loiter time";
				description = "How long aircraft will loiter in the area";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_LOITER_TIME_DRONES;
			};
		};
		class ModuleDescription: ModuleDescription {
			description = "Add CAS drone support entity";
		};
	};

	class SSS_Module_AddCASGunship : SSS_Module_Base {
		displayName = "Add CAS Gunship";
		icon = ICON_GUNSHIP;
		function = "SSS_fnc_addCASGunshipModule";
		scope = 2;
		scopeCurator = 2;
		class Arguments {
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = "Side";
				description = "Side which support will be available to";
				typeName = "NUMBER";
				class values {
					class BLUFOR {
						default = 1;
						name = "BLUFOR";
						value = 0;
					};
					class OPFOR {
						name = "OPFOR";
						value = 1;
					};
					class Independent {
						name = "Independent";
						value = 2;
					};
				};
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Time between requests (after loiter is finished)";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_COOLDOWN_GUNSHIPS;
			};
			class LoiterTime {
				displayName = "Loiter time";
				description = "How long aircraft will loiter in the area";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_LOITER_TIME_GUNSHIPS;
			};
		};
		class ModuleDescription: ModuleDescription {
			description = "Add CAS gunship support entity";
		};
	};

	class SSS_Module_AddCASHeli : SSS_Module_Base {
		displayName = "Add CAS Heli";
		icon = ICON_HELI;
		function = "SSS_fnc_addCASHeliModule";
		scope = 2;
		scopeCurator = 2;
		class Arguments {
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "";
			};
			class RespawnTime {
				displayName = "Respawn Time";
				description = "-1 will disable respawn";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_RESPAWN_TIME;
			};
		};
		class ModuleDescription: ModuleDescription {
			description = "Add CAS helicopter support vehicle";
		};
	};

	class SSS_Module_AddCASPlane : SSS_Module_Base {
		displayName = "Add CAS Plane";
		icon = ICON_PLANE;
		function = "SSS_fnc_addCASPlaneModule";
		scope = 2;
		scopeCurator = 2;
		class Arguments {
			class Classname {
				displayName = "Classname";
				description = "Classname of plane vehicle";
				typeName = "STRING";
				defaultValue = "B_Plane_CAS_01_F";
			};
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "";
			};
			class WeaponSet {
				displayName = "Weapon set";
				description = "Array of weapon classnames or weapon:magazine classname arrays. Empty array for vehicle defaults";
				typeName = "STRING";
				defaultValue = "[""Gatling_30mm_Plane_CAS_01_F"",""Rocket_04_HE_Plane_CAS_01_F"",""Bomb_04_Plane_CAS_01_F""]";
			};
			class Side {
				displayName = "Side";
				description = "Side which support will be available to";
				typeName = "NUMBER";
				class values {
					class BLUFOR {
						default = 1;
						name = "BLUFOR";
						value = 0;
					};
					class OPFOR {
						name = "OPFOR";
						value = 1;
					};
					class Independent {
						name = "Independent";
						value = 2;
					};
				};
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Time between requests";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_COOLDOWN_PLANES;
			};
		};
		class ModuleDescription: ModuleDescription {
			description = "Add CAS plane support entity";
		};
	};

	class SSS_Module_AddTransport : SSS_Module_Base {
		displayName = "Add Transport Heli";
		icon = ICON_HELI;
		function = "SSS_fnc_addTransportModule";
		scope = 2;
		scopeCurator = 2;
		class Arguments {
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "";
			};
			class RespawnTime {
				displayName = "Respawn Time";
				description = "-1 will disable respawn";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_RESPAWN_TIME;
			};
		};
		class ModuleDescription: ModuleDescription {
			description = "Add transport helicopter support vehicle";
		};
	};

	class SSS_Module_RemoveCASDrone : SSS_Module_Base {
		displayName = "Remove CAS Drone";
		icon = ICON_GEAR;
		function = "SSS_fnc_removeCASDroneModule";
		scopeCurator = 2;
	};

	class SSS_Module_RemoveCASGunship : SSS_Module_Base {
		displayName = "Remove CAS Gunship";
		icon = ICON_GEAR;
		function = "SSS_fnc_removeCASGunshipModule";
		scopeCurator = 2;
	};

	class SSS_Module_RemoveCASPlane : SSS_Module_Base {
		displayName = "Remove CAS Plane";
		icon = ICON_GEAR;
		function = "SSS_fnc_removeCASPlaneModule";
		scopeCurator = 2;
	};
};
