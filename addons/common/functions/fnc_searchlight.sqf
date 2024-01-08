#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(searchlight),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_unit",objNull,[objNull,[]]],
	["_target",objNull,[objNull,[]]],
	["_turnOn",true,[false]]
];

if (_unit isEqualType []) then {
	_unit = _vehicle turretUnit _unit;
};

if (!local _unit) exitWith {
	[QGVAR(execute),[[_vehicle,_unit,_target],FUNC(searchlight)],_unit] call CBA_fnc_targetEvent;
};

_unit setVariable [QGVAR(searchlight),_turnOn,true];

if (_turnOn) then {
	_unit action ["SearchLightOn",_vehicle];
	_vehicle lockCameraTo [_target,_turret,_target isEqualTo objNull];
} else {
	_unit action ["SearchLightOff",_vehicle];
	_vehicle lockCameraTo [objNull,_turret,true];
};
