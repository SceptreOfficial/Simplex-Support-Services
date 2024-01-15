#include "script_component.hpp"

params ["_vehicle"];

private _class = "";
private _pylons = [];

if (_vehicle isKindOf "Air") then {
	_class = typeOf _vehicle;
	_pylons = _vehicle call EFUNC(common,getPylons);
};

[LLSTRING(moduleAddStrafe_name),[
	["EDITBOX",DESC(aircraftClass),_class],
	["COMBOBOX",EDESC(common,side),[[
		[LELSTRING(common,SideWest),"",ICON_WEST],
		[LELSTRING(common,SideEast),"",ICON_EAST],
		[LELSTRING(common,SideGuer),"",ICON_GUER]
	],west,[west,east,independent]]],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),60],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(spawnDistance),8000],
	["ARRAY",DESC(spawnDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["EDITBOX",DESC(maxSpread),200],
	["EDITBOX",DESC(pylons),str _pylons],
	["TOOLBOX",DESC(infiniteAmmo),[[LELSTRING(common,enable),LELSTRING(common,disable)],1,[true,false]]],
	["LISTNBOXCB",DESC(targetTypes),[[
		LLSTRING(targetMap),
		LLSTRING(targetLaser),
		LLSTRING(targetSmoke),
		LLSTRING(targetIR),
		LLSTRING(targetFlare),
		LLSTRING(targetEnemies),
		LLSTRING(targetInfantry),
		LLSTRING(targetVehicles)
	],true,5,STRAFE_TARGETS]],
	["EDITBOX",DESC(friendlyRange),50],
	["TOOLBOX",DESC(countermeasures),[[LELSTRING(common,enable),LELSTRING(common,disable)],0,[true,false]]],
	["EDITBOX",EDESC(common,vehicleInit),""],
	["CHECKBOX",EDESC(common,remoteAccess),true],
	["EDITBOX",EDESC(common,accessItems),""],
	["TOOLBOX",EDESC(common,accessItemsLogic),[[LELSTRING(common,LogicAND),LELSTRING(common,LogicOR)],0,[false,true]]],
	["EDITBOX",EDESC(common,accessCondition),"true"],
	["EDITBOX",EDESC(common,requestCondition),"true"]
],{
	params ["_values"];
	_values params [
		"_class",
		"_side",
		"_callsign",
		"_cooldown",
		"_virtualRunway",
		"_spawnDistance",
		"_spawnDelay",
		"_maxSpread",
		"_pylons",
		"_infiniteAmmo",
		"_friendlyRange",
		"_targetTypes",
		"_countermeasures",
		"_vehicleInit",
		"_remoteAccess",
		"_accessItems",
		"_accessItemsLogic",
		"_accessCondition",
		"_requestCondition",
		"_authorizations"
	];

	[
		_class,
		_side,
		_callsign,
		[parseNumber _cooldown,0],
		_virtualRunway,
		parseNumber _spawnDistance,
		_spawnDelay,
		parseNumber _maxSpread,
		_pylons call EFUNC(common,parseArray),
		_infiniteAmmo,
		parseNumber _friendlyRange,
		_targetTypes,
		_countermeasures,
		_vehicleInit,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addStrafe);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
}] call EFUNC(sdf,dialog);
