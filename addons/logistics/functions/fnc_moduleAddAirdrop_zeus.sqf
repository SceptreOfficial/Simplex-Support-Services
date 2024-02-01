#include "script_component.hpp"

params ["_vehicle"];

private _class = "";
private _side = side group _vehicle;

if (_vehicle isKindOf "Air") then {
	_class = typeOf _vehicle;
};

if (_class isEqualTo "") then {
	_class = "B_T_VTOL_01_vehicle_F";
};

[LLSTRING(ModuleAddAirdropName),[
	["EDITBOX",DESC(aircraftClass),_class],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),60],
	["EDITBOX",DESC(itemCooldown),10],
	["EDITBOX",DESC(altitude),500],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(spawnDistance),8000],
	["ARRAY",DESC(spawnDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["EDITBOX",DESC(openAltitudeAI),-1],
	["EDITBOX",DESC(openAltitudeObjects),-1],
	["EDITBOX",DESC(capacity),10],
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
		"_virtualRunway",
		"_spawnDistance",
		"_spawnDelay",
		"_openAltitudeAI",
		"_openAltitudeObjects",
		"_capacity",
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
		_virtualRunway,
		parseNumber _spawnDistance,
		_spawnDelay,
		parseNumber _openAltitudeAI,
		parseNumber _openAltitudeObjects,
		parseNumber _capacity,
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
	] call FUNC(addAirdrop);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
}] call EFUNC(sdf,dialog);
