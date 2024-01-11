#include "script_component.hpp"

params ["_posASL"];

[LLSTRING(ModuleAddStation_name),[
	["EDITBOX",DESC(direction),0],
	["COMBOBOX",EDESC(common,side),[[
		[LELSTRING(common,SideWest),"",ICON_WEST],
		[LELSTRING(common,SideEast),"",ICON_EAST],
		[LELSTRING(common,SideGuer),"",ICON_GUER]
	],west,[west,east,independent]]],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),0],
	["EDITBOX",DESC(clearingRadius),0],
	["EDITBOX",DESC(listFunction),"[]"],
	["EDITBOX",DESC(itemInit),""],
	["CHECKBOX",EDESC(common,remoteAccess),true],
	["EDITBOX",EDESC(common,accessItems),""],
	["TOOLBOX",EDESC(common,accessItemsLogic),[[LELSTRING(common,LogicAND),LELSTRING(common,LogicOR)],0,[false,true]]],
	["EDITBOX",EDESC(common,accessCondition),"true"],
	["EDITBOX",EDESC(common,requestCondition),"true"]
],{
	params ["_values","_posASL"];
	_values params [
		"_dir",
		"_side",
		"_callsign",
		"_cooldown",
		"_clearingRadius",
		"_listFunction",
		"_itemInit",
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
		_side,
		_callsign,
		parseNumber _cooldown,
		parseNumber _clearingRadius,
		[],
		_listFunction,
		_itemInit,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addStation);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
},_posASL] call EFUNC(sdf,dialog);
