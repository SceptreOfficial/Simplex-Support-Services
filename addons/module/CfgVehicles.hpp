class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class AttributesBase;
		class ModuleDescription;
	};

	class GVAR(Base): Module_F {
		category = "SSS_Modules";
		author = "Simplex Team";
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

	class GVAR(AddArtillery) : GVAR(Base) {
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
				displayName = "Respawn time";
				description = "-1 will disable respawn";
				typeName = "STRING";
				defaultValue = DEFAULT_RESPAWN_TIME;
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Minimum time between requests";
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_ARTILLERY_MIN;
			};
			class RoundCooldown {
				displayName = "Extra cooldown time per round";
				description = "Additional time incremented per round fired";
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_ARTILLERY_ROUND;
			};
			class MaxRounds {
				displayName = "Maximum rounds per request";
				description = "Max amount/slider range for requests";
				typeName = "STRING";
				defaultValue = DEFAULT_ARTILLERY_MAX_ROUNDS;
			};
			class CoordinationDistance {
				displayName = "Maximum coordination distance";
				description = "Set what ""nearby"" really means for artillery coordination";
				typeName = "STRING";
				defaultValue = DEFAULT_ARTILLERY_COORDINATION_DISTANCE;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when vehicle is added & respawned. \n(Vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASDrone) : GVAR(Base) {
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
			class Cooldown {
				displayName = "Cooldown";
				description = "Time between requests (after loiter is finished)";
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_DRONES;
			};
			class LoiterTime {
				displayName = "Loiter time";
				description = "How long aircraft will loiter in the area";
				typeName = "STRING";
				defaultValue = DEFAULT_LOITER_TIME_DRONES;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when physical vehicle is spawned. \n(Vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = "Side";
				description = "Support side";
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
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASGunship) : GVAR(Base) {
		displayName = "Add CAS Gunship";
		icon = ICON_GUNSHIP;
		function = QFUNC(moduleAddCASGunship);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Classname {
				displayName = "Classname";
				description = "Classname of gunship vehicle";
				typeName = "STRING";
				defaultValue = "B_T_VTOL_01_armed_F";
			};
			class TurretPath {
				displayName = "TurretPath";
				description = "Turret path to gunner";
				typeName = "STRING";
				defaultValue = "[1]";
			};
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "Blackfish";
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Time between requests (after loiter is finished)";
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_GUNSHIPS;
			};
			class LoiterTime {
				displayName = "Loiter time";
				description = "How long aircraft will loiter in the area";
				typeName = "STRING";
				defaultValue = DEFAULT_LOITER_TIME_GUNSHIPS;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when physical vehicle is spawned. \n(Vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = "Side";
				description = "Support side";
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
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASHeli) : GVAR(Base) {
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
				displayName = "Respawn time";
				description = "-1 will disable respawn";
				typeName = "STRING";
				defaultValue = DEFAULT_RESPAWN_TIME;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when vehicle is added & respawned. \n(Vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASPlane) : GVAR(Base) {
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
			class Cooldown {
				displayName = "Cooldown";
				description = "Time between requests";
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_PLANES;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when physical vehicle is spawned. \n(Vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = "Side";
				description = "Support side";
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
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddTransport) : GVAR(Base) {
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
				displayName = "Respawn time";
				description = "-1 will disable respawn";
				typeName = "STRING";
				defaultValue = DEFAULT_RESPAWN_TIME;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when vehicle is added & respawned. \n(Vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddLogisticsAirdrop) : GVAR(Base) {
		displayName = "Add Logistics Airdrop";
		icon = ICON_PARACHUTE;
		function = QFUNC(moduleAddLogisticsAirdrop);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Classname {
				displayName = "Classname";
				description = "Classname of air vehicle";
				typeName = "STRING";
				defaultValue = "B_T_VTOL_01_vehicle_F";
			};
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "Logistics Airdrop";
			};
			class SpawnPosition {
				displayName = "Fixed spawn position";
				description = "In format [x,y] or [x,y,z]. Leave empty to generate random position from request location.";
				typeName = "STRING";
				defaultValue = "";
			};
			class SpawnDelay {
				displayName = "Spawn delay";
				description = "Time before air vehicle is spawned after request is submitted";
				typeName = "STRING";
				defaultValue = DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY;
			};
			class FlyingHeight {
				displayName = "Flying height";
				description = "AGL altitude in meters";
				typeName = "STRING";
				defaultValue = DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT;
			};
			class ListFunction {
				displayName = "List function";
				description = "Code that must return an array of items that can be requested. \n\nSupported list item arguments: \n0: Classname <STRING> \n1: Custom name <STRING> \n2: Custom icon <STRING> \n3: Init code <CODE> \n\nExample array: \n[""Box_NATO_Wps_F"",[""Box_NATO_Equip_F"",""Equipment"","""",{systemChat ""dress up time""}]]";
				typeName = "STRING";
				defaultValue = "[]";
			};
			class UniversalInitCode {
				displayName = "Universal init code";
				description = "Code executed when any requested object is spawned. \n(Object = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class MaxAmount {
				displayName = "Maximum amount input";
				description = "Maximum number of items that can be spawned per request.";
				typeName = "STRING";
				defaultValue = "1";
			};
			class LandingSignal {
				displayName = "Landing signal";
				description = "Color of signal when item lands, or none for no signal. \nSmoke used during daytime, chemlights used at night.";
				typeName = "NUMBER";
				class values {
					class None {
						name = "None";
						value = 0;
					};
					class Yellow {
						default = 1;
						name = "Yellow";
						value = 1;
					};
					class Green {
						name = "Green";
						value = 2;
					};
					class Red {
						name = "Red";
						value = 3;
					};
					class Blue {
						name = "Blue";
						value = 4;
					};
				};
			};
			class Cooldown {
				displayName = "Cooldown";
				description = "Time between requests";
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_LOGISTICS_AIRDROP;
			};
			class CustomInit {
				displayName = "Custom init code";
				description = "Code executed when air vehicle is spawned. \n(Vehicle = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = "Side";
				description = "Support side";
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
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddLogisticsStation) : GVAR(Base) {
		displayName = "Add Logistics Station";
		icon = ICON_BOX;
		function = QFUNC(moduleAddLogisticsStation);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Callsign {
				displayName = "Callsign";
				description = "Display name";
				typeName = "STRING";
				defaultValue = "Logistics Station";
			};
			class ListFunction {
				displayName = "List function";
				description = "Code that must return an array of items that can be requested. \n\nSupported list item arguments: \n0: Classname <STRING> \n1: Custom name <STRING> \n2: Custom icon <STRING> \n3: Init code <CODE> \n\nExample array: \n[""Box_NATO_Wps_F"",[""Box_NATO_Equip_F"",""Equipment"","""",{systemChat ""dress up time""}]]";
				typeName = "STRING";
				defaultValue = "[]";
			};
			class UniversalInitCode {
				displayName = "Universal init code";
				description = "Code executed when any requested object is spawned \n(Object = _this)";
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = "Side";
				description = "Support side";
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
			class AccessItems {
				displayName = "Access items";
				description = "Item classes that permit usage of support. \nSeparate with commas (eg. itemMap,itemRadio)";
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = "Access condition";
				description = "Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];";
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(RemoveSupports) : GVAR(Base) {
		displayName = "Remove Supports";
		icon = ICON_TRASH;
		function = QFUNC(moduleRemoveSupports);
		scopeCurator = 2;
	};
};
