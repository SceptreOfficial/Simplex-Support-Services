class CBA_Extended_EventHandlers_base;

class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class AttributesBase {
			class ModuleDescription;
		};
		class ModuleDescription;	
	};

	class GVAR(moduleRestrictAccess): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleRestrictAccess);
		icon = ICON_LOCK;
		portrait = ICON_LOCK;
		function = "";
		isGlobal = 1;
		scope = 2;
		scopeCurator = 1;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleRestrictAccess);
		};
	};

	class GVAR(moduleManage): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleManage);
		icon = ICON_GEAR;
		portrait = ICON_GEAR;
		function = QFUNC(moduleManage);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleManage);
		};
	};

	class GVAR(moduleTerminal): Module_F {
		author = "Simplex Team";
		category = QPVAR(modules);
		displayName = CNAME(moduleTerminal);
		icon = ICON_TERMINAL;
		portrait = ICON_TERMINAL;
		function = "";
		isGlobal = 1;
		scope = 2;
		scopeCurator = 1;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleTerminal);
		};
	};
};
