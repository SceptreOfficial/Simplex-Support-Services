#include "script_component.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"

[] call FUNC(getMapGridData);

if (hasInterface) then {
	["loadout",{
		params ["_unit"];
		_unit setVariable [QGVAR(uniqueItems),uniqueUnitItems _unit apply {toLower _x}];
	},true] call CBA_fnc_addPlayerEventHandler;
};

[LELSTRING(main,sss),QPVAR(openGUI),"Open GUI",{
	[] call FUNC(openGUI);
	true
},{false},[DIK_Y,[false,true,false]]] call CBA_fnc_addKeybind;

PVAR(terminalEntity) = objNull;
GVAR(guiService) = "";
GVAR(guiCache) = createHashMap;
GVAR(manageService) = "";
GVAR(manageCache) = createHashMap;

// Create ACE actions
["CAManBase",1,["ACE_SelfActions"],[
	QUOTE(PREFIX),
	LELSTRING(main,sss),
	ICON_SSS,
	{[] call FUNC(openGUI)},
	{(_this # 1) call FUNC(entitiesAvailable)}
] call ace_interact_menu_fnc_createAction,true] call ace_interact_menu_fnc_addActionToClass;

private _serviceData = configProperties [configFile >> QPVAR(services),"isClass _x"] apply {[
	getText (_x >> "name"),
	getText (_x >> "icon"),
	getText (_x >> "childActions"),
	toUpper configName _x
]};

_serviceData sort true;

{
	_x params ["_name","_icon","_childActions","_service"];

	["CAManBase",1,["ACE_SelfActions",QUOTE(PREFIX)],[
		format ["%1_%2",PREFIX,_service],
		_name,
		_icon,
		{[_this # 2 # 0] call FUNC(openGUI)},
		{[_this # 1,_this # 2 # 0] call FUNC(getEntities) isNotEqualTo []},
		{_this call (missionNamespace getVariable (_this # 2 # 1))},
		[_service,_childActions]
	] call ace_interact_menu_fnc_createAction,true] call ace_interact_menu_fnc_addActionToClass;
} forEach _serviceData;

//if (hasInterface) then {
//	player addEventHandler ["Respawn",{
//		player remoteControl objNull;
//	}];
//};

//if (isServer) then {
//	[{
//		{
//			private _vehicle = _x getVariable [QPVAR(vehicle),objNull];
//			private _group = _x getVariable [QPVAR(group),grpNull];
//			diag_log text str ["SSS: Owner debug:",["Vehicle:",_vehicle,owner _vehicle],["Vehicle group:",group _vehicle,groupOwner group _vehicle],["Entity group:",_group,groupOwner _group]];
//		} forEach (GVAR(services) getOrDefault ["TRANSPORT",[]]);
//	},5] call CBA_fnc_addPerFrameHandler;
//};
