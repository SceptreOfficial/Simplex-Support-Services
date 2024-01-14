#include "script_component.hpp"

params ["_entity","_vehicle"];

if (!local _vehicle || _entity getVariable QPVAR(service) != QSERVICE) exitWith {};

//if (_entity getVariable [QPVAR(supportType),""] == "BOMBING") exitWith {
//	private _vehicles = _entity getVariable [QPVAR(vehicles),[]];
//	_entity setVariable [QPVAR(vehicles),_vehicles + [_vehicle],true];
//};

_entity setVariable [QPVAR(vehicle),_vehicle,true];	

[
	[QEGVAR(common,addEventHandler),[_vehicle,"Deleted",{call FUNC(deleted)}]] call CBA_fnc_globalEventJIP,
	_vehicle
] call CBA_fnc_removeGlobalEventJIP;

[
	[QEGVAR(common,addEventHandler),[_vehicle,"Killed",{call FUNC(killed)}]] call CBA_fnc_globalEventJIP,
	_vehicle
] call CBA_fnc_removeGlobalEventJIP;

[{
	params ["_vehicle","_PFHID"];
	if (!alive _vehicle) exitWith {_PFHID call CBA_fnc_removePerFrameHandler};
	if (isTouchingGround _vehicle && {!canMove _vehicle}) then {_vehicle call FUNC(killed)};
},10,_vehicle] call CBA_fnc_addPerFrameHandler;
