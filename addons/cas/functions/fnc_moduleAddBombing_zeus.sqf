#include "..\script_component.hpp"

params ["_vehicle"];

if (true) exitWith {
	LOG_ERROR("Zeus module still in development");
	playSound QPVAR(failure);
};

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
	["EDITBOX",DESC(pylons),str _pylons],
	["TOOLBOX",DESC(infiniteAmmo),[[LELSTRING(common,enable),LELSTRING(common,disable)],1,[true,false]]],
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
		"_pylons",
		"_infiniteAmmo",
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
		_pylons call EFUNC(common,parseArray),
		_infiniteAmmo,
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
