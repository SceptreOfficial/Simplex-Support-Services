#include "script_component.hpp"

params ["_vehicle"];

private _class = "";
private _pylons = [];
private _side = side group _vehicle;

if (_vehicle isKindOf "Air") then {
	_class = typeOf _vehicle;
	_pylons = [_vehicle,{_turret isNotEqualTo [-1]}] call EFUNC(common,getPylons);
};

[LLSTRING(moduleAddLoiter_name),[
	["EDITBOX",DESC(aircraftClass),_class],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,cooldown),60],
	["ARRAY",DESC(virtualRunway),[["X","Y","Z"],[0,0,0]]],
	["EDITBOX",DESC(spawnDistance),8000],
	["ARRAY",DESC(spawnDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["ARRAY",DESC(AltitudeLimits),[[LELSTRING(common,Min),LELSTRING(common,Max)],[500,3000]]],
	["ARRAY",DESC(RadiusLimits),[[LELSTRING(common,Min),LELSTRING(common,Max)],[300,2500]]],
	["EDITBOX",DESC(Duration),600],
	["TOOLBOX",DESC(Repositioning),[[LELSTRING(common,enable),LELSTRING(common,disable)],0,[true,false]]],
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
	],true,5,LOITER_TARGETS]],
	["EDITBOX",DESC(friendlyRange),50],
	["EDITBOX",EDESC(common,vehicleInit),""],
	["TOOLBOX",DESC(remoteControl),[[LELSTRING(common,enable),LELSTRING(common,disable)],0,[true,false]]],
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
		"_altitudeLimits",
		"_radiusLimits",
		"_duration",
		"_repositioning",
		"_pylons",
		"_infiniteAmmo",
		"_targetTypes",
		"_friendlyRange",
		"_vehicleInit",
		"_remoteControl",
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
		_altitudeLimits,
		_radiusLimits,
		parseNumber _duration,
		_repositioning,
		_pylons call EFUNC(common,parseArray),
		_infiniteAmmo,
		_targetTypes,
		parseNumber _friendlyRange,
		_vehicleInit,
		_remoteControl,
		_side,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(addLoiter);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
}] call EFUNC(sdf,dialog);
