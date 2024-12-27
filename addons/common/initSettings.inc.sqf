///////////////////////////////////////////////////////////////////////////////////////////////////
// Admin

[
	QOPTION(adminAccess),
	"CHECKBOX",
	DESC(adminAccess),
	[ELSTRING(main,PREFIX),LSTRING(CategoryAdmin)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(adminSide),
	"CHECKBOX",
	DESC(adminSide),
	[ELSTRING(main,PREFIX),LSTRING(CategoryAdmin)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Core

[
	QOPTION(cleanupCrew),
	"CHECKBOX",
	DESC(cleanupCrew),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(removeEntityOnVehicleDeletion),
	"CHECKBOX",
	DESC(removeEntityOnVehicleDeletion),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(deleteVehicleOnEntityRemoval),
	"CHECKBOX",
	DESC(deleteVehicleOnEntityRemoval),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(terminalRequireAuth),
	"CHECKBOX",
	DESC(terminalRequireAuth),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(terminalRequireItems),
	"CHECKBOX",
	DESC(terminalRequireItems),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(terminalActions),
	"LIST",
	DESC(terminalActions),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	[["BOTH","VANILLA","ACE"],[LSTRING(both),LSTRING(scrollMenu),LSTRING(ACEinteract)],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(notifyScope),
	"LIST",
	DESC(notifyScope),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	[["NONE","REQUESTER","ACCESS","SIDE"],[LSTRING(None),LSTRING(Requester),LSTRING(Access),LSTRING(Side)],2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(markerScope),
	"LIST",
	DESC(markerScope),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	[["NONE","REQUESTER","ACCESS","SIDE"],[LSTRING(None),LSTRING(Requester),LSTRING(Access),LSTRING(Side)],2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(ejectInterval),
	"SLIDER",
	DESC(ejectInterval),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	[0,5,0.5,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(remoteControlAddMap),
	"CHECKBOX",
	DESC(remoteControlAddMap),
	[ELSTRING(main,PREFIX),LSTRING(CategoryCore)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Preferences

[
	QOPTION(notificationStyle),
	"LIST",
	DESC(notificationStyle),
	[ELSTRING(main,PREFIX),LSTRING(CategoryPreferences)],
	[[0,1],[LSTRING(notificationStylePopup),LSTRING(notificationStyleChat)],0],
	false,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(closeOnConfirm),
	"CHECKBOX",
	DESC(closeOnConfirm),
	[ELSTRING(main,PREFIX),LSTRING(CategoryPreferences)],
	true,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(parachuteEquip),
	"CHECKBOX",
	DESC(parachuteEquip),
	[ELSTRING(main,PREFIX),LSTRING(CategoryPreferences)],
	true,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(parachuteDeploy),
	"CHECKBOX",
	DESC(parachuteDeploy),
	[ELSTRING(main,PREFIX),LSTRING(CategoryPreferences)],
	true,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(parachuteClass),
	"EDITBOX",
	DESC(parachuteClass),
	[ELSTRING(main,PREFIX),LSTRING(CategoryPreferences)],
	"B_Parachute",
	false,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Debug

[
	QOPTION(debugGeneral),
	"CHECKBOX",
	DESC(debugGeneral),
	[ELSTRING(main,PREFIX),LSTRING(CategoryDebug)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QOPTION(debugPerf),
	"CHECKBOX",
	DESC(debugPerf),
	[ELSTRING(main,PREFIX),LSTRING(CategoryDebug)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////