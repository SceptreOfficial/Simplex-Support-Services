class CBA_Extended_EventHandlers_base;

class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class AttributesBase {
			class Default;
			class Combo;
			class Edit;
			class Checkbox;
			class ModuleDescription;
		};
		class ModuleDescription;	
	};
/*
	class GVAR(moduleAddBombing): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddBombing);
		icon = ICON_CAS;
		portrait = ICON_CAS;
		function = QFUNC(moduleAddBombing);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			class AircraftClass : Edit {
				ATTRIBUTE(AircraftClass);
				typeName = "STRING";
				defaultValue = "''";
			};
			class Side : Combo {
				EATTRIBUTE(common,Side);
				typeName = "NUMBER";
				defaultValue = 0;
				class Values {
					class West {
						name = ECSTRING(common,SideWest);
						value = 0;
						picture = ICON_WEST;
						default = 1;
					};
					class East {
						name = ECSTRING(common,SideEast);
						value = 1;
						picture = ICON_EAST;
					};
					class Guer {
						name = ECSTRING(common,SideGuer);
						value = 2;
						picture = ICON_GUER;
					};
				};
			};
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class Cooldown : Edit {
				EATTRIBUTE(common,Cooldown);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			//class VirtualRunway : Default {
			//	ATTRIBUTE(VirtualRunway);
			//	typeName = "ARRAY";
			//	defaultValue = "[0,0,0]";
			//	control = "EditXYZ";
			//};
			class SpawnDistance : Edit {
				ATTRIBUTE(SpawnDistance);
				typeName = "NUMBER";
				defaultValue = 8000;
			};
			class SpawnDelay : Default {
				ATTRIBUTE(SpawnDelay);
				typeName = "ARRAY";
				defaultValue = "[0,0]";
				control = QPVAR(editMinMax);
			};
			class MaxAircraft : Edit {
				ATTRIBUTE(MaxAircraft);
				typeName = "NUMBER";
				defaultValue = 5;
			};
			class MaxSpread : Edit {
				ATTRIBUTE(MaxSpread);
				typeName = "NUMBER";
				defaultValue = 1000;
			};
			class Pylons : Edit {
				ATTRIBUTE(Pylons);
				typeName = "STRING";
				defaultValue = "[]";
			};
			class InfiniteAmmo : Default {
				ATTRIBUTE(InfiniteAmmo);
				typeName = "NUMBER";
				defaultValue = 1;
				control = QPVAR(toggle);
				class Values {
					class Enable {name = ECSTRING(common,enable);};
					class Disable {name = ECSTRING(common,disable);};
				};
			};
			//class TargetTypes : Default {
			//	ATTRIBUTE(TargetTypes);
			//	typeName = "ARRAY";
			//	control = QPVAR(checkboxes);
			//	class Values {
			//		class Map {
			//			name = CSTRING(targetMap);
			//			value = 1;
			//		};
			//		class Laser {
			//			name = CSTRING(targetLaser);
			//			value = 1;
			//		};
			//		class Smoke {
			//			name = CSTRING(targetSmoke);
			//			value = 1;
			//		};
			//		class IR {
			//			name = CSTRING(targetIR);
			//			value = 1;
			//		};
			//		class Flare {
			//			name = CSTRING(targetFlare);
			//			value = 1;
			//		};
			//	};
			//};
			//class Countermeasures : Default {
			//	ATTRIBUTE(Countermeasures);
			//	typeName = "NUMBER";
			//	defaultValue = 0;
			//	control = QPVAR(toggle);
			//	class Values {
			//		class Enable {name = ECSTRING(common,enable);};
			//		class Disable {name = ECSTRING(common,disable);};
			//	};
			//};
			class VehicleInit : Default {
				EATTRIBUTE(common,VehicleInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddBombing);
		};
	};
*/
	class GVAR(moduleAddLoiter): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddLoiter);
		icon = ICON_COUNTER_CLOCKWISE;
		portrait = ICON_COUNTER_CLOCKWISE;
		function = QFUNC(moduleAddLoiter);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			//class DeleteSynced : Checkbox {
			//	ATTRIBUTE(DeleteSynced);
			//	typeName = "BOOL";
			//	defaultValue = "true";
			//};
			class AircraftClass : Edit {
				ATTRIBUTE(AircraftClass);
				typeName = "STRING";
				defaultValue = "''";
			};
			class Side : Combo {
				EATTRIBUTE(common,Side);
				typeName = "NUMBER";
				defaultValue = 0;
				class Values {
					class West {
						name = ECSTRING(common,SideWest);
						value = 0;
						picture = ICON_WEST;
						default = 1;
					};
					class East {
						name = ECSTRING(common,SideEast);
						value = 1;
						picture = ICON_EAST;
					};
					class Guer {
						name = ECSTRING(common,SideGuer);
						value = 2;
						picture = ICON_GUER;
					};
				};
			};
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class Cooldown : Edit {
				EATTRIBUTE(common,Cooldown);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class VirtualRunway : Default {
				ATTRIBUTE(VirtualRunway);
				typeName = "ARRAY";
				defaultValue = "[0,0,0]";
				control = "EditXYZ";
			};
			class SpawnDistance : Edit {
				ATTRIBUTE(SpawnDistance);
				typeName = "NUMBER";
				defaultValue = 8000;
			};
			class SpawnDelay : Default {
				ATTRIBUTE(SpawnDelay);
				typeName = "ARRAY";
				defaultValue = "[0,0]";
				control = QPVAR(editMinMax);
			};
			class AltitudeLimits : Default {
				ATTRIBUTE(AltitudeLimits);
				typeName = "ARRAY";
				defaultValue = "[500,3000]";
				control = QPVAR(editMinMax);
			};
			class RadiusLimits : Default {
				ATTRIBUTE(RadiusLimits);
				typeName = "ARRAY";
				defaultValue = "[300,2500]";
				control = QPVAR(editMinMax);
			};
			class Duration : Edit {
				ATTRIBUTE(Duration);
				typeName = "NUMBER";
				defaultValue = 600;
			};
			class Repositioning : Default {
				ATTRIBUTE(Repositioning);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Enable {name = ECSTRING(common,enable);};
					class Disable {name = ECSTRING(common,disable);};
				};
			};
			class Pylons : Edit {
				ATTRIBUTE(Pylons);
				typeName = "STRING";
				defaultValue = "[]";
			};
			class InfiniteAmmo : Default {
				ATTRIBUTE(InfiniteAmmo);
				typeName = "NUMBER";
				defaultValue = 1;
				control = QPVAR(toggle);
				class Values {
					class Enable {name = ECSTRING(common,enable);};
					class Disable {name = ECSTRING(common,disable);};
				};
			};
			class FriendlyRange : Edit {
				ATTRIBUTE(FriendlyRange);
				typeName = "NUMBER";
				defaultValue = 50;
			};
			class TargetTypes : Default {
				ATTRIBUTE(TargetTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Enemies {
						name = CSTRING(targetEnemies);
						value = 1;
					};
					class Infantry {
						name = CSTRING(targetInfantry);
						value = 1;
					};
					class Vehicles {
						name = CSTRING(targetVehicles);
						value = 1;
					};
					class Map {
						name = CSTRING(targetMap);
						value = 1;
					};
					class Laser {
						name = CSTRING(targetLaser);
						value = 1;
					};
					class Smoke {
						name = CSTRING(targetSmoke);
						value = 1;
					};
					class IR {
						name = CSTRING(targetIR);
						value = 1;
					};
					class Flare {
						name = CSTRING(targetFlare);
						value = 1;
					};
				};
			};
			class VehicleInit : Default {
				EATTRIBUTE(common,VehicleInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			class RemoteControl : Default {
				ATTRIBUTE(RemoteControl);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Allow {name = ECSTRING(common,allow);};
					class Deny {name = ECSTRING(common,deny);};
				};
			};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddLoiter);
		};
	};

	class GVAR(moduleAddStrafe): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddStrafe);
		icon = ICON_CAS;
		portrait = ICON_CAS;
		function = QFUNC(moduleAddStrafe);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			//class DeleteSynced : Checkbox {
			//	ATTRIBUTE(DeleteSynced);
			//	typeName = "BOOL";
			//	defaultValue = "true";
			//};
			class AircraftClass : Edit {
				ATTRIBUTE(AircraftClass);
				typeName = "STRING";
				defaultValue = "''";
			};
			class Side : Combo {
				EATTRIBUTE(common,Side);
				typeName = "NUMBER";
				defaultValue = 0;
				class Values {
					class West {
						name = ECSTRING(common,SideWest);
						value = 0;
						picture = ICON_WEST;
						default = 1;
					};
					class East {
						name = ECSTRING(common,SideEast);
						value = 1;
						picture = ICON_EAST;
					};
					class Guer {
						name = ECSTRING(common,SideGuer);
						value = 2;
						picture = ICON_GUER;
					};
				};
			};
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class Cooldown : Edit {
				EATTRIBUTE(common,Cooldown);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class VirtualRunway : Default {
				ATTRIBUTE(VirtualRunway);
				typeName = "ARRAY";
				defaultValue = "[0,0,0]";
				control = "EditXYZ";
			};
			class SpawnDistance : Edit {
				ATTRIBUTE(SpawnDistance);
				typeName = "NUMBER";
				defaultValue = 8000;
			};
			class SpawnDelay : Default {
				ATTRIBUTE(SpawnDelay);
				typeName = "ARRAY";
				defaultValue = "[0,0]";
				control = QPVAR(editMinMax);
			};
			class MaxSpread : Edit {
				ATTRIBUTE(MaxSpread);
				typeName = "NUMBER";
				defaultValue = 200;
			};
			class Pylons : Edit {
				ATTRIBUTE(Pylons);
				typeName = "STRING";
				defaultValue = "[]";
			};
			class InfiniteAmmo : Default {
				ATTRIBUTE(InfiniteAmmo);
				typeName = "NUMBER";
				defaultValue = 1;
				control = QPVAR(toggle);
				class Values {
					class Enable {name = ECSTRING(common,enable);};
					class Disable {name = ECSTRING(common,disable);};
				};
			};
			class TargetTypes : Default {
				ATTRIBUTE(TargetTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Map {
						name = CSTRING(targetMap);
						value = 1;
					};
					class Laser {
						name = CSTRING(targetLaser);
						value = 1;
					};
					class Smoke {
						name = CSTRING(targetSmoke);
						value = 1;
					};
					class IR {
						name = CSTRING(targetIR);
						value = 1;
					};
					class Flare {
						name = CSTRING(targetFlare);
						value = 1;
					};
				};
			};
			class Countermeasures : Default {
				ATTRIBUTE(Countermeasures);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Enable {name = ECSTRING(common,enable);};
					class Disable {name = ECSTRING(common,disable);};
				};
			};
			class VehicleInit : Default {
				EATTRIBUTE(common,VehicleInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddStrafe);
		};
	};
};
