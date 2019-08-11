#include "script_component.hpp"

// Transport vehicle actions
["SSS_supportVehicleAdded",{
	params ["_vehicle"];

	if (!alive _vehicle || {(_vehicle getVariable "SSS_service") != "transport"}) exitWith {};

	private _transportAction = ["SSS_transport","Transport",ICON_TRANSPORT,{},{
		alive (_this # 0) && alive driver (_this # 0)
	},{
		_this call SSS_fnc_childActionsTransport;
	},_vehicle] call ace_interact_menu_fnc_createAction;

	[_vehicle,1,["ACE_SelfActions"],_transportAction] call ace_interact_menu_fnc_addActionToObject;
	[_vehicle,0,["ACE_MainActions"],_transportAction] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;
["SSS_supportVehicleRemoved",{
	params ["_vehicle"];

	if (isNull _vehicle) exitWith {};

	[_vehicle,1,["ACE_SelfActions","SSS_transport"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_vehicle,0,["ACE_MainActions","SSS_transport"]] call ace_interact_menu_fnc_removeActionFromObject;
}] call CBA_fnc_addEventHandler;

if (!hasInterface) exitWith {};

//-----------------------------------------------------------------------------------------------//
// Parent action
private _mainAction = ["SSS_main","Support Services",ICON_SUPPORT_SERVICES,{},{true}] call ace_interact_menu_fnc_createAction;
[player,1,["ACE_SelfActions"],_mainAction] call ace_interact_menu_fnc_addActionToObject;

// Transport action
private _action1 = ["SSS_transport","Transport",ICON_TRANSPORT,{},{
	SSS_transportEnabled && {
	!((missionNamespace getVariable [format ["SSS_transport_%1",side player],[]]) isEqualTo [])
}},{
	private _actions = [];
	{
		if (alive _x) then {
			private _action = [format ["SSS_transport:%1",_x],_x getVariable "SSS_displayName",ICON_HELI,{},{true},{
				_this call SSS_fnc_childActionsTransport;
			},_x] call ace_interact_menu_fnc_createAction;
			_actions pushBack [_action,[],player];
		};
	} forEach (missionNamespace getVariable [format ["SSS_transport_%1",side player],[]]);
	_actions
}] call ace_interact_menu_fnc_createAction;
[player,1,["ACE_SelfActions","SSS_main"],_action1] call ace_interact_menu_fnc_addActionToObject;

// CAS action
private _action2 = ["SSS_CAS","CAS",ICON_CAS,{},{
	SSS_CASEnabled && {
	!((missionNamespace getVariable [format ["SSS_CASHelis_%1",side player],[]]) isEqualTo []) ||
	!((missionNamespace getVariable [format ["SSS_CASPlanes_%1",side player],[]]) isEqualTo []) ||
	!((missionNamespace getVariable [format ["SSS_CASDrones_%1",side player],[]]) isEqualTo []) ||
	!((missionNamespace getVariable [format ["SSS_CASGunships_%1",side player],[]]) isEqualTo [])
}},{
	private _actions = [];
	// CAS Helis
	{
		if (alive _x) then {
			private _action = [format ["SSS_CAS:%1",_x],_x getVariable "SSS_displayName",ICON_HELI,{},{SSS_CASHelisEnabled},{
				_this call SSS_fnc_childActionsCASHeli
			},_x] call ace_interact_menu_fnc_createAction;
			_actions pushBack [_action,[],player];
		};
	} forEach (missionNamespace getVariable [format ["SSS_CASHelis_%1",side player],[]]);
	// CAS Drones
	{
		if (alive _x) then {
			private _action = [format ["SSS_CAS:%1",_x],_x getVariable "SSS_displayName",ICON_DRONE,{},{SSS_CASDronesEnabled},{},_x,[0,0,0],4,[false,false,false,false,false],{
				params ["_target","_player","_entity","_actionData"];
				if (_entity getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,ICON_DRONE_YELLOW];
					_actionData set [3,{NOTIFY_LOCAL_1(_this # 2,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_this # 2))}];
				} else {
					if (_entity getVariable "SSS_activeInArea") then {
						_actionData set [2,ICON_DRONE_GREEN];
						_actionData set [3,{NOTIFY_LOCAL(_this # 2,"Connect via UAV Terminal")}];
					} else {
						_actionData set [2,ICON_DRONE];
						_actionData set [3,{[_this # 2,0] call SSS_fnc_selectMapPosition;}];
					};
				};
			}] call ace_interact_menu_fnc_createAction;
			_actions pushBack [_action,[],player];
		};
	} forEach (missionNamespace getVariable [format ["SSS_CASDrones_%1",side player],[]]);
	// CAS Gunships
	{
		if (alive _x) then {
			private _action = [format ["SSS_CAS:%1",_x],_x getVariable "SSS_displayName",ICON_GUNSHIP,{
				// 'Toggle ROE (Current: Search & Destroy)'
			},{SSS_CASGunshipsEnabled},{},_x,[0,0,0],4,[false,false,false,false,false],{
				params ["_target","_player","_entity","_actionData"];
				if (_entity getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,ICON_GUNSHIP_YELLOW];
					_actionData set [3,{NOTIFY_LOCAL_1(_this # 2,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_this # 2))}];
				} else {
					if (_entity getVariable "SSS_activeInArea") then {
						_actionData set [2,ICON_GUNSHIP_GREEN];
						_actionData set [3,{[_this # 2] call SSS_fnc_CASGunshipControl;}];
					} else {
						_actionData set [2,ICON_GUNSHIP];
						_actionData set [3,{[_this # 2,0] call SSS_fnc_selectMapPosition;}];
					};
				};
			}] call ace_interact_menu_fnc_createAction;
			_actions pushBack [_action,[],player];
		};
	} forEach (missionNamespace getVariable [format ["SSS_CASGunships_%1",side player],[]]);
	// CAS Planes
	{
		if (alive _x) then {
			private _action = [format ["SSS_CAS:%1",_x],_x getVariable "SSS_displayName",ICON_PLANE,{},{SSS_CASPlanesEnabled},{},_x,[0,0,0],4,[false,false,false,false,false],{
				params ["_target","_player","_entity","_actionData"];
				if (_entity getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,ICON_PLANE_YELLOW];
					_actionData set [3,{NOTIFY_LOCAL_1(_this # 2,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_this # 2))}];
					_actionData set [5,{}];
				} else {
					_actionData set [2,ICON_PLANE];
					_actionData set [3,{}];
					_actionData set [5,{_this call SSS_fnc_childActionsCASPlane}];
				};
			}] call ace_interact_menu_fnc_createAction;
			_actions pushBack [_action,[],player];
		};
	} forEach (missionNamespace getVariable [format ["SSS_CASPlanes_%1",side player],[]]);
	_actions
}] call ace_interact_menu_fnc_createAction;
[player,1,["ACE_SelfActions","SSS_main"],_action2] call ace_interact_menu_fnc_addActionToObject;

// Artillery action
private _action3 = ["SSS_artillery","Artillery",ICON_ARTILLERY,{},{
	SSS_artilleryEnabled && {
	!((missionNamespace getVariable [format ["SSS_artillery_%1",side player],[]]) isEqualTo [])
}},{
	private _actions = [];
	{
		if (alive _x) then {
			private _action = [format ["SSS_artillery:%1",_x],_x getVariable "SSS_displayName","",{},{true},{},_x,[0,0,0],4,[false,false,false,false,false],{
				params ["_target","_player","_vehicle","_actionData"];
				if (_vehicle getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,[ICON_SELF_PROPELLED_YELLOW,ICON_MORTAR_YELLOW] select (_vehicle isKindOf "StaticWeapon")];
					_actionData set [3,{NOTIFY_LOCAL_1(_this # 2,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_this # 2))}];
					_actionData set [5,{}];
				} else {
					_actionData set [2,[ICON_SELF_PROPELLED,ICON_MORTAR] select (_vehicle isKindOf "StaticWeapon")];
					_actionData set [3,{}];
					_actionData set [5,{_this call SSS_fnc_childActionsArtillery}];
				};
			}] call ace_interact_menu_fnc_createAction;
			_actions pushBack [_action,[],player];
		};
	} forEach (missionNamespace getVariable [format ["SSS_artillery_%1",side player],[]]);
	_actions
}] call ace_interact_menu_fnc_createAction;
[player,1,["ACE_SelfActions","SSS_main"],_action3] call ace_interact_menu_fnc_addActionToObject;

//-----------------------------------------------------------------------------------------------//

SSS_postInitDone = true;
