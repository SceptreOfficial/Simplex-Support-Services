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

	class GVAR(moduleAddAirdrop): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddAirdrop);
		icon = ICON_PARACHUTE;
		portrait = ICON_PARACHUTE;
		function = QFUNC(moduleAddAirdrop);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			class AircraftClass : Edit {
				ATTRIBUTE(AircraftClass);
				typeName = "STRING";
				defaultValue = "'B_T_VTOL_01_vehicle_F'";
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
			class ItemCooldown : Edit {
				ATTRIBUTE(ItemCooldown);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class Altitude : Edit {
				ATTRIBUTE(Altitude);
				typeName = "NUMBER";
				defaultValue = 500;
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
				defaultValue = 6000;
			};
			class SpawnDelay : Default {
				ATTRIBUTE(SpawnDelay);
				typeName = "ARRAY";
				defaultValue = "[0,0]";
				control = QPVAR(editMinMax);
			};
			class OpenAltitudeAI : Edit {
				ATTRIBUTE(OpenAltitudeAI);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class OpenAltitudeObjects : Edit {
				ATTRIBUTE(OpenAltitudeObjects);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class Capacity : Edit {
				ATTRIBUTE(Capacity);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class ListFunction : Default {
				ATTRIBUTE(ListFunction);
				typeName = "STRING";
				defaultValue = "'[]'";
				control = "EditCodeMulti5";
				validate = "expression";
			};
			class ItemInit : Default {
				ATTRIBUTE(ItemInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
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
			description = CINFO(moduleAddAirdrop);
		};
	};

	class GVAR(moduleAddSlingload): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddSlingload);
		icon = ICON_SLINGLOAD;
		portrait = ICON_SLINGLOAD;
		function = QFUNC(moduleAddSlingload);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			class AircraftClass : Edit {
				ATTRIBUTE(AircraftClass);
				typeName = "STRING";
				defaultValue = "'B_Heli_Transport_03_F'";
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
			class ItemCooldown : Edit {
				ATTRIBUTE(ItemCooldown);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class Altitude : Edit {
				ATTRIBUTE(Altitude);
				typeName = "NUMBER";
				defaultValue = 500;
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
				defaultValue = 6000;
			};
			class SpawnDelay : Default {
				ATTRIBUTE(SpawnDelay);
				typeName = "ARRAY";
				defaultValue = "[0,0]";
				control = QPVAR(editMinMax);
			};
			class Capacity : Edit {
				ATTRIBUTE(Capacity);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class Fulfillment : Default {
				ATTRIBUTE(Fulfillment);
				typeName = "NUMBER";
				defaultValue = 1;
				control = QPVAR(toggle);
				class Values {
					class Single {name = CSTRING(Single);};
					class Multiple {name = CSTRING(Multiple);};
				};
			};
			class ListFunction : Default {
				ATTRIBUTE(ListFunction);
				typeName = "STRING";
				defaultValue = "'[]'";
				control = "EditCodeMulti5";
				validate = "expression";
			};
			class ItemInit : Default {
				ATTRIBUTE(ItemInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
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
			description = CINFO(moduleAddSlingload);
		};
	};

	class GVAR(moduleAddStation): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddStation);
		icon = ICON_BOX;
		portrait = ICON_BOX;
		function = QFUNC(moduleAddStation);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
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
				defaultValue = 0;
			};
			class ClearingRadius : Edit {
				ATTRIBUTE(ClearingRadius);
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class ListFunction : Default {
				ATTRIBUTE(ListFunction);
				typeName = "STRING";
				defaultValue = "'[]'";
				control = "EditCodeMulti5";
				validate = "expression";
			};
			class ItemInit : Default {
				ATTRIBUTE(ItemInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddStation);
			position = 1;
			direction = 1;
		};
	};

	class GVAR(moduleReferenceArea): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleReferenceArea);
		icon = ICON_GEAR;
		portrait = ICON_GEAR;
		function = QFUNC(moduleReferenceArea);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		canSetArea = 1;
		canSetAreaHeight = 1;
		canSetAreaShape = 1;

		class AttributeValues {
			isRectangle = 1;
			size3[] = {10,10,10};
		};

		class Attributes: AttributesBase {
			class Behavior : Combo {
				ATTRIBUTE(Behavior);
				typeName = "STRING";
				defaultValue = "MONITOR";
				class Values {
					class Initiate {
						name = CSTRING(Initiate_name);
						tooltip = CSTRING(Initiate_info);
						value = "INITIATE";
					};
					class Monitor {
						name = CSTRING(Monitor_name);
						tooltip = CSTRING(Monitor_info);
						value = "MONITOR";
						default = 1;
					};
				};
			};
			class Category : Edit {
				ATTRIBUTE(Category);
				typeName = "STRING";
				defaultValue = "''";
			};
			class Infantry : Combo {
				ATTRIBUTE(Infantry);
				typeName = "NUMBER";
				defaultValue = 0;
				class Values {
					class Disable {
						name = ECSTRING(common,disable);
						value = 0;
						default = 1;
					};
					class Individuals {
						name = CSTRING(individuals);
						value = 1;
					};
					class Groups {
						name =  CSTRING(groups);
						value = 2;
					};
				};
			};
			class Filter : Default {
				ATTRIBUTE(Filter);
				typeName = "STRING";
				defaultValue = "'false'";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			class LoadEval : Default {
				ATTRIBUTE(LoadEval);
				typeName = "STRING";
				defaultValue = "'1'";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			class ItemInit : Default {
				ATTRIBUTE(ItemInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};

			class ModuleDescription: ModuleDescription {};
		};
		
		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleReferenceArea);
		};
	};
};
