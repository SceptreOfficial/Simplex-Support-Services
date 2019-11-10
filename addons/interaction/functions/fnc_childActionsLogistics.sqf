#include "script_component.hpp"

params ["_target","_player"];

private _actions = [];

{
	private _action = switch (_x getVariable "SSS_supportType") do {
		case "logisticsAirdrop" : {
			["SSS_logistics:" + str _forEachIndex,_x getVariable "SSS_callsign","",{},{SSS_showLogisticsAirdrops},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (_entity getVariable "SSS_cooldown" > 0) then {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{NOTIFY_LOCAL_NOT_READY_COOLDOWN(_this # 2)}];
				} else {
					_actionData set [2,_entity getVariable "SSS_icon"];
					_actionData set [3,{_this call FUNC(selectPosition)}];
				};
			}] call ace_interact_menu_fnc_createAction
		};

		case "logisticsStation" : {
			["SSS_logistics:" + str _forEachIndex,_x getVariable "SSS_callsign",_x getVariable "SSS_icon",{_this call EFUNC(support,requestLogisticsStation)},{SSS_showLogisticsStations},{},_x,ACTION_DEFAULTS] call ace_interact_menu_fnc_createAction
		};
	};

	_actions pushBack [_action,[],_target];
} forEach ([[_target,"logistics"] call FUNC(availableEntities),true,{_this getVariable "SSS_callsign"}] call EFUNC(common,sortBy));

_actions
