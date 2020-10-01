class CfgVehicles {
	class Man;
	class CAManBase: Man {
		class ACE_SelfActions {
			class SSS_main {
				displayName = CSTRING(SupportServices);
				icon = ICON_SUPPORT_SERVICES;
				condition = "true";
				statement = "";
				exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
				showDisabled = 0;

				class SSS_artillery {
					displayName = CSTRING(Artillery);
					icon = ICON_ARTILLERY;
					condition = "SSS_showArtillery";
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsArtillery));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_CAS {
					displayName = CSTRING(CAS);
					icon = ICON_CAS;
					condition = "SSS_showCAS";
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsCAS));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_transport {
					displayName = CSTRING(Transport);
					icon = ICON_TRANSPORT;
					condition = "SSS_showTransport";
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsTransport));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_logistics {
					displayName = CSTRING(Logistics);
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
