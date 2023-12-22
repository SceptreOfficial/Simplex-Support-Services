#include "script_component.hpp"

params ["_signal"];

switch true do {
	case (_signal isKindOf "FlareBase" || _signal isKindOf "ACE_G_Handflare_White") : {
		localize (LSTRING(Flare) + (_signal call FUNC(signalColor)))
	};
	case (_signal isKindOf "SmokeShell") : {
		localize (LSTRING(Smoke) + (_signal call FUNC(signalColor)))
	};
	case (_signal isKindOf "IRStrobeBase") : {
		LLSTRING(IRStrobe)
	};
	default {
		"Signal"
	};
};
