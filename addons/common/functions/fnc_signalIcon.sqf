#include "script_component.hpp"

params ["_signal"];

switch true do {
	case (_signal isKindOf "FlareBase" || _signal isKindOf "ACE_G_Handflare_White") : {
		ICON_FLARE
	};
	case (_signal isKindOf "SmokeShell") : {
		ICON_SMOKE
	};
	case (_signal isKindOf "IRStrobeBase") : {
		ICON_IR
	};
	default {
		""
	};
};
