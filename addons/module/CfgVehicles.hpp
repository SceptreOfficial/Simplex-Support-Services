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
		displayName = CSTRING(AddArtillery);
		icon = ICON_ARTILLERY;
		function = QFUNC(moduleAddArtillery);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class AmmunitionSet {
				displayName = CSTRING(AmmunitionSetName);
				description = CSTRING(AmmunitionSetDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class RespawnTime {
				displayName = CSTRING(RespawnTimeName);
				description = CSTRING(RespawnTimeDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_RESPAWN_TIME;
			};
			class Cooldown {
				displayName = CSTRING(CooldownName);
				description = CSTRING(CooldownDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_ARTILLERY_MIN;
			};
			class RoundCooldown {
				displayName = CSTRING(RoundCooldownName);
				description = CSTRING(RoundCooldownDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_ARTILLERY_ROUND;
			};
			class MaxRounds {
				displayName = CSTRING(MaxRoundsName);
				description = CSTRING(MaxRoundsDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_ARTILLERY_MAX_ROUNDS;
			};
			class CoordinationDistance {
				displayName = CSTRING(CoordinationDistanceName);
				description = CSTRING(CoordinationDistanceDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_ARTILLERY_COORDINATION_DISTANCE;
			};
			class CoordinationType {
				displayName = CSTRING(CoordinationTypeName);
				description = CSTRING(CoordinationTypeDescription);
				typeName = "NUMBER";
				class values {
					class SupportsOnly {
						name = CSTRING(CoordinationTypeSupport);
						value = 0;
					};
					class NonSupportsOnly {
						name = CSTRING(CoordinationTypeNonSupport);
						value = 1;
					};
					class Anything {
						default = 1;
						name = CSTRING(CoordinationTypeAll);
						value = 2;
					};
				};
			};
			class CustomInit {
				displayName = CSTRING(CustomInitName);
				description = CSTRING(CustomInitDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class AccessItems {
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASDrone) : GVAR(Base) {
		displayName = CSTRING(AddCASDrone);
		icon = ICON_DRONE;
		function = QFUNC(moduleAddCASDrone);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Classname {
				displayName = CSTRING(ClassnameName);
				description = CSTRING(ClassnameCASDroneDescription);
				typeName = "STRING";
				defaultValue = "B_UAV_02_F";
			};
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class Cooldown {
				displayName = CSTRING(CooldownName);
				description = CSTRING(CooldownCASDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_DRONES;
			};
			class LoiterTime {
				displayName = CSTRING(LoiterTimeName);
				description = CSTRING(LoiterTimeDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_LOITER_TIME_DRONES;
			};
			class CustomInit {
				displayName = CSTRING(CustomInitName);
				description = CSTRING(CustomInitDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = CSTRING(SideName);
				description = CSTRING(SideDescription);
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
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASGunship) : GVAR(Base) {
		displayName = CSTRING(AddCASGunship);
		icon = ICON_GUNSHIP;
		function = QFUNC(moduleAddCASGunship);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Classname {
				displayName = CSTRING(ClassnameName);
				description = CSTRING(ClassnameCASGunshipDescription);
				typeName = "STRING";
				defaultValue = "B_T_VTOL_01_armed_F";
			};
			class TurretPath {
				displayName = CSTRING(TurretPathName);
				description = CSTRING(TurretPathDescription);
				typeName = "STRING";
				defaultValue = "[1]";
			};
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = "Blackfish";
			};
			class Cooldown {
				displayName = CSTRING(CooldownName);
				description = CSTRING(CooldownCASDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_GUNSHIPS;
			};
			class LoiterTime {
				displayName = CSTRING(LoiterTimeName);
				description = CSTRING(LoiterTimeDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_LOITER_TIME_GUNSHIPS;
			};
			class CustomInit {
				displayName = CSTRING(CustomInitName);
				description = CSTRING(CustomInitDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = CSTRING(SideName);
				description = CSTRING(SideDescription);
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
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASHeli) : GVAR(Base) {
		displayName = CSTRING(AddCASHelicopter);
		icon = ICON_HELI;
		function = QFUNC(moduleAddCASHelicopter);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class RespawnTime {
				displayName = CSTRING(RespawnTimeName);
				description = CSTRING(RespawnTimeDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_RESPAWN_TIME;
			};
			class CustomInit {
				displayName = CSTRING(CustomInitName);
				description = CSTRING(CustomInitDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class AccessItems {
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddCASPlane) : GVAR(Base) {
		displayName = CSTRING(AddCASPlane);
		icon = ICON_PLANE;
		function = QFUNC(moduleAddCASPlane);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Classname {
				displayName = CSTRING(ClassnameName);
				description = CSTRING(ClassnameCASPlaneDescription);
				typeName = "STRING";
				defaultValue = "B_Plane_CAS_01_F";
			};
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class WeaponSet {
				displayName = CSTRING(WeaponSetName);
				description = CSTRING(WeaponSetDescription);
				typeName = "STRING";
				defaultValue = "[""Gatling_30mm_Plane_CAS_01_F"",""Rocket_04_HE_Plane_CAS_01_F"",""Bomb_04_Plane_CAS_01_F""]";
			};
			class Cooldown {
				displayName = CSTRING(CooldownName);
				description = CSTRING(CooldownDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_PLANES;
			};
			class CustomInit {
				displayName = CSTRING(CustomInitName);
				description = CSTRING(CustomInitDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = CSTRING(SideName);
				description = CSTRING(SideDescription);
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
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddTransport) : GVAR(Base) {
		displayName = CSTRING(AddTransport);
		icon = ICON_TRANSPORT;
		function = QFUNC(moduleAddTransport);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class RespawnTime {
				displayName = CSTRING(RespawnTimeName);
				description = CSTRING(RespawnTimeDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_RESPAWN_TIME;
			};
			class CustomInit {
				displayName = CSTRING(CustomInitName);
				description = CSTRING(CustomInitDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class AccessItems {
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddLogisticsAirdrop) : GVAR(Base) {
		displayName = CSTRING(AddLogisticsAirdrop);
		icon = ICON_PARACHUTE;
		function = QFUNC(moduleAddLogisticsAirdrop);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Classname {
				displayName = CSTRING(ClassnameName);
				description = CSTRING(ClassnameLogisticsAirdropDescription);
				typeName = "STRING";
				defaultValue = "B_T_VTOL_01_vehicle_F";
			};
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = CSTRING(CallsignLogisticsAirdropDefaultValue);
			};
			class SpawnPosition {
				displayName = CSTRING(SpawnPositionName);
				description = CSTRING(SpawnPositionDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class SpawnDelay {
				displayName = CSTRING(SpawnDelayName);
				description = CSTRING(SpawnDelayDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY;
			};
			class FlyingHeight {
				displayName = CSTRING(FlyingHeightName);
				description = CSTRING(FlyingHeightDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT;
			};
			class ListFunction {
				displayName = CSTRING(ListFunctionName);
				description = CSTRING(ListFunctionDescription);
				typeName = "STRING";
				defaultValue = "[]";
			};
			class UniversalInitCode {
				displayName = CSTRING(UniversalInitCodeName);
				description = CSTRING(UniversalInitCodeDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class MaxAmount {
				displayName = CSTRING(MaxAmountName);
				description = CSTRING(MaxAmountDescription);
				typeName = "STRING";
				defaultValue = "1";
			};
			class LandingSignal {
				displayName = CSTRING(LandingSignalName);
				description = CSTRING(LandingSignalDescription);
				typeName = "NUMBER";
				class values {
					class None {
						name = CSTRING(LandingSignalNone);
						value = 0;
					};
					class Yellow {
						default = 1;
						name = CSTRING(LandingSignalYellow);
						value = 1;
					};
					class Green {
						name = CSTRING(LandingSignalGreen);
						value = 2;
					};
					class Red {
						name = CSTRING(LandingSignalRed);
						value = 3;
					};
					class Blue {
						name = CSTRING(LandingSignalBlue);
						value = 4;
					};
				};
			};
			class Cooldown {
				displayName = CSTRING(CooldownName);
				description = CSTRING(CooldownDescription);
				typeName = "STRING";
				defaultValue = DEFAULT_COOLDOWN_LOGISTICS_AIRDROP;
			};
			class CustomInit {
				displayName = CSTRING(CustomInitName);
				description = CSTRING(CustomInitDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = CSTRING(SideName);
				description = CSTRING(SideDescription);
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
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(AddLogisticsStation) : GVAR(Base) {
		displayName = CSTRING(AddLogisticsStation);
		icon = ICON_BOX;
		function = QFUNC(moduleAddLogisticsStation);
		scope = 2;
		scopeCurator = 2;

		class Arguments {
			class Callsign {
				displayName = CSTRING(CallsignName);
				description = CSTRING(CallsignDescription);
				typeName = "STRING";
				defaultValue = CSTRING(CallsignAddLogisticsStationDefaultValue);
			};
			class ListFunction {
				displayName = CSTRING(ListFunctionName);
				description = CSTRING(ListFunctionDescription);
				typeName = "STRING";
				defaultValue = "[]";
			};
			class UniversalInitCode {
				displayName = CSTRING(UniversalInitCodeName);
				description = CSTRING(UniversalInitCodeDescription);
				typeName = "STRING";
				defaultValue = "";
			};
			class Side {
				displayName = CSTRING(SideName);
				description = CSTRING(SideDescription);
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
				displayName = CSTRING(AccessItemsName);
				description = CSTRING(AccessItemsDescription);
				typeName = "STRING";
				defaultValue = "itemMap";
			};
			class AccessCondition {
				displayName = CSTRING(AccessConditionName);
				description = CSTRING(AccessConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
			class RequestApprovalCondition {
				displayName = CSTRING(RequestApprovalConditionName);
				description = CSTRING(RequestApprovalConditionDescription);
				typeName = "STRING";
				defaultValue = "true";
			};
		};
	};

	class GVAR(RemoveSupports) : GVAR(Base) {
		displayName = CSTRING(RemoveSupports);
		icon = ICON_TRASH;
		function = QFUNC(moduleRemoveSupports);
		scopeCurator = 2;
	};
};
