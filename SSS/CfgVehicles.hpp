class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class ModuleDescription {
			class AnyPlayer;
			class AnyBrain;
			class EmptyDetector;
		};
	};

	class SSS_Module_Base : Module_F {
		author = "";
		category = "SSS";
		side = 7;
		function = "";
		functionPriority = 1;
		isGlobal = 2;
		isTriggerActivated = 0;
		isDisposable = 0;
		scope = 1;
		scopeCurator = 1;
		class Attributes {};
		class ModuleDescription : ModuleDescription {
			description = "";
		};
	};

	// Zeus Modules
	class SSS_Module_AddArtillery : SSS_Module_Base {
		category = "SSS";
		displayName = "Add Artillery";
		function = "SSS_fnc_addArtilleryModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
/*
	class SSS_Module_AddCargoVehicle : SSS_Module_Base {
		category = "SSS";
		displayName = "Add Cargo Vehicle";
		function = "SSS_fnc_addCargoVehicleModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
*/
	class SSS_Module_AddCASDrone : SSS_Module_Base {
		category = "SSS";
		displayName = "Add CAS Drone";
		function = "SSS_fnc_addCASDroneModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
	class SSS_Module_AddCASHeli : SSS_Module_Base {
		category = "SSS";
		displayName = "Add CAS Heli";
		function = "SSS_fnc_addCASHeliModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
	class SSS_Module_AddCASGunship : SSS_Module_Base {
		category = "SSS";
		displayName = "Add CAS Gunship";
		function = "SSS_fnc_addCASGunshipModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
	class SSS_Module_AddCASPlane : SSS_Module_Base {
		category = "SSS";
		displayName = "Add CAS Plane";
		function = "SSS_fnc_addCASPlaneModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
	class SSS_Module_AddTransport : SSS_Module_Base {
		category = "SSS";
		displayName = "Add Transport Heli";
		function = "SSS_fnc_addTransportModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
	class SSS_Module_RemoveCASDrone : SSS_Module_Base {
		category = "SSS";
		displayName = "Remove CAS Drone";
		function = "SSS_fnc_removeCASDroneModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
	class SSS_Module_RemoveCASGunship : SSS_Module_Base {
		category = "SSS";
		displayName = "Remove CAS Gunship";
		function = "SSS_fnc_removeCASGunshipModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
	class SSS_Module_RemoveCASPlane : SSS_Module_Base {
		category = "SSS";
		displayName = "Remove CAS Plane";
		function = "SSS_fnc_removeCASPlaneModule";
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
};
