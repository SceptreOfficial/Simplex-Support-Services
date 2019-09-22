#include "script_component.hpp"

params ["_entity","_magType",["_position",[],[[]]],"_rounds","_dispersion"];

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {
	[_entity,true] call FUNC(respawn);
};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestArtillery),_vehicle];
};

if ((_entity getVariable "SSS_cooldown") > 0) exitWith {
	NOTIFY_1(_entity,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_entity));
};

// Start cooldown
private _cooldownDefault = _entity getVariable "SSS_cooldownDefault";
[_entity,_cooldownDefault # 0 + (_cooldownDefault # 1 * _rounds),"Rearmed and ready for further tasking."] call FUNC(cooldown);

// Update task marker
[_entity,true,_position] call FUNC(updateMarker);

// Order artillery
if (_vehicle isKindOf "B_Ship_MRLS_01_base_F") then {
	private _weapon = "weapon_VLS_01";
	private _reloadTime = getNumber (configFile >> "cfgWeapons" >> _weapon >> "reloadTime");
	private _magazineReloadTime = 1.3 * getNumber (configfile >> "CfgWeapons" >> _weapon >> "magazineReloadTime");
	private _missileClass = getText (configfile >> "CfgMagazines" >> _magType >> "ammo");
	private _missileMaxSpeed = getNumber (configfile >> "CfgAmmo" >> _missileClass >> "maxSpeed");
	private _ETA = ceil (((_position distance _vehicle) / _missileMaxSpeed) + 10);
	
	NOTIFY_3(_entity,"Fire mission on %1 confirmed. %2 rounds - ETA %3.",mapGridPosition _position,_rounds,PROPER_TIME(_ETA));
	[{NOTIFY(_this,"Splash - over.")},_entity,(_ETA - 5) max 0.5] call CBA_fnc_waitAndExecute;
	[{[_this,false] call FUNC(updateMarker);},_entity,_ETA + 10 + (_rounds * 10)] call CBA_fnc_waitAndExecute;

	_vehicle setFuel 1;
	{_vehicle removeMagazine _x} forEach magazines _vehicle;
	{_vehicle removeWeapon _x} forEach weapons _vehicle;
	_vehicle addMagazine _magType;
	_vehicle addWeapon _weapon;
	_vehicle setWeaponReloadingTime [gunner _vehicle,_weapon,0];
	private _targetPos = _position getPos [_dispersion * sqrt random 1,random 360];
	private _target = (createGroup sideLogic) createUnit ["Logic",_targetPos,[],0,"CAN_COLLIDE"];
	private _targetLife = ((1.3 * _ETA) max 15) + 20;
	[{deleteVehicle _this},_target,_targetLife] call CBA_fnc_waitAndExecute;
	_vehicle reveal _target;
	side _vehicle reportRemoteTarget [_target,_targetLife];

	[{
		params ["_entity","_vehicle","_position","_magType","_dispersion","_rounds","_target","_targetLife","_weapon","_reloadTime"];

		private _roundsLeft = _rounds - 1;

		if (_roundsLeft > 0) then {
			_vehicle setVariable ["SSS_roundsLeft",_roundsLeft];

			[_vehicle,"Fired",{
				params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];
				_thisArgs params ["_position","_magType","_dispersion","_targetLife","_reloadTime"];

				if (_magazine != _magType) exitWith {};

				private _roundsLeft = _vehicle getVariable "SSS_roundsLeft";

				if (_roundsLeft > 0) then {
					[{
						params ["_vehicle","_position","_dispersion","_targetLife","_weapon"];

						_vehicle setWeaponReloadingTime [gunner _vehicle,_weapon,0];
						private _targetPos = _position getPos [_dispersion * sqrt random 1,random 360];
						private _target = (createGroup sideLogic) createUnit ["Logic",_targetPos,[],0,"CAN_COLLIDE"];
						[{deleteVehicle _this},_target,_targetLife] call CBA_fnc_waitAndExecute;
						_vehicle reveal _target;
						side _vehicle reportRemoteTarget [_target,_targetLife];

						[{
							params ["_vehicle","_target","_weapon"];

							_vehicle fireAtTarget [_target,_weapon];
							private _roundsLeft = (_vehicle getVariable "SSS_roundsLeft") - 1;
							_vehicle setVariable ["SSS_roundsLeft",_roundsLeft];
						},[_vehicle,_target,_weapon]] call CBA_fnc_execNextFrame;
					},[_vehicle,_position,_dispersion,_targetLife,_weapon],_reloadTime] call CBA_fnc_waitAndExecute;
				};

				if (_roundsLeft <= 0) then {
					_vehicle removeEventHandler [_thisType,_thisID];
					_vehicle setVariable ["SSS_doneFiring",true];
				};
			},[_position,_magType,_dispersion,_targetLife,_reloadTime]] call CBA_fnc_addBISEventHandler;
		};

		_vehicle fireAtTarget [_target,_weapon];
	},[_entity,_vehicle,_position,_magType,_dispersion,_rounds,_target,_targetLife,_weapon,_reloadTime]] call CBA_fnc_execNextFrame;
} else {
	private _ETA = round (_vehicle getArtilleryETA [_position,_magType]);
	NOTIFY_3(_entity,"Fire mission on %1 confirmed. %2 rounds - ETA %3.",mapGridPosition _position,_rounds,PROPER_TIME(_ETA));
	[{NOTIFY(_this,"Splash - over.")},_entity,(_ETA - 5) max 0.5] call CBA_fnc_waitAndExecute;
	[{[_this,false] call FUNC(updateMarker);},_entity,_ETA + 10 + (_rounds * 3)] call CBA_fnc_waitAndExecute;

	_vehicle setFuel 1;
	_vehicle setVehicleAmmo 1;
	(gunner _vehicle) setAmmo [currentWeapon _vehicle,20];

	if (_dispersion isEqualTo 0) then {
		_vehicle doArtilleryFire [_position,_magType,_rounds];
	} else {
		[_vehicle,"Fired",{
			params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];
			_thisArgs params ["_position","_magType","_dispersion"];

			if (_magazine != _magType) exitWith {};

			private _roundsLeft = _vehicle getVariable "SSS_roundsLeft";

			if (_roundsLeft > 0) then {
				_vehicle doArtilleryFire [_position getPos [_dispersion * sqrt random 1,random 360],_magType,1];
				_roundsLeft = _roundsLeft - 1;
				_vehicle setVariable ["SSS_roundsLeft",_roundsLeft];
			};

			if (_roundsLeft <= 0) then {
				_vehicle removeEventHandler [_thisType,_thisID];
				_vehicle setVariable ["SSS_doneFiring",true];
			};
		},[_position,_magType,_dispersion]] call CBA_fnc_addBISEventHandler;

		_vehicle doArtilleryFire [_position getPos [_dispersion * sqrt random 1,random 360],_magType,1];
		_vehicle setVariable ["SSS_roundsLeft",_rounds - 1];
	};
};

// Make sure we have ammo while firing
[{
	params ["_entity","_vehicle"];

	if (alive _vehicle &&
		alive gunner _vehicle &&
		isNil {_vehicle getVariable "SSS_doneFiring"} &&
		(_entity getVariable "SSS_cooldown") > 0
	) then {
		(gunner _vehicle) setAmmo [currentWeapon _vehicle,20];
		false
	} else {
		_vehicle setVariable ["SSS_doneFiring",nil];
		true
	};
},{},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
