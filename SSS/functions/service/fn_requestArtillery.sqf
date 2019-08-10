#include "script_component.hpp"

params ["_vehicle","_magType",["_position",[],[[]]],"_rounds","_dispersion"];

if (!alive _vehicle) exitWith {};
if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {[_vehicle,true] remoteExecCall ["SSS_fnc_respawn",2];};

if ((_vehicle getVariable "SSS_cooldown") > 0) exitWith {NOTIFY_1(_vehicle,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_vehicle))};
private _cooldownDefault = _vehicle getVariable "SSS_cooldownDefault";
_vehicle setVariable ["SSS_cooldown",_cooldownDefault # 0 + (_cooldownDefault # 1 * _rounds),true];
[_vehicle,"Rearmed and ready for further tasking."] remoteExecCall ["SSS_fnc_cooldown",2];

[_vehicle,true,_position] call SSS_fnc_updateMarker;

private _ETA = round (_vehicle getArtilleryETA [_position,_magType]);
NOTIFY_2(_vehicle,"Fire mission confirmed. %1 rounds - ETA %2.",_rounds,_ETA call SSS_fnc_properTime)

[{NOTIFY(_this,"Splash - over.")},_vehicle,(_ETA - 5) max 1] call CBA_fnc_waitAndExecute;
[{[_this,false] call SSS_fnc_updateMarker;},_vehicle,_ETA + 10] call CBA_fnc_waitAndExecute;

_vehicle setFuel 1;
_vehicle setVehicleAmmo 1;
(gunner _vehicle) setAmmo [currentWeapon _vehicle,20];

if (_dispersion isEqualTo 0) then {
	_vehicle doArtilleryFire [_position,_magType,_rounds];
} else {
	_vehicle doArtilleryFire [_position getPos [_dispersion * sqrt random 1,random 360],_magType,1];
	_vehicle setVariable ["SSS_artilleryRequestParams",[_position,_magType,_rounds - 1,_dispersion]];

	private _EHID = _vehicle addEventHandler ["Fired",{
		params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];
		(_vehicle getVariable "SSS_artilleryRequestParams") params ["_position","_magType","_rounds","_dispersion"];

		if (_magazine != _magType) exitWith {};
		if (_rounds > 0) then {
			_vehicle doArtilleryFire [_position getPos [_dispersion * sqrt random 1,random 360],_magType,1];
			_vehicle setVariable ["SSS_artilleryRequestParams",[_position,_magType,_rounds - 1,_dispersion]];
		} else {
			_vehicle removeEventHandler ["Fired",_vehicle getVariable "SSS_artilleryFiredEHID"];
			_vehicle setVariable ["SSS_artilleryRequestParams",nil];
			_vehicle setVariable ["SSS_artilleryFiredEHID",nil];
		};
	}];

	_vehicle setVariable ["SSS_artilleryFiredEHID",_EHID];
};

// Make sure we have ammo while firing
[{
	params ["_vehicle"];
	if (alive _vehicle && alive gunner _vehicle && (_vehicle getVariable "SSS_cooldown") > 0) then {
		(gunner _vehicle) setAmmo [currentWeapon _vehicle,20];
		false
	} else {
		true
	};
},{},[_vehicle]] call CBA_fnc_waitUntilAndExecute;
