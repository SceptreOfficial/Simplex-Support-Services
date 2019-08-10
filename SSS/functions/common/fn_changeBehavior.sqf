#include "script_component.hpp"

params ["_values","_vehicle"];

if (!alive _vehicle) exitWith {};

switch (_vehicle getVariable "SSS_service") do {
	case "CASHeli" : {
		_values params ["_flyingHeight"];

		_vehicle setVariable ["SSS_flyingHeight",_flyingHeight,true];
		_vehicle flyInHeight _flyingHeight;
	};
	case "transport" : {
		_values params ["_flyingHeight","_speedMode","_combatMode"];

		_vehicle setVariable ["SSS_flyingHeight",_flyingHeight,true];
		_vehicle setVariable ["SSS_speedMode",_speedMode,true];
		_vehicle setVariable ["SSS_combatMode",_combatMode,true];
		_vehicle flyInHeight _flyingHeight;
		private _group = group _vehicle;
		_group setSpeedMode (["LIMITED","NORMAL","FULL"] # _speedMode);
		if (_combatMode isEqualTo 0) then {
			_group setCombatMode "YELLOW";
			_group enableAttack true;
			{_x enableAI "TARGET"; _x enableAI "AUTOTARGET";} forEach units _group;
		} else {
			_group setCombatMode "BLUE";
			_group enableAttack false;
			{_x disableAI "TARGET"; _x disableAI "AUTOTARGET";} forEach units _group;
		};
	};
};
