#include "script_component.hpp"

params ["_selection"];

private _vehicles = (_selection param [0,[]]) select {
	alive _x &&
	alive driver _x &&
	_x isKindOf "AllVehicles" &&
	!(_x isKindOf "CAManBase")
};

if (_vehicles isEqualTo []) exitWith {
	ZEUS_MESSAGE("INVALID SELECTION");
};

private _side = side group (_vehicles # 0);

[LLSTRING(ModuleAddHelicopter_name),[
	["COMBOBOX",EDESC(common,side),[[
		[LELSTRING(common,SideWest),"",ICON_WEST],
		[LELSTRING(common,SideEast),"",ICON_EAST],
		[LELSTRING(common,SideGuer),"",ICON_GUER]
	],_side,[west,east,independent]]],
	["EDITBOX",EDESC(common,callsign),""],
	["EDITBOX",EDESC(common,respawnDelay),60],
	["TOOLBOX",EDESC(common,relocation),[[LELSTRING(common,allow),LELSTRING(common,deny)],0,[true,false]]],
	["EDITBOX",EDESC(common,relocationDelay),60],
	["LISTNBOXCB",DESC(taskTypes),[HELO_TASK_TYPES apply {GVAR(taskNames) get _x},true,5,HELO_TASK_TYPES]],
	["ARRAY",DESC(altitudeLimits),[[LELSTRING(common,Min),LELSTRING(common,Max)],[0,3000]]],
	["EDITBOX",DESC(maxTasks),-1],
	["EDITBOX",DESC(maxTimeout),300],
	["EDITBOX",EDESC(common,vehicleInit),""],
	["TOOLBOX",DESC(remoteControl),[[LELSTRING(common,allow),LELSTRING(common,deny)],1,[true,false]]],
	["CHECKBOX",EDESC(common,remoteAccess),true],
	["EDITBOX",EDESC(common,accessItems),""],
	["TOOLBOX",EDESC(common,accessItemsLogic),[[LELSTRING(common,LogicAND),LELSTRING(common,LogicOR)],0,[false,true]]],
	["EDITBOX",EDESC(common,accessCondition),"true"],
	["EDITBOX",EDESC(common,requestCondition),"true"]
],{
	params ["_values","_vehicles"];
	_values params [
		"_side",
		"_callsign",
		"_respawnDelay",
		"_allowRelocation",
		"_relocationDelay",
		"_taskTypes",
		"_altitudeLimits",
		"_maxTasks",
		"_maxTimeout",
		"_vehicleInit",
		"_remoteControl",
		"_remoteAccess",
		"_accessItems",
		"_accessItemsLogic",
		"_accessCondition",
		"_requestCondition",
		"_authorizations"
	];

	{
		[
			_x,
			_side,
			_callsign,
			parseNumber _respawnDelay,
			[_allowRelocation,parseNumber _relocationDelay],
			_taskTypes,
			_altitudeLimits,
			parseNumber _maxTasks,
			parseNumber _maxTimeout,
			_vehicleInit,
			_remoteControl,
			_remoteAccess,
			_accessItems call EFUNC(common,parseList),
			_accessItemsLogic,
			_accessCondition,
			_requestCondition
		] call FUNC(addHelicopter);
	} forEach _vehicles;

	ZEUS_MESSAGE(LELSTRING(common,SupportAdded));
},_vehicles] call EFUNC(sdf,dialog);
