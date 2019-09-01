#include "script_component.hpp"
#define SERVICE_ARRAY(SERVICE) (missionNamespace getVariable [format ["SSS_%1_%2",SERVICE,side player],[]])

if (isServer) then {
	["SAA_addWaypoint",{_this call EFUNC(common,addWaypoint)}] call CBA_fnc_addEventHandler;
};

if (!hasInterface) exitWith {};

// Parent action
[player,1,["ACE_SelfActions"],
	["SSS_main","Support Services",ICON_SUPPORT_SERVICES,{},{true}] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToObject;

// Artillery action
[player,1,["ACE_SelfActions","SSS_main"],
	["SSS_artillery","Artillery",ICON_ARTILLERY,{},{
		SSS_artilleryEnabled && {
		!(SERVICE_ARRAY("artillery") isEqualTo [])
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
						_actionData set [5,{_this call EFUNC(service,childActionsArtillery)}];
					};
				}] call ace_interact_menu_fnc_createAction;

				_actions pushBack [_action,[],player];
			};
		} forEach SERVICE_ARRAY("artillery");

		_actions
	}] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToObject;

// CAS action
[player,1,["ACE_SelfActions","SSS_main"],
	["SSS_CAS","CAS",ICON_CAS,{},{
		SSS_CASEnabled && {
		!(SERVICE_ARRAY("CASHelis") isEqualTo []) ||
		!(SERVICE_ARRAY("CASPlanes") isEqualTo []) ||
		!(SERVICE_ARRAY("CASDrones") isEqualTo []) ||
		!(SERVICE_ARRAY("CASGunships") isEqualTo [])
	}},{
		private _actions = [];

		// CAS Helis
		{
			if (alive _x) then {
				private _action = [format ["SSS_CAS:%1",_x],_x getVariable "SSS_displayName",ICON_HELI,{},{SSS_CASHelisEnabled},{
					_this call EFUNC(service,childActionsCASHeli)
				},_x] call ace_interact_menu_fnc_createAction;

				_actions pushBack [_action,[],player];
			};
		} forEach SERVICE_ARRAY("CASHelis");

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
							_actionData set [3,{[_this # 2,0] call EFUNC(common,selectMapPosition);}];
						};
					};
				}] call ace_interact_menu_fnc_createAction;

				_actions pushBack [_action,[],player];
			};
		} forEach SERVICE_ARRAY("CASDrones");

		// CAS Gunships
		{
			if (alive _x) then {
				private _action = [format ["SSS_CAS:%1",_x],_x getVariable "SSS_displayName",ICON_GUNSHIP,{},{SSS_CASGunshipsEnabled},{},_x,[0,0,0],4,[false,false,false,false,false],{
					params ["_target","_player","_entity","_actionData"];

					if (_entity getVariable "SSS_cooldown" > 0) then {
						_actionData set [2,ICON_GUNSHIP_YELLOW];
						_actionData set [3,{NOTIFY_LOCAL_1(_this # 2,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_this # 2))}];
					} else {
						if (_entity getVariable "SSS_activeInArea") then {
							_actionData set [2,ICON_GUNSHIP_GREEN];
							_actionData set [3,{[_this # 2] call EFUNC(service,CASGunshipControl);}];
						} else {
							_actionData set [2,ICON_GUNSHIP];
							_actionData set [3,{[_this # 2,0] call EFUNC(common,selectMapPosition);}];
						};
					};
				}] call ace_interact_menu_fnc_createAction;

				_actions pushBack [_action,[],player];
			};
		} forEach SERVICE_ARRAY("CASGunships");

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
						_actionData set [5,{_this call EFUNC(service,childActionsCASPlane)}];
					};
				}] call ace_interact_menu_fnc_createAction;

				_actions pushBack [_action,[],player];
			};
		} forEach SERVICE_ARRAY("CASPlanes");

		_actions
	}] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToObject;

// Transport action
[player,1,["ACE_SelfActions","SSS_main"],
	["SSS_transport","Transport",ICON_TRANSPORT,{},{
		SSS_transportEnabled && {
		!(SERVICE_ARRAY("transport") isEqualTo [])
	}},{
		private _actions = [];

		{
			if (alive _x) then {
				private _action = [format ["SSS_transport:%1",_x],_x getVariable "SSS_displayName",ICON_HELI,{},{true},{
					_this call EFUNC(service,childActionsTransport);
				},_x] call ace_interact_menu_fnc_createAction;

				_actions pushBack [_action,[],player];
			};
		} forEach SERVICE_ARRAY("transport");

		_actions
	}] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToObject;
