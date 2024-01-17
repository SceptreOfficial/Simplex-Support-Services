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
	QGVAR(visualAidsLive),
	"CHECKBOX",
	DESC(visualAidsLive),
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

