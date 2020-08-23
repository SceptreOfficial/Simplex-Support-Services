#include "script_component.hpp"

params ["_target","_player"];

private _actions = [];

{
	private _action = ["SSS_artillery:" + str _forEachIndex,_x getVariable "SSS_callsign","",{},{true},{},_x,ACTION_DEFAULTS,{
		params ["_target","_player","_entity","_actionData"];

		if (alive (_entity getVariable "SSS_vehicle")) then {
			if (_entity getVariable "SSS_cooldown" > 0) then {
				_actionData set [2,_entity getVariable "SSS_iconYellow"];
				_actionData set [3,{NOTIFY_LOCAL_NOT_READY_COOLDOWN(_this # 2)}];
				_actionData set [5,{}];
			} else {
				_actionData set [2,_entity getVariable "SSS_icon"];
				_actionData set [3,{}];
				_actionData set [5,{
					params ["_target","_player","_entity"];

					private _vehicle = _entity getVariable "SSS_vehicle";
					private _cfgMagazines = configFile >> "CfgMagazines";
					private _actions = [];
					private _magazines = if (_vehicle isKindOf "B_Ship_MRLS_01_base_F") then {
						["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18"]
					} else {
						getArtilleryAmmo [_vehicle]
					};

					{
						private _magazineName = getText (_cfgMagazines >> _x >> "displayName");
						private _action = ["SSS_artillery:" + str _entity + str _x,_magazineName,"",{
							_this call FUNC(selectPosition);
						},{true},{},[_entity,_x]] call ace_interact_menu_fnc_createAction;

						_actions pushBack [_action,[],_target];
					} forEach _magazines;

					_actions
				}];
			};
		} else {
			_actionData set [2,_entity getVariable "SSS_iconYellow"];
			_actionData set [3,{
				NOTIFY_LOCAL(_this # 2,localize LSTRING(VehicleUnderReplacement));
			}];
			_actionData set [5,{}];
		};
	}] call ace_interact_menu_fnc_createAction;

	_actions pushBack [_action,[],_target];
} forEach ([[_target,"artillery"] call FUNC(availableEntities),true,{_this getVariable "SSS_callsign"}] call EFUNC(common,sortBy));

_actions
