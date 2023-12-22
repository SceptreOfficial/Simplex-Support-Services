#include "script_component.hpp"

if (isServer) then {
	[QGVAR(hideObjectGlobal),{
		params ["_object","_state"];
		_object hideObjectGlobal _state;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(enableSimulationGlobal),{
		params ["_object","_state"];
		_object enableSimulationGlobal _state;
	}] call CBA_fnc_addEventHandler;
};

[QGVAR(addEventHandler),{call CBA_fnc_addBISEventHandler}] call CBA_fnc_addEventHandler;

[QGVAR(allowDamage),{
	params ["_object","_state"];
	_object allowDamage _state;
}] call CBA_fnc_addEventHandler;

[QGVAR(limitSpeed),{
	params ["_object","_kmh"];
	
	if (_kmh <= 0) then {
		_object limitSpeed 99999999;
		_object forceSpeed -1;
	} else {
		_object limitSpeed _kmh;
		_object forceSpeed (_kmh / 3.6);
	};
}] call CBA_fnc_addEventHandler;

[QGVAR(setCombatMode),{
	params ["_groupOrUnit","_mode"];
	_groupOrUnit setCombatMode _mode;
}] call CBA_fnc_addEventHandler;

[QGVAR(enableAttack),{
	params ["_group","_state"];
	_group enableAttack _state;
}] call CBA_fnc_addEventHandler;

[QGVAR(enableAIFeature),{
	params ["_unit","_args"];

	if (_unit isKindOf "CAManBase") then {
		_unit enableAIFeature _args;
	} else {
		{[QEGVAR(common,enableAIFeature),[_x,_args],_x] call CBA_fnc_targetEvent} forEach PRIMARY_CREW(_unit);
	};
}] call CBA_fnc_addEventHandler;

[QGVAR(setPilotLight),{
	params ["_object","_state"];
	_object setPilotLight _state;
}] call CBA_fnc_addEventHandler;

[QGVAR(setCollisionLight),{
	params ["_object","_state"];
	_object setCollisionLight _state;
}] call CBA_fnc_addEventHandler;

[QGVAR(flyInHeight),{
	params ["_vehicle","_height"];
	_vehicle flyInHeight _height;
}] call CBA_fnc_addEventHandler;

[QGVAR(flyInHeightASL),{
	params ["_vehicle","_height"];
	_vehicle flyInHeightASL [_height,_height,_height];
}] call CBA_fnc_addEventHandler;

[QGVAR(deleteGroupWhenEmpty),{
	params ["_group","_state"];
	_group deleteGroupWhenEmpty _state;
}] call CBA_fnc_addEventHandler;

[QGVAR(orderGetIn),{
	params ["_units","_order"];
	_units orderGetIn _order;
}] call CBA_fnc_addEventHandler;

[QGVAR(leaveVehicle),{
	params ["_group","_vehicle"];
	_group leaveVehicle _vehicle;
}] call CBA_fnc_addEventHandler;

[QGVAR(setBehaviour),{
	params ["_group","_behaviour"];
	_group setBehaviour _behaviour;
	_group setBehaviourStrong _behaviour;
}] call CBA_fnc_addEventHandler;

[QGVAR(setSpeaker),{
	params ["_unit","_voice"];
	_unit setSpeaker _voice;
}] call CBA_fnc_addEventHandler;

[QGVAR(setFormation),{
	params ["_group","_formation"];
	if (_formation == "NO CHANGE") exitWith {};
	_group setFormation _formation;
}] call CBA_fnc_addEventHandler;

[QGVAR(unassignVehicle),{
	params ["_unit"];
	unassignVehicle _unit;
}] call CBA_fnc_addEventHandler;

[QGVAR(setFuel),{
	params ["_vehicle","_amount"];
	_vehicle setFuel _amount;
}] call CBA_fnc_addEventHandler;

[QGVAR(enableDynamicSimulation),{
	params ["_object","_enable"];
	_object enableDynamicSimulation _enable;
}] call CBA_fnc_addEventHandler;

[QGVAR(setAmmo),{
	params ["_unit","_args"];
	_args params ["_weapon","_count"];
	if (_weapon isEqualTo "") then {_weapon = currentMuzzle gunner _unit};
	_unit setAmmo [_weapon,_count];
}] call CBA_fnc_addEventHandler;
