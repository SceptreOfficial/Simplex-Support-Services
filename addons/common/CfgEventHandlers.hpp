class Extended_PreStart_EventHandlers {
	class ADDON {
		init = QUOTE(call COMPILE_FILE(XEH_preStart));
	};
};
class Extended_PreInit_EventHandlers {
	class ADDON {
		init = QUOTE(call COMPILE_FILE(XEH_preInit));
	};
};
class Extended_PostInit_EventHandlers {
	class ADDON {
		init = QUOTE(call COMPILE_FILE(XEH_postInit));
	};
};
class Extended_Init_EventHandlers {
	class Module_F {
		class ADDON {
			init = QUOTE(_this call FUNC(initModule));
		};
	};
};
class Extended_DisplayUnload_EventHandlers {
    class RscDisplayCurator {
        ADDON = QUOTE(_this call FUNC(zeusDisplayUnload));
    };
};
