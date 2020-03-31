#include "script_component.hpp"

params [["_vehicle",objNull,[objNull]],["_magType","",[""]],["_position",[],[[]]],["_rounds",1,[1]],["_dispersion",0,[0]]];

if (!alive _vehicle) exitWith {};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestArtilleryNonSupport),_vehicle];
};

// Order artillery
if (_vehicle isKindOf "B_Ship_MRLS_01_base_F") then {
	private _weapon = "weapon_VLS_01";
	private _reloadTime = getNumber (configFile >> "cfgWeapons" >> _weapon >> "reloadTime");
	private _magazineReloadTime = 1.3 * getNumber (configfile >> "CfgWeapons" >> _weapon >> "magazineReloadTime");
	private _missileClass = getText (configfile >> "CfgMagazines" >> _magType >> "ammo");
	private _missileMaxSpeed = getNumber (configfile >> "CfgAmmo" >> _missileClass >> "maxSpeed");
	private _ETA = ceil (((_position distance _vehicle) / _missileMaxSpeed) + 10);

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
		params ["_vehicle","_position","_magType","_dispersion","_rounds","_target","_targetLife","_weapon","_reloadTime"];

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
	},[_vehicle,_position,_magType,_dispersion,_rounds,_target,_targetLife,_weapon,_reloadTime]] call CBA_fnc_execNextFrame;
} else {
	private _ETA = round (_vehicle getArtilleryETA [_position,_magType]);

	_vehicle setFuel 1;
	_vehicle setVehicleAmmo 1;
	//(gunner _vehicle) doWatch _position;
	_vehicle setVariable ["SSS_roundsLeft",_rounds];
	_vehicle setVariable ["SSS_doneFiring",false];

	if (_dispersion isEqualTo 0) then {
		[_vehicle,"Fired",{
			params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];
			_thisArgs params ["_magType"];

			if (_vehicle getVariable ["SSS_doneFiring",false]) exitWith {
				_vehicle removeEventHandler [_thisType,_thisID];
			};

			if (_magazine != _magType) exitWith {};

			private _roundsLeft = (_vehicle getVariable "SSS_roundsLeft") - 1;
			_vehicle setVariable ["SSS_roundsLeft",_roundsLeft];
			_vehicle setVariable ["SSS_doneFiring",true];

			if (_roundsLeft <= 0) then {
				_vehicle removeEventHandler [_thisType,_thisID];
			};
		},[_magType]] call CBA_fnc_addBISEventHandler;
		
		[{
			params ["_args","_PFHID"];
			_args params ["_vehicle","_position","_magType","_rounds"];

			if (!alive _vehicle || !alive gunner _vehicle || {_vehicle getVariable ["SSS_doneFiring",false]}) exitWith {
				[_PFHID] call CBA_fnc_removePerFrameHandler;
			};

			if (unitReady _vehicle) then {
				_vehicle doArtilleryFire [_position,_magType,_rounds];
			};
		},5,[_vehicle,_position,_magType,_rounds]] call CBA_fnc_addPerFrameHandler;
	} else {
		[_vehicle,"Fired",{
			params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];
			_thisArgs params ["_magType","_position","_dispersion"];

			if (_vehicle getVariable ["SSS_doneFiring",false]) exitWith {
				_vehicle removeEventHandler [_thisType,_thisID];
			};

			if (_magazine != _magType) exitWith {};

			private _roundsLeft = (_vehicle getVariable "SSS_roundsLeft") - 1;
			_vehicle setVariable ["SSS_roundsLeft",_roundsLeft];

			if (_roundsLeft <= 0) then {
				_vehicle removeEventHandler [_thisType,_thisID];
				_vehicle setVariable ["SSS_doneFiring",true];
			} else {
				_vehicle doArtilleryFire [_position getPos [_dispersion * sqrt random 1,random 360],_magType,1];
			};
		},[_magType,_position,_dispersion]] call CBA_fnc_addBISEventHandler;
		
		[{
			params ["_args","_PFHID"];
			_args params ["_vehicle","_position","_magType","_dispersion"];

			if (!alive _vehicle || !alive gunner _vehicle || {_vehicle getVariable ["SSS_doneFiring",false]}) exitWith {
				[_PFHID] call CBA_fnc_removePerFrameHandler;
			};

			if (unitReady _vehicle) then {
				_vehicle doArtilleryFire [_position getPos [_dispersion * sqrt random 1,random 360],_magType,1];
			};
		},5,[_vehicle,_position,_magType,_dispersion]] call CBA_fnc_addPerFrameHandler;
	};
};

[{
	(gunner _this) setAmmo [currentWeapon _this,999];

	!alive _this || !alive gunner _this || {(_this getVariable "SSS_roundsLeft") <= 0}
},{
	_this setVariable ["SSS_doneFiring",true];
	_this setVehicleAmmo 1;
},_vehicle] call CBA_fnc_waitUntilAndExecute;
