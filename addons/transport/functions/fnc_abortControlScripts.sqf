#include "script_component.hpp"

params ["_vehicle",["_abortFiring",false]];

if (_vehicle isKindOf "Helicopter") then {
	[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);
	_vehicle setVariable [QPVAR(fastropeCancel),true,true];
};

if (_vehicle isKindOf "Air") then {
	[_vehicle,[0,0,0]] call EFUNC(common,strafe);
};

if (_abortFiring && {_vehicle getVariable [QEGVAR(common,firing),false]}) then {
	[_vehicle,[0,0,0]] call EFUNC(common,fireAtTarget);
};
