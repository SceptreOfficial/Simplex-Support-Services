#include "..\script_component.hpp"

params ["_vehicle"];

private _class = "";
private _pylons = [];
private _side = side group _vehicle;

if (_vehicle isKindOf "Air") then {
	_class = typeOf _vehicle;
	_pylons = _vehicle call EFUNC(common,getPylons);
};

[LLSTRING(moduleAddStrafe_name),[
	["EDITBOX",DESC(aircraftClass),_class],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),60],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(spawnDistance),8000],
	["ARRAY",DESC(spawnDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["EDITBOX",DESC(maxSpread),200],
	["EDITBOX",DESC(pylons),str _pylons],
	["TOOLBOX",DESC(infiniteAmmo),[[LELSTRING(common,enable),LELSTRING(common,disable)],1,[true,false]]],
	["LISTNBOXCB",DESC(targetTypes),[[
		LELSTRING(common,targetMap),
		LELSTRING(common,targetLaser),
		LELSTRING(common,targetSmoke),
		LELSTRING(common,targetIR),
		LELSTRING(common,targetFlare),
		LELSTRING(common,targetEnemies),
		LELSTRING(common,targetInfantry),
		LELSTRING(common,targetVehicles)
	],true,5,STRAFE_TARGETS]],
	["EDITBOX",DESC(friendlyRange),50],
	["TOOLBOX",DESC(countermeasures),[[LELSTRING(common,enable),LELSTRING(common,disable)],0,[true,false]]],
	["EDITBOX",EDESC(common,vehicleInit),""],
	FINAL_ATTRIBUTES_ZEUS
],{
	params ["_values"];
	_values params [
		"_class",
		"_callsign",
		"_cooldown",
		"_virtualRunway",
		"_spawnDistance",
		"_spawnDelay",
		"_maxSpread",
		"_pylons",
		"_infiniteAmmo",
		"_targetTypes",
		"_friendlyRange",
		"_countermeasures",
		"_vehicleInit",
		"_side",
		"_remoteAccess",
		"_accessItems",
		"_accessItemsLogic",
		"_accessCondition",
		"_requestCondition",
		"_authorizations"
	];

	[
		_class,
		_callsign,
		[parseNumber _cooldown,0],
		_virtualRunway,
		parseNumber _spawnDistance,
		_spawnDelay,
		parseNumber _maxSpread,
		_pylons call EFUNC(common,parseArray),
		_infiniteAmmo,
		_targetTypes,
		parseNumber _friendlyRange,
		_countermeasures,
		_vehicleInit,
		_side,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addStrafe);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
}] call EFUNC(sdf,dialog);
