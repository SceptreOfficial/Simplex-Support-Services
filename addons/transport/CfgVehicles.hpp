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

	class GVAR(moduleAddBoat): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddBoat);
		icon = ICON_BOAT_TRANSPORT;
		portrait = ICON_BOAT_TRANSPORT;
		function = QFUNC(moduleAddBoat);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			PROVIDER_CATEGORY;
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class RespawnDelay : Edit {
				EATTRIBUTE(common,RespawnDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class Relocation : Default {
				EATTRIBUTE(common,Relocation);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Allow {name = ECSTRING(common,allow);};
					class Deny {name = ECSTRING(common,deny);};
				};
			};
			class RelocationDelay : Edit {
				EATTRIBUTE(common,RelocationDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class TaskTypes : Default {
				ATTRIBUTE(TaskTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Move {
						name = CSTRING(Move);
						value = 1;
					};
					class Follow {
						name = CSTRING(Follow);
						value = 1;
					};
					class Hold {
						name = CSTRING(Hold);
						value = 1;
					};
					class Unload {
						name = CSTRING(Unload);
						value = 1;
					};
					class SAD {
						name = CSTRING(SAD);
						value = 1;
					};
					class Fire {
						name = CSTRING(Fire);
						value = 1;
					};
				};
			};
			class MaxTasks : Edit {
				ATTRIBUTE(MaxTasks);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class MaxTimeout : Edit {
				ATTRIBUTE(MaxTimeout);
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class VehicleInit : Default {
				EATTRIBUTE(common,VehicleInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			//class RemoteControl : Default {
			//	ATTRIBUTE(RemoteControl);
			//	typeName = "NUMBER";
			//	defaultValue = 1;
			//	control = QPVAR(toggle);
			//	class Values {
			//		class Allow {name = ECSTRING(common,allow);};
			//		class Deny {name = ECSTRING(common,deny);};
			//	};
			//};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddBoat);
		};
	};

	class GVAR(moduleAddHelicopter): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddHelicopter);
		icon = ICON_HELO_TRANSPORT;
		portrait = ICON_HELO_TRANSPORT;
		function = QFUNC(moduleAddHelicopter);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			PROVIDER_CATEGORY;
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class RespawnDelay : Edit {
				EATTRIBUTE(common,RespawnDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class Relocation : Default {
				EATTRIBUTE(common,Relocation);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Allow {name = ECSTRING(common,allow);};
					class Deny {name = ECSTRING(common,deny);};
				};
			};
			class RelocationDelay : Edit {
				EATTRIBUTE(common,RelocationDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class TaskTypes : Default {
				ATTRIBUTE(TaskTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Move {
						name = CSTRING(Move);
						value = 1;
					};
					class Follow {
						name = CSTRING(Follow);
						value = 1;
					};
					class Hold {
						name = CSTRING(Hold);
						value = 1;
					};
					class Land {
						name = CSTRING(Land);
						value = 1;
					};
					class LandSignal {
						name = CSTRING(LandSignal);
						value = 1;
					};
					class Hover {
						name = CSTRING(Hover);
						value = 1;
					};
					class Fastrope {
						name = CSTRING(Fastrope);
						value = 1;
					};
					class Helocast {
						name = CSTRING(Helocast);
						value = 1;
					};
					class Loiter {
						name = CSTRING(Loiter);
						value = 1;
					};
					class SlingloadPickup {
						name = CSTRING(SlingloadPickup);
						value = 1;
					};
					class SlingloadDropoff {
						name = CSTRING(SlingloadDropoff);
						value = 1;
					};
					class Unload {
						name = CSTRING(Unload);
						value = 1;
					};
					class Paradrop {
						name = CSTRING(Paradrop);
						value = 1;
					};
					class SAD {
						name = CSTRING(SAD);
						value = 1;
					};
					class Strafe {
						name = CSTRING(Strafe);
						value = 1;
					};
				};
			};
			class AltitudeLimits : Default {
				ATTRIBUTE(AltitudeLimits);
				typeName = "ARRAY";
				defaultValue = "[0,3000]";
				control = QPVAR(editMinMax);
			};
			class MaxTasks : Edit {
				ATTRIBUTE(MaxTasks);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class MaxTimeout : Edit {
				ATTRIBUTE(MaxTimeout);
				typeName = "NUMBER";
				defaultValue = 300;
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
				defaultValue = 1;
				control = QPVAR(toggle);
				class Values {
					class Allow {name = ECSTRING(common,allow);};
					class Deny {name = ECSTRING(common,deny);};
				};
			};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddHelicopter);
		};
	};

	class GVAR(moduleAddLand): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddLand);
		icon = ICON_LAND_TRANSPORT;
		portrait = ICON_LAND_TRANSPORT;
		function = QFUNC(moduleAddLand);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			PROVIDER_CATEGORY;
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class RespawnDelay : Edit {
				EATTRIBUTE(common,RespawnDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class Relocation : Default {
				EATTRIBUTE(common,Relocation);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Allow {name = ECSTRING(common,allow);};
					class Deny {name = ECSTRING(common,deny);};
				};
			};
			class RelocationDelay : Edit {
				EATTRIBUTE(common,RelocationDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class TaskTypes : Default {
				ATTRIBUTE(TaskTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Move {
						name = CSTRING(Move);
						value = 1;
					};
					class Path {
						name = CSTRING(Path);
						value = 1;
					};
					class Follow {
						name = CSTRING(Follow);
						value = 1;
					};
					class Hold {
						name = CSTRING(Hold);
						value = 1;
					};
					class Unload {
						name = CSTRING(Unload);
						value = 1;
					};
					class SAD {
						name = CSTRING(SAD);
						value = 1;
					};
					class Fire {
						name = CSTRING(Fire);
						value = 1;
					};
				};
			};
			class MaxTasks : Edit {
				ATTRIBUTE(MaxTasks);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class MaxTimeout : Edit {
				ATTRIBUTE(MaxTimeout);
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class VehicleInit : Default {
				EATTRIBUTE(common,VehicleInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			//class RemoteControl : Default {
			//	ATTRIBUTE(RemoteControl);
			//	typeName = "NUMBER";
			//	defaultValue = 1;
			//	control = QPVAR(toggle);
			//	class Values {
			//		class Allow {name = ECSTRING(common,allow);};
			//		class Deny {name = ECSTRING(common,deny);};
			//	};
			//};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddLand);
		};
	};

	class GVAR(moduleAddPlane): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddPlane);
		icon = ICON_PLANE_TRANSPORT;
		portrait = ICON_PLANE_TRANSPORT;
		function = QFUNC(moduleAddPlane);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			PROVIDER_CATEGORY;
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class RespawnDelay : Edit {
				EATTRIBUTE(common,RespawnDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class TaskTypes : Default {
				ATTRIBUTE(TaskTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Move {
						name = CSTRING(Move);
						value = 1;
					};
					class Follow {
						name = CSTRING(Follow);
						value = 1;
					};
					class Hold {
						name = CSTRING(Hold);
						value = 1;
					};
					//class Land {
					//	name = CSTRING(Land);
					//	value = 1;
					//};
					//class Unload {
					//	name = CSTRING(Unload);
					//	value = 1;
					//};
					class Paradrop {
						name = CSTRING(Paradrop);
						value = 1;
					};
					class SAD {
						name = CSTRING(SAD);
						value = 1;
					};
					class Strafe {
						name = CSTRING(Strafe);
						value = 1;
					};
				};
			};
			class AltitudeLimits : Default {
				ATTRIBUTE(AltitudeLimits);
				typeName = "ARRAY";
				defaultValue = "[0,3000]";
				control = QPVAR(editMinMax);
			};
			class VirtualRunway : Default {
				ATTRIBUTE(VirtualRunway);
				typeName = "ARRAY";
				defaultValue = "[0,0,0]";
				control = "EditXYZ";
			};
			class MaxTasks : Edit {
				ATTRIBUTE(MaxTasks);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class MaxTimeout : Edit {
				ATTRIBUTE(MaxTimeout);
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class VehicleInit : Default {
				EATTRIBUTE(common,VehicleInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			//class RemoteControl : Default {
			//	ATTRIBUTE(RemoteControl);
			//	typeName = "NUMBER";
			//	defaultValue = 1;
			//	control = QPVAR(toggle);
			//	class Values {
			//		class Allow {name = ECSTRING(common,allow);};
			//		class Deny {name = ECSTRING(common,deny);};
			//	};
			//};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddPlane);
		};
	};

	class GVAR(moduleAddVTOL): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAddVTOL);
		icon = ICON_VTOL_TRANSPORT;
		portrait = ICON_VTOL_TRANSPORT;
		function = QFUNC(moduleAddVTOL);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		PVAR(entity) = 1;

		class Attributes: AttributesBase {
			PROVIDER_CATEGORY;
			class Callsign : Edit {
				EATTRIBUTE(common,Callsign);
				typeName = "STRING";
				defaultValue = "''";
			};
			class RespawnDelay : Edit {
				EATTRIBUTE(common,RespawnDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class Relocation : Default {
				EATTRIBUTE(common,Relocation);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Allow {name = ECSTRING(common,allow);};
					class Deny {name = ECSTRING(common,deny);};
				};
			};
			class RelocationDelay : Edit {
				EATTRIBUTE(common,RelocationDelay);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class TaskTypes : Default {
				ATTRIBUTE(TaskTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Move {
						name = CSTRING(Move);
						value = 1;
					};
					class Follow {
						name = CSTRING(Follow);
						value = 1;
					};
					class Hold {
						name = CSTRING(Hold);
						value = 1;
					};
					class Land {
						name = CSTRING(Land);
						value = 1;
					};
					class LandSignal {
						name = CSTRING(LandSignal);
						value = 1;
					};
					class Hover {
						name = CSTRING(Hover);
						value = 1;
					};
					class Fastrope {
						name = CSTRING(Fastrope);
						value = 1;
					};
					class Helocast {
						name = CSTRING(Helocast);
						value = 1;
					};
					class Loiter {
						name = CSTRING(Loiter);
						value = 1;
					};
					class Unload {
						name = CSTRING(Unload);
						value = 1;
					};
					class Paradrop {
						name = CSTRING(Paradrop);
						value = 1;
					};
					class SAD {
						name = CSTRING(SAD);
						value = 1;
					};
					class Strafe {
						name = CSTRING(Strafe);
						value = 1;
					};
				};
			};
			class AltitudeLimits : Default {
				ATTRIBUTE(AltitudeLimits);
				typeName = "ARRAY";
				defaultValue = "[0,3000]";
				control = QPVAR(editMinMax);
			};
			class MaxTasks : Edit {
				ATTRIBUTE(MaxTasks);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class MaxTimeout : Edit {
				ATTRIBUTE(MaxTimeout);
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class VehicleInit : Default {
				EATTRIBUTE(common,VehicleInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			//class RemoteControl : Default {
			//	ATTRIBUTE(RemoteControl);
			//	typeName = "NUMBER";
			//	defaultValue = 1;
			//	control = QPVAR(toggle);
			//	class Values {
			//		class Allow {name = ECSTRING(common,allow);};
			//		class Deny {name = ECSTRING(common,deny);};
			//	};
			//};
			FINAL_ATTRIBUTES;
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleAddVTOL);
		};
	};
};
