#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(changeBehavior),_this] call CBA_fnc_directCall};

params ["_entity","_behaviors"];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

{
	_x params ["_type","_value"];

	if (isNil "_value") then {continue};

	switch (tolower _type) do {
		case "speed" : {_entity setVariable [QPVAR(speed),_value,true]};
		case "combatmode" : {_entity setVariable [QPVAR(combatMode),_value,true]};
		case "lights" : {_entity setVariable [QPVAR(lights),_value,true]};
		case "collisionlights" : {_entity setVariable [QPVAR(collisionLights),_value,true]};
		case "altitudeatl" : {_entity setVariable [QPVAR(altitudeATL),_value,true]};
		case "altitudeasl" : {_entity setVariable [QPVAR(altitudeASL),_value,true]};
	};
} forEach _behaviors;

if (_vehicle isKindOf "Air") then {
	[QEGVAR(common,setBehaviour),[_vehicle,"CARELESS"],_vehicle] call CBA_fnc_targetEvent;
};

[QEGVAR(common,limitSpeed),[_vehicle,_entity getVariable [QPVAR(speed),-1]],_vehicle] call CBA_fnc_targetEvent;

[QEGVAR(common,setCombatMode),[_vehicle,_entity getVariable [QPVAR(combatMode),"YELLOW"]],_vehicle] call CBA_fnc_targetEvent;
private _canTarget = _entity getVariable [QPVAR(combatMode),"YELLOW"] != "BLUE";
[QEGVAR(common,enableAttack),[group _vehicle,_canTarget],group _vehicle] call CBA_fnc_targetEvent;
[QEGVAR(common,enableAIFeature),[_vehicle,["TARGET",_canTarget]],_vehicle] call CBA_fnc_targetEvent;
[QEGVAR(common,enableAIFeature),[_vehicle,["AUTOTARGET",_canTarget]],_vehicle] call CBA_fnc_targetEvent;

[QEGVAR(common,setPilotLight),[_vehicle,_entity getVariable [QPVAR(lights),true]],_vehicle] call CBA_fnc_targetEvent;

[QEGVAR(common,setCollisionLight),[_vehicle,_entity getVariable [QPVAR(collisionLights),true]],_vehicle] call CBA_fnc_targetEvent;

[QEGVAR(common,flyInHeight),[_vehicle,_entity getVariable [QPVAR(altitudeATL),100]],_vehicle] call CBA_fnc_targetEvent;

[QEGVAR(common,flyInHeightASL),[_vehicle,_entity getVariable [QPVAR(altitudeASL),100]],_vehicle] call CBA_fnc_targetEvent;
