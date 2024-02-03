#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(addPostponedTasks),_this] call CBA_fnc_directCall};
if (!isServer) exitWith {[QEGVAR(common,execute),[_this,QFUNC(addPostponedTasks)]] call CBA_fnc_serverEvent};

params ["_entity"];

private _postponeIndex = _entity getVariable [QPVAR(postponeIndex),-1];

if (_postponeIndex < 0) exitWith {};

_entity setVariable [QPVAR(postponeIndex),nil,true];

private _request = _entity getVariable [QPVAR(request),[]];
private _plan = _request select [_postponeIndex,count _request];

[FUNC(addTasks),[_entity,_plan,0,false],3] call CBA_fnc_waitAndExecute;
