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

//[
//	QGVAR(visualAidsLive),
//	"CHECKBOX",
//	DESC(visualAidsLive),
//	[ELSTRING(main,PREFIX),LSTRING(Service)],
//	true,
//	true,
//	{},
//	false
//] call CBA_fnc_addSetting;

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
	QGVAR(rangeIndicators),
	"CHECKBOX",
	DESC(rangeIndicators),
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
	QGVAR(relocateCooldown),
	"CHECKBOX",
	DESC(relocateCooldown),
	[ELSTRING(main,PREFIX),LSTRING(Service)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;
