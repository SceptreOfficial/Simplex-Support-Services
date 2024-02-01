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

	class GVAR(moduleAdd): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleAdd);
		icon = ICON_SERVICE;
		portrait = ICON_SERVICE;
		function = QFUNC(moduleAdd);
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
			class RelocationSpeed : Edit {
				EATTRIBUTE(common,RelocationSpeed);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class Cooldown : Edit {
				EATTRIBUTE(common,Cooldown);
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class RoundCooldown : Edit {
				ATTRIBUTE(RoundCooldown);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class Ammunition : Edit {
				ATTRIBUTE(Ammunition);
				typeName = "STRING";
				defaultValue = "[]";
			};
			class VelocityOverride : Default {
				ATTRIBUTE(VelocityOverride);
				typeName = "NUMBER";
				defaultValue = 0;
				control = QPVAR(toggle);
				class Values {
					class Default {name = CSTRING(Default);};
					class Override {name = CSTRING(Override);};
				};
			};
			class CoordinationDistance : Edit {
				ATTRIBUTE(CoordinationDistance);
				typeName = "NUMBER";
				defaultValue = 1000;
			};
			class CoordinationType : Combo {
				ATTRIBUTE(CoordinationType);
				typeName = "NUMBER";
				defaultValue = 2;
				class Values {
					class SupportsOnly {
						name = CSTRING(CoordinationTypeSupport);
						value = 0;
					};
					class NonSupportsOnly {
						name = CSTRING(CoordinationTypeNonSupport);
						value = 1;
					};
					class Anything {
						name = CSTRING(CoordinationTypeAll);
						value = 2;
						default = 1;
					};
				};
			};
			class IconSelection : Combo {
				ATTRIBUTE(IconSelection);
				typeName = "STRING";
				defaultValue = "";
				class Values {
					class Automatic {
						name = CSTRING(Automatic);
						value = "";
						picture = ICON_GEAR;
						default = 1;
					};
					class Mortar {
						name = CSTRING(Mortar);
						value = ICON_MORTAR;
						picture = ICON_MORTAR;
					};
					class Howitzer {
						name = CSTRING(Howitzer);
						value = ICON_HOWITZER;
						picture = ICON_HOWITZER;
					};
					class SelfPropelled {
						name = CSTRING(SelfPropelled);
						value = ICON_SELF_PROPELLED;
						picture = ICON_SELF_PROPELLED;
					};
					class MRLS {
						name = CSTRING(MRLS);
						value = ICON_MRLS;
						picture = ICON_MRLS;
					};
					class MRLSTruck {
						name = CSTRING(MRLSTruck);
						value = ICON_MRLS_TRUCK;
						picture = ICON_MRLS_TRUCK;
					};
					class Missile {
						name = CSTRING(Missile);
						value = ICON_MISSILE;
						picture = ICON_MISSILE;
					};
				};
			};
			class ExecutionDelay : Default {
				ATTRIBUTE(ExecutionDelay);
				typeName = "ARRAY";
				defaultValue = "[0,0]";
				control = QPVAR(editMinMax);
			};
			class FiringDelay : Default {
				ATTRIBUTE(FiringDelay);
				typeName = "ARRAY";
				defaultValue = "[0,0]";
				control = QPVAR(editMinMax);
			};
			class SheafTypes : Default {
				ATTRIBUTE(SheafTypes);
				typeName = "ARRAY";
				control = QPVAR(checkboxes);
				class Values {
					class Converged {
						name = CSTRING(Converged);
						value = 1;
					};
					class Parallel {
						name = CSTRING(Parallel);
						value = 1;
					};
					class Box {
						name = CSTRING(Box);
						value = 1;
					};
					class Creeping {
						name = CSTRING(Creeping);
						value = 1;
					};
				};
			};
			class MaxLoops : Edit {
				ATTRIBUTE(MaxLoops);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class MaxLoopDelay : Edit {
				ATTRIBUTE(MaxLoopDelay);
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class MaxTasks : Edit {
				ATTRIBUTE(MaxTasks);
				typeName = "NUMBER";
				defaultValue = -1;
			};
			class MaxRounds : Edit {
				ATTRIBUTE(MaxRounds);
				typeName = "NUMBER";
				defaultValue = 50;
			};
			class MaxExecutionDelay : Edit {
				ATTRIBUTE(MaxExecutionDelay);
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class MaxFiringDelay : Edit {
				ATTRIBUTE(MaxFiringDelay);
				typeName = "NUMBER";
				defaultValue = 30;
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
			description = CINFO(moduleAdd);
		};
	};
};
