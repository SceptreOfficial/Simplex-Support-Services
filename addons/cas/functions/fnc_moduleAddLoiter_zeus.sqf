#include "script_component.hpp"

params ["_vehicle"];

private _class = "";
private _pylons = [];

if (_vehicle isKindOf "Air") then {
	_class = typeOf _vehicle;
	_pylons = [_vehicle,{_turret isNotEqualTo [-1]}] call EFUNC(common,getPylons);
};

[LLSTRING(moduleAddLoiter_name),[
	["EDITBOX",DESC(aircraftClass),_class],
	["COMBOBOX",EDESC(common,side),[[
		[LELSTRING(common,SideWest),"",ICON_WEST],
		[LELSTRING(common,SideEast),"",ICON_EAST],
		[LELSTRING(common,SideGuer),"",ICON_GUER]
	],west,[west,east,independent]]],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),60],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(spawnDistance),6000],
	["ARRAY",DESC(spawnDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["ARRAY",DESC(AltitudeLimits),[[LELSTRING(common,Min),LELSTRING(common,Max)],[500,3000]]],
	["ARRAY",DESC(RadiusLimits),[[LELSTRING(common,Min),LELSTRING(common,Max)],[300,2500]]],
	["EDITBOX",DESC(Duration),600],
	["TOOLBOX",DESC(Repositioning),[[LELSTRING(common,enable),LELSTRING(common,disable)],0,[true,false]]],
	["EDITBOX",DESC(pylons),str _pylons],
	["TOOLBOX",DESC(infiniteAmmo),[[LELSTRING(common,enable),LELSTRING(common,disable)],1,[true,false]]],
	["EDITBOX",DESC(FriendlyRange),200],
	["LISTNBOXCB",DESC(targetTypes),[[
		LLSTRING(targetMap),
		LLSTRING(targetLaser),
		LLSTRING(targetSmoke),
		LLSTRING(targetIR),
		LLSTRING(targetFlare),
		LLSTRING(targetEnemies),
		LLSTRING(targetInfantry),
		LLSTRING(targetVehicles)
	],true,5,LOITER_TARGETS]],
	["EDITBOX",EDESC(common,vehicleInit),""],
	["TOOLBOX",DESC(remoteControl),[[LELSTRING(common,enable),LELSTRING(common,disable)],0,[true,false]]],
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
		"_altitudeLimits",
		"_radiusLimits",
		"_duration",
		"_repositioning",
		"_pylons",
		"_infiniteAmmo",
		"_friendlyRange",
		"_targetTypes",
		"_vehicleInit",
		"_remoteControl",
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
		_altitudeLimits,
		_radiusLimits,
		parseNumber _duration,
		_repositioning,
		_pylons call EFUNC(common,parseArray),
		_infiniteAmmo,
		parseNumber _friendlyRange,
		_targetTypes,
		_vehicleInit,
		_remoteControl,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addLoiter);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
}] call EFUNC(sdf,dialog);
