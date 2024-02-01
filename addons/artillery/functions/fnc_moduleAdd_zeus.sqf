#include "script_component.hpp"

params ["_selection"];

private _battery = (_selection param [0,[]]) select {
	alive _x &&
	alive gunner _x &&
	_x isKindOf "AllVehicles" &&
	!(_x isKindOf "CAManBase")
};

if (_battery isEqualTo []) exitWith {
	ZEUS_MESSAGE(LELSTRING(common,zeusInvalidSelection));
};

private _side = side group (_battery # 0);

[localize LNAME(moduleAdd),[
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,respawnDelay),60],
	["TOOLBOX",EDESC(common,relocation),[[LELSTRING(common,allow),LELSTRING(common,deny)],0,[true,false]]],
	["EDITBOX",EDESC(common,relocationDelay),60],
	["EDITBOX",EDESC(common,relocationSpeed),60],
	["EDITBOX",EDESC(common,cooldown),60],
	["EDITBOX",DESC(roundCooldown),10],
	["EDITBOX",DESC(ammunition),"[]"],
	["TOOLBOX",DESC(velocityOverride),[[LLSTRING(Default),LLSTRING(Override)],0,[false,true]]],
	["EDITBOX",DESC(coordinationDistance),1000],
	["COMBOBOX",DESC(coordinationType),[[
		LLSTRING(CoordinationTypeSupport),
		LLSTRING(CoordinationTypeNonSupport),
		LLSTRING(CoordinationTypeAll)
	],2]],
	["COMBOBOX",DESC(iconSelection),[[
		[LLSTRING(Automatic),"",ICON_GEAR],
		[LLSTRING(Mortar),"",ICON_MORTAR],
		[LLSTRING(Howitzer),"",ICON_HOWITZER],
		[LLSTRING(SelfPropelled),"",ICON_SELF_PROPELLED],
		[LLSTRING(MRLS),"",ICON_MRLS],
		[LLSTRING(MRLSTruck),"",ICON_MRLS_TRUCK],
		[LLSTRING(Missile),"",ICON_MISSILE]
	],0,["",ICON_MORTAR,ICON_HOWITZER,ICON_SELF_PROPELLED,ICON_MRLS,ICON_MRLS_TRUCK,ICON_MISSILE]]],
	["ARRAY",DESC(executionDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["ARRAY",DESC(firingDelay),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,0]]],
	["LISTNBOXCB",DESC(sheafTypes),[[
		LLSTRING(Converged),
		LLSTRING(Parallel),
		LLSTRING(Box),
		LLSTRING(Creeping)
	],true,5,SHEAF_TYPES]],
	["EDITBOX",DESC(maxLoops),10],
	["EDITBOX",DESC(maxLoopDelay),300],
	["EDITBOX",DESC(maxTasks),-1],
	["EDITBOX",DESC(maxRounds),50],
	["EDITBOX",DESC(maxExecutionDelay),300],
	["EDITBOX",DESC(maxFiringDelay),30],
	["EDITBOX",EDESC(common,vehicleInit),""],
	["TOOLBOX",DESC(remoteControl),[[LELSTRING(common,allow),LELSTRING(common,deny)],1,[true,false]]],
	FINAL_ATTRIBUTES_ZEUS
],{
	params ["_values","_battery"];
	_values params [
		"_callsign",
		"_respawnDelay",
		"_allowRelocation",
		"_relocationDelay",
		"_relocationSpeed",
		"_cooldown",
		"_roundCooldown",
		"_ammunition",
		"_velocityOverride",
		"_coordinationDistance",
		"_coordinationType",
		"_icon",
		"_executionDelay",
		"_firingDelay",
		"_sheafTypes",
		"_maxLoops",
		"_maxLoopDelay",
		"_maxTasks",
		"_maxRounds",
		"_maxExecDelay",
		"_maxFiringDelay",
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
		_battery,
		_callsign,
		parseNumber _respawnDelay,
		[_allowRelocation,parseNumber _relocationDelay,parseNumber _relocationSpeed],
		[parseNumber _cooldown,parseNumber _roundCooldown],
		_ammunition call EFUNC(common,parseArray),
		_velocityOverride,
		parseNumber _coordinationDistance,
		_coordinationType,
		_icon,
		_executionDelay,
		_firingDelay,
		_sheafTypes,
		parseNumber _maxLoops,
		parseNumber _maxLoopDelay,
		parseNumber _maxTasks,
		parseNumber _maxRounds,
		parseNumber _maxExecDelay,
		parseNumber _maxFiringDelay,
		_vehicleInit,
		_remoteControl,
		_side,
		_remoteAccess,
		_accessItems call EFUNC(common,parseList),
		_accessItemsLogic,
		_accessCondition,
		_requestCondition
	] call FUNC(add);

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
},_battery] call EFUNC(sdf,dialog);
