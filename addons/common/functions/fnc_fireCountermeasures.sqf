#include "script_component.hpp"

params ["_vehicle",["_duration",2],["_interval",0],["_cm",[]]];

if (_cm isEqualTo []) then {
	_cm = (_vehicle call FUNC(getCountermeasures)) param [0,[]];
};

_cm params [["_weapon",""],["_magazine",""],["_turret",[]]];
if (_weapon isEqualTo "" || _magazine isEqualTo "" || _turret isEqualTo []) exitWith {};

[{
	params ["_vehicle","_duration","_interval","_cm","_delayTick"];
	_cm params ["_weapon","_magazine","_turret"];

	if (CBA_missionTime >= _delayTick) then {
		weaponState [_vehicle,_turret,_weapon] params ["","_muzzle","_firemode"];
		(_vehicle turretUnit _turret) forceWeaponFire [_muzzle,_firemode];
		_this set [4,CBA_missionTime + _interval];
	};
	
	!alive _vehicle
},{},[_vehicle,_duration,_interval,_cm,CBA_missionTime],_duration] call CBA_fnc_waitUntilAndExecute;
