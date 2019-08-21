class CfgFunctions {
	class SSS {
		tag = "SSS";
		class common {
			file = "SSS\functions\common";
			class addWaypoint {};
			class changeBehavior {};
			class clearWaypoints {};
			class cooldown {};
			class getAmmoUsageFlags {};
			class getSmokeColor {};
			class notification {};
			class notify {};
			class properTime {};
			class remove {};
			class respawn {};
			class selectMapPosition {};
			class sortBy {};
			class updateMarker {};
		};
		class module {
			file = "SSS\functions\module";
			class addArtilleryModule {};
			class addCASDroneModule {};
			class addCASGunshipModule {};
			class addCASHeliModule {};
			class addCASPlaneModule {};
			class addTransportModule {};
			class removeCASDroneModule {};
			class removeCASGunshipModule {};
			class removeCASPlaneModule {};
			class removeEntity {};
		};
		class service {
			file = "SSS\functions\service";
			class addArtillery {};
			class addCASDrone {};
			class addCASGunship {};
			class addCASHeli {};
			class addCASPlane {};
			class addTransport {};
			class CASDroneConnectTerminal {};
			class CASGunshipControl {};
			class childActionsArtillery {};
			class childActionsCASPlane {};
			class childActionsCASHeli {};
			class childActionsTransport {};
			class onMapClick {};
			class requestArtillery {};
			class requestCASDrone {};
			class requestCASGunship {};
			class requestCASHeli {};
			class requestCASPlane {};
			class requestTransport {};
			class transportDoFastrope {};
			class transportFastrope {};
			class transportHover {};
			class transportSmokeSignal {};
		};
	};

	class SSS_CDS {
		tag = "SSS_CDS";
		class functions {
			file = "SSS\CDS\functions";
			class cacheValue {};
			class cancel {};
			class confirm {};
			class dialog {};
			class getCurrentValue {};
			class setDescription {};
			class setEnableCondition {};
			class setOnValueChanged {};
			class setValues {};
		};
	};
};
