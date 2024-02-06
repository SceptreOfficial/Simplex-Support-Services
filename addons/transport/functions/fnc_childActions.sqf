#include "..\script_component.hpp"

params ["_target","_player"];

([_player,QSERVICE] call EFUNC(common,getEntities)) apply {
	[[
		_x getVariable QPVAR(uid),
		_x getVariable QPVAR(callsign),
		_x getVariable QPVAR(icon),
		{[QSERVICE,_this # 2] call EFUNC(common,openGUI)},
		{true},
		{},
		_x,
		nil,
		nil,
		nil,
		{
			params ["_target","_player","_entity","_actionData"];

			if (!alive (_entity getVariable QPVAR(vehicle)) || _entity getVariable QPVAR(busy)) then {
				_actionData set [2,[_entity getVariable QPVAR(icon),HEX_YELLOW]];
			} else {
				_actionData set [2,_entity getVariable QPVAR(icon)];
			};
		}
	] call ace_interact_menu_fnc_createAction,[],_target]
}
