#include "script_component.hpp"

params ["_target","_player"];

private _actions = [];

{
	private _action = switch (_x getVariable "SSS_supportType") do {
		case "CASDrone" : {
			["SSS_CAS:" + str _forEachIndex,_x getVariable "SSS_callsign","",{},{SSS_showCASDrones},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (_entity getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{NOTIFY_LOCAL_NOT_READY_COOLDOWN(_this # 2)}];
				} else {
					if (_entity getVariable "SSS_active") then {
						_actionData set [2,_entity getVariable "SSS_iconGreen"];
						_actionData set [3,{NOTIFY_LOCAL(_this # 2,localize LSTRING(ConnectViaUAVTerminal))}];
					} else {
						_actionData set [2,_entity getVariable "SSS_icon"];
						_actionData set [3,{_this call FUNC(selectPosition);}];
					};
				};
			}] call ace_interact_menu_fnc_createAction
		};

		case "CASGunship" : {
			["SSS_CAS:" + str _forEachIndex,_x getVariable "SSS_callsign","",{},{SSS_showCASGunships},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (_entity getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{NOTIFY_LOCAL_NOT_READY_COOLDOWN(_this # 2)}];
				} else {
					if (_entity getVariable "SSS_active") then {
						_actionData set [2,_entity getVariable "SSS_iconGreen"];
						_actionData set [3,{[_this # 2] call FUNC(CASGunshipControl);}];
					} else {
						_actionData set [2,_entity getVariable "SSS_icon"];
						_actionData set [3,{_this call FUNC(selectPosition);}];
					};
				};
			}] call ace_interact_menu_fnc_createAction
		};

		case "CASHelicopter" : {
			["SSS_CAS:" + str _forEachIndex,_x getVariable "SSS_callsign","",{},{SSS_showCASHelicopters},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (alive (_entity getVariable "SSS_vehicle")) then {
					_actionData set [2,[_entity getVariable "SSS_icon",_entity getVariable "SSS_iconGreen"] select (_entity getVariable "SSS_awayFromBase")];
					_actionData set [3,{}];
					_actionData set [5,{_this call FUNC(childActionsCASHelicopter)}];
				} else {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{
						NOTIFY_LOCAL(_this # 2,localize LSTRING(VehicleUnderReplacement));
					}];
					_actionData set [5,{}];
				};
			},_x] call ace_interact_menu_fnc_createAction
		};

		case "CASPlane" : {
			["SSS_CAS:" + str _forEachIndex,_x getVariable "SSS_callsign","",{},{SSS_showCASPlanes},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (_entity getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{NOTIFY_LOCAL_NOT_READY_COOLDOWN(_this # 2)}];
					_actionData set [5,{}];
				} else {
					_actionData set [2,_entity getVariable "SSS_icon"];
					_actionData set [3,{}];
					_actionData set [5,{
						params ["_target","_player","_entity"];

						private _cfgMagazines = configFile >> "CfgMagazines";
						private _actions = [];

						{
							private _magazineName = getText (_cfgMagazines >> _x # 1 >> "displayName");
							private _action = ["SSS_CAS:" + str _entity + str _x,_magazineName,"",{
								_this call FUNC(selectPosition);
							},{true},{},[_entity,_x]] call ace_interact_menu_fnc_createAction;

							_actions pushBack [_action,[],_target];
						} forEach (_entity getVariable "SSS_weapons");

						_actions
					}];
				};
			}] call ace_interact_menu_fnc_createAction
		};
	};

	_actions pushBack [_action,[],_target];
} forEach ([[_target,"CAS"] call FUNC(availableEntities),true,{_this getVariable "SSS_callsign"}] call EFUNC(common,sortBy));

_actions
