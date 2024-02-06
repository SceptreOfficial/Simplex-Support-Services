#include "..\script_component.hpp"

params ["_posASL"];

[LLSTRING(ModuleAddStation_name),[
	["EDITBOX",DESC(direction),0],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),0],
	["EDITBOX",DESC(clearingRadius),0],
	["EDITBOX",DESC(listFunction),"[]"],
	["EDITBOX",DESC(itemInit),""],
	FINAL_ATTRIBUTES_ZEUS
],{
	params ["_values","_posASL"];
	_values params [
		"_dir",
		"_callsign",
		"_cooldown",
		"_clearingRadius",
		"_listFunction",
		"_itemInit",
		"_side",
		"_remoteAccess",
		"_accessItems",
		"_accessItemsLogic",
		"_accessCondition",
		"_requestCondition",
		"_authorizations"
	];

	[
		_posASL,
		parseNumber _dir,
		_callsign,
		parseNumber _cooldown,
		parseNumber _clearingRadius,
		[],
		_listFunction,
		_itemInit,
		_side,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addStation);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
},_posASL] call EFUNC(sdf,dialog);
