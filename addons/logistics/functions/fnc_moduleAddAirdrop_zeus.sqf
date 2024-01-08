#include "script_component.hpp"

params ["_class"];

if (_class isEqualTo "") then {
	_class = "B_T_VTOL_01_vehicle_F";
};

[LLSTRING(ModuleAddAirdropName),[
	["EDITBOX",DESC(aircraftClass),_class],
	["COMBOBOX",EDESC(common,side),[[
		[LELSTRING(common,SideWest),"",ICON_WEST],
		[LELSTRING(common,SideEast),"",ICON_EAST],
		[LELSTRING(common,SideGuer),"",ICON_GUER]
	],west,[west,east,independent]]],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),60],
	["EDITBOX",DESC(itemCooldown),10],
	["EDITBOX",DESC(altitude),500],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(spawnDistance),6000],
	["ARRAY",DESC(spawnDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["EDITBOX",DESC(openAltitudeAI),-1],
	["EDITBOX",DESC(openAltitudeObjects),-1],
	["EDITBOX",DESC(capacity),10],
	["EDITBOX",DESC(listFunction),"[]"],
	["EDITBOX",DESC(itemInit),""],
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
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addAirdrop);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
}] call EFUNC(sdf,dialog);
