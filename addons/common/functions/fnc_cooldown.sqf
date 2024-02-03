#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(cooldown),_this] call CBA_fnc_directCall};
if (!isServer) exitWith {[QGVAR(execute),[_this,QFUNC(cooldown)]] call CBA_fnc_serverEvent};

params [["_entity",objNull],["_defaultCooldown",true,[false]]];

_entity = _entity getVariable [QPVAR(entity),_entity];

if (isNull _entity || _entity getVariable [QPVAR(coolingDown),false]) exitWith {};

private _cooldown = if (_defaultCooldown) then {
	private _cooldown = _entity getVariable [QPVAR(cooldown),0];
	_entity setVariable [QPVAR(cooldownTimer),_cooldown];
	_cooldown
} else {
	_entity getVariable [QPVAR(cooldownTimer),0];
};

if (_cooldown > 0) then {
	[_entity,true,"COOLDOWN",[LSTRING(statusCooldown),RGBA_YELLOW]] call FUNC(setStatus);
};

if (_cooldown <= 0) exitWith {
	_entity setVariable [QPVAR(cooldownTimer),0,true];
	[_entity] call EFUNC(common,setStatus);
};

_entity setVariable [QPVAR(coolingDown),true];

[QPVAR(cooldownStarted),[_entity]] call CBA_fnc_globalEvent;
DEBUG_2("%1: Cooldown started (%2s)",_entity getVariable QPVAR(callsign),_cooldown);

[{
	params ["_args","_PFHID"];
	_args params ["_entity","_cooldown"];

	if (isNull _entity) exitWith {
		_PFHID call CBA_fnc_removePerFrameHandler;
	};

	private _time = _entity getVariable [QPVAR(cooldownTimer),0];

	if (_cooldown - _time >= _cooldown) then {
		_PFHID call CBA_fnc_removePerFrameHandler;
		
		_entity setVariable [QPVAR(coolingDown),nil];
		[_entity] call FUNC(setStatus);

		[QPVAR(cooldownCompleted),[_entity]] call CBA_fnc_globalEvent;
		DEBUG_1("%1: Cooldown completed",_entity getVariable QPVAR(callsign));
	} else {
		_entity setVariable [QPVAR(cooldownTimer),_time - 1,true];
	};
},1,[_entity,_cooldown]] call CBA_fnc_addPerFrameHandler;
