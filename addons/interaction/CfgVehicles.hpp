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
					condition = QUOTE([ARR_2('artillery',_this)] call FUNC(serviceActionCondition));
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsArtillery));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_CAS {
					displayName = "CAS";
					icon = ICON_CAS;
					condition = QUOTE([ARR_2('CAS',_this)] call FUNC(serviceActionCondition));
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsCAS));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};

				class SSS_transport {
					displayName = "Transport";
					icon = ICON_TRANSPORT;
					condition = QUOTE([ARR_2('transport',_this)] call FUNC(serviceActionCondition));
					statement = "";
					insertChildren = QUOTE(_this call FUNC(childActionsTransport));
					exceptions[] = {"isNotDragging","notOnMap","isNotInside","isNotSitting","isNotSwimming"};
					showDisabled = 0;
				};
			};
		};
	};
};
