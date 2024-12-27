#include "..\script_component.hpp"

params ["_vehicle"];

private _class = "";
private _side = side group _vehicle;

if (_vehicle isKindOf "Helicopter") then {
	_class = typeOf _vehicle;
};

if (_class isEqualTo "") then {
	_class = "B_Heli_Transport_03_F";
};

[LLSTRING(ModuleAddSlingload_name),[
	["EDITBOX",DESC(aircraftClass),_class],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),60],
	["EDITBOX",DESC(itemCooldown),10],
	["EDITBOX",DESC(altitude),500],
	["EDITBOX",DESC(unloadAltitude),15],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(spawnDistance),8000],
	["ARRAY",DESC(spawnDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["EDITBOX",DESC(capacity),10],
	["TOOLBOX",DESC(fulfillment),[[LLSTRING(Single),LLSTRING(Multiple)],0,["SINGLE","MULTI"]]],
	["EDITBOX",DESC(listFunction),"[]"],
	["EDITBOX",DESC(itemInit),""],
	["EDITBOX",EDESC(common,vehicleInit),""],
	FINAL_ATTRIBUTES_ZEUS
],{
	params ["_values"];
	_values params [
		"_class",
		"_callsign",
		"_cooldown",
		"_itemCooldown",
		"_altitude",
		"_unloadAltitude",
		"_virtualRunway",
		"_spawnDistance",
		"_spawnDelay",
		"_capacity",
		"_fulfillment",
		"_listFunction",
		"_itemInit",
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
		[parseNumber _cooldown,parseNumber _itemCooldown],
		parseNumber _altitude,
		parseNumber _unloadAltitude,
		_virtualRunway,
		parseNumber _spawnDistance,
		_spawnDelay,
		parseNumber _capacity,
		_fulfillment,
		[],
		_listFunction,
		_itemInit,
		_vehicleInit,
		_side,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addSlingload);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
}] call EFUNC(sdf,dialog);
