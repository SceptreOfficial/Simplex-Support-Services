#include "script_component.hpp"

[QPVAR(vehicleCommissioned),{call FUNC(commission)}] call CBA_fnc_addEventHandler;

{[_x,FUNC(gui_verify)] call CBA_fnc_addEventHandler} forEach [
	QPVAR(requestSubmitted),
	QPVAR(requestCompleted),
	QPVAR(requestAborted),
	QPVAR(cooldownStarted),
	QPVAR(cooldownCompleted)
];
