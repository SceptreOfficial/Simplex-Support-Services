#include "script_component.hpp"

[
	QGVAR(manualInput),
	"CHECKBOX",
	DESC(manualInput),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(visualAids),
	"CHECKBOX",
	DESC(visualAids),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(taskMarkers),
	"CHECKBOX",
	DESC(taskMarkers),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(autoTerminals),
	"CHECKBOX",
	EDESC(common,autoTerminals),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	true,
	true,
	{},
	true
] call CBA_fnc_addSetting;

[
	QGVAR(holdTimeoutStr),
	"EDITBOX",
	DESC(holdTimeoutStr),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	"-1",
	true,
	{GVAR(holdTimeout) = parseNumber _this},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(slingloadMassOverride),
	"CHECKBOX",
	DESC(slingloadMassOverride),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(RTBReset),
	"CHECKBOX",
	DESC(RTBReset),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(RTBRestoreCrew),
	"CHECKBOX",
	DESC(RTBRestoreCrew),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(maxSearchRadiusStr),
	"EDITBOX",
	DESC(maxSearchRadiusStr),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	"1000",
	true,
	{GVAR(maxSearchRadius) = parseNumber _this},
	false
] call CBA_fnc_addSetting;
