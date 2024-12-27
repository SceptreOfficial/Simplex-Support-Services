#include "..\script_component.hpp"

if (!isServer) exitWith {
	[QGVAR(execute),[_this,QFUNC(removeEntity)]] call CBA_fnc_serverEvent;
};

params [["_entity",objNull,[objNull]]];

if (!isNull (_entity getVariable [QPVAR(entity),objNull])) then {
	_entity = _entity getVariable QPVAR(entity);
};

deleteMarker (_entity getVariable [QPVAR(marker),""]);

private _service = _entity getVariable QPVAR(service);

if (isNil "_service") exitWith {
	DEBUG_1("Unable to remove entity (no service defined): %1",_entity);
};

_entity setVariable [QPVAR(respawnDelay),-1,true];

GVAR(services) set [_service,(GVAR(services) get _service) - [_entity,objNull]];
publicVariable QGVAR(services);

private _group = _entity getVariable [QPVAR(group),grpNull];

if (!isNull _group) then {
	[QGVAR(deleteGroupWhenEmpty),[_group,true],_group] call CBA_fnc_targetEvent;
};

private _vehicles = _entity getVariable [QPVAR(vehicles),[]];

if (OPTION(deleteVehicleOnEntityRemoval)) then {
	{
		deleteVehicleCrew _x;
		deleteVehicle _x;
	} forEach _vehicles;
} else {
	{
		_x call FUNC(decommission);
		private _group = group _x;
		_group setCombatMode "YELLOW";
		_group enableAttack true;
	} forEach _vehicles;
};

[QPVAR(supportRemoved),[
	_entity getVariable QPVAR(service),
	_entity getVariable QPVAR(supportType),
	_entity getVariable QPVAR(callsign),
	_entity getVariable QPVAR(uid)
]] call CBA_fnc_globalEvent;

DEBUG_2("Entity removed: %1 (%2)",_entity,_entity getVariable QPVAR(callsign));

deleteVehicle _entity;
