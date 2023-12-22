#include "script_component.hpp"

params [
	["_entity",objNull,[objNull]],
	["_vehicle",objNull,[objNull]],
	["_reset",true,[false]],
	["_restoreCrew",true,[false]]
];

if (isNull _entity || !alive _vehicle) exitWith {};

if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,FUNC(reset)],_vehicle] call CBA_fnc_targetEvent;
};

if (_reset) then {
	if ((_entity getVariable QPVAR(supportType)) != "PLANE") then {
		_vehicle setFuel 1;
	};

	_vehicle setDamage 0;
	_vehicle setVehicleAmmo 1;
};

if (_restoreCrew) then {
	[_entity,_vehicle] call FUNC(restoreCrew);
};
