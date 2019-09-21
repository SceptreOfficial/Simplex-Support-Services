class CfgVehicles {
	class Man;
	class CAManBase: Man {
		class ACE_SelfActions {
			class SSS_main {
				displayName = "Support Services";
				icon = ICON_SUPPORT_SERVICES;
				condition = "true";
				statement = "";
				exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
				showDisabled = 0;

				class SSS_artillery {
					displayName = "Artillery";
					icon = ICON_ARTILLERY;
					condition = QUOTE([ARR_2('artillery',_this)] call FUNC(serviceActionCondition));
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsArtillery));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_CAS {
					displayName = "CAS";
					icon = ICON_CAS;
					condition = QUOTE([ARR_2('CAS',_this)] call FUNC(serviceActionCondition));
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsCAS));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_transport {
					displayName = "Transport";
					icon = ICON_TRANSPORT;
					condition = QUOTE([ARR_2('transport',_this)] call FUNC(serviceActionCondition));
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsTransport));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};
			};
		};
	};

	class Logic;
	class Module_F : Logic {
		class ModuleDescription;
	};

	class SSS_Module_Base: Module_F {
		category = "SSS_Modules";
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
		function = QFUNC(moduleAddArtillery);
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
				defaultValue = SSS_DEFAULT_RESPAWN_TIME_STR;
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Minimum time between requests";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_COOLDOWN_ARTILLERY_MIN_STR;
			};
			class RoundCooldown {
				displayName = "Extra cooldown time per round";
				description = "Additional time incremented per round fired";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_COOLDOWN_ARTILLERY_ROUND_STR;
			};
			class MaxRounds {
				displayName = "Maximum rounds per request";
				description = "Max amount/slider range for requests";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_ARTILLERY_MAX_ROUNDS_STR;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when vehicle is added & respawned (vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
		};

		class ModuleDescription: ModuleDescription {
			description = "Add Artillery";
		};
	};

	class SSS_Module_AddCASDrone : SSS_Module_Base {
		displayName = "Add CAS Drone";
		icon = ICON_DRONE;
		function = QFUNC(moduleAddCASDrone);
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
				defaultValue = SSS_DEFAULT_COOLDOWN_DRONES_STR;
			};
			class LoiterTime {
				displayName = "Loiter time";
				description = "How long aircraft will loiter in the area";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_LOITER_TIME_DRONES_STR;
			};
		};

		class ModuleDescription: ModuleDescription {
			description = "Add CAS Drone";
		};
	};

	class SSS_Module_AddCASGunship : SSS_Module_Base {
		displayName = "Add CAS Gunship";
		icon = ICON_GUNSHIP;
		function = QFUNC(moduleAddCASGunship);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "Blackfish";
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
				defaultValue = SSS_DEFAULT_COOLDOWN_GUNSHIPS_STR;
			};
			class LoiterTime {
				displayName = "Loiter time";
				description = "How long aircraft will loiter in the area";
				typeName = "STRING";
				defaultValue = SSS_DEFAULT_LOITER_TIME_GUNSHIPS_STR;
			};
		};

		class ModuleDescription: ModuleDescription {
			description = "Add CAS Gunship";
		};
	};

	class SSS_Module_AddCASHeli : SSS_Module_Base {
		displayName = "Add CAS Helicopter";
		icon = ICON_HELI;
		function = QFUNC(moduleAddCASHelicopter);
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
				defaultValue = SSS_DEFAULT_RESPAWN_TIME_STR;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when vehicle is added & respawned (vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
		};

		class ModuleDescription: ModuleDescription {
			description = "Add CAS Helicopter";
		};
	};

	class SSS_Module_AddCASPlane : SSS_Module_Base {
		displayName = "Add CAS Plane";
		icon = ICON_PLANE;
		function = QFUNC(moduleAddCASPlane);
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
				description = "Array of weapon classnames or array of [weapon,magazine] arrays. Empty array for vehicle defaults";
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
				defaultValue = SSS_DEFAULT_COOLDOWN_PLANES_STR;
			};
		};

		class ModuleDescription: ModuleDescription {
			description = "Add CAS Plane";
		};
	};

	class SSS_Module_AddTransport : SSS_Module_Base {
		displayName = "Add Transport";
		icon = ICON_TRANSPORT;
		function = QFUNC(moduleAddTransport);
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
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when vehicle is added & respawned (vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
		};

		class ModuleDescription: ModuleDescription {
			description = "Add Transport";
		};
	};

	class SSS_Module_AssignRequesters : SSS_Module_Base {
		displayName = "Assign Requesters";
		icon = ICON_ASSIGN_REQUESTERS;
		function = QFUNC(moduleAssignRequesters);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Description {
				data = "";
				control = "SubCategoryNoHeader2";
				displayName = "";
				description = "Sync desired requesters and support modules to this module";
				tooltip = "";
			};
		};

		class ModuleDescription: ModuleDescription {
			description = "Sync desired requesters and support modules to this module";
		};
	};

	class SSS_Module_RemoveSupports : SSS_Module_Base {
		displayName = "Remove Supports";
		icon = ICON_TRASH;
		function = QFUNC(moduleRemoveSupports);
		scopeCurator = 2;
	};

	//class SSS_Module_UnassignRequesters : SSS_Module_Base {
	//	displayName = "Unassign Requesters";
	//	icon = ICON_ASSIGN_REQUESTERS;
	//	function = QFUNC(moduleUnassignRequesters);
	//	scopeCurator = 2;
	//};
};
