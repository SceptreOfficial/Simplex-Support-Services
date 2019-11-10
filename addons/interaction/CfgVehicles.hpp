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
					condition = "SSS_showArtillery";
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsArtillery));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_CAS {
					displayName = "CAS";
					icon = ICON_CAS;
					condition = "SSS_showCAS";
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsCAS));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_transport {
					displayName = "Transport";
					icon = ICON_TRANSPORT;
					condition = "SSS_showTransport";
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsTransport));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_logistics {
					displayName = "Logistics";
					icon = ICON_BOX;
					condition = "SSS_showLogistics";
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsLogistics));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};
			};
		};
	};
};
