#include "script_component.hpp"
#define ABORT_TIMEOUT 5

if (canSuspend) exitWith {[FUNC(carpetBombing),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_endPos",[0,0,0],[[]]],
	["_spread",0,[0]],
	["_weapon","",["",[]]],
	["_infiniteAmmo",true,[false]],
	["_interval",0.5]
];

if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(carpetBombing)],_vehicle] call CBA_fnc_targetEvent;
};

if (_vehicle getVariable [QGVAR(carpetBombing),false]) exitWith {
	_vehicle setVariable [QGVAR(carpetBombingAbort),true,true];

	[{
		params ["_vehicle"];
		!(_vehicle getVariable [QGVAR(carpetBombing),false])
	},FUNC(carpetBombing),_this,ABORT_TIMEOUT,{
		params ["_vehicle"];
		_vehicle setVariable [QGVAR(carpetBombing),nil];
		[FUNC(carpetBombing),_this] call CBA_fnc_execNextFrame;
	}] call CBA_fnc_waitUntilAndExecute;
};

if (_endPos in [[0,0,0],objNull]) exitWith {};

if (!alive _vehicle || !canMove _vehicle || {!(_vehicle isKindOf "Air")}) exitWith {
	LOG_ERROR("Invalid vehicle");
};

_vehicle setVariable [QGVAR(carpetBombing),true,true];
_vehicle setVariable [QGVAR(carpetBombingAbort),nil,true];
_vehicle setVariable [QGVAR(carpetBombingDrop),false];

_vehicle setVariable [QGVAR(bombMagazines),[_weapon param [1,""]]];
_vehicle setVariable [QGVAR(precisionBombing),false];

_vehicle removeEventHandler ["Fired",_vehicle getVariable [QGVAR(firedEHID),-1]];
private _EHID = _vehicle addEventHandler ["Fired",FUNC(fired)];
_vehicle setVariable [QGVAR(firedEHID),_EHID];

private _startPos = getPosASL _vehicle;
private _vDir = _startPos vectorFromTo _endPos;
private _vUp = (_vDir vectorCrossProduct (_vDir vectorCrossProduct [0,0,1])) vectorMultiply -1;

[{
	params [
		"_vehicle",
		"_endPos",
		"_spread",
		"_weapon",
		"_infiniteAmmo",
		"_interval",
		"_startPos",
		"_vDirStart",
		"_vDirEnd",
		"_vUpStart",
		"_vUpEnd",
		"_controlTime",
		"_startTime",
		"_lastTime",
		"_lastPos",
		"_triggerTick"
	];
	
	if (!alive _vehicle || !canMove _vehicle || !local _vehicle || _vehicle getVariable [QGVAR(carpetBombingAbort),false]) exitWith {true};

	private _progress = (CBA_missionTime - _startTime) / _controlTime;
	private _delta = CBA_missionTime - _lastTime max 0.000001;
	_this set [13,CBA_missionTime];

	if (_progress > 1) exitWith {true};

	private _pos = vectorLinearConversion [0,1,_progress,_startPos,_endPos];
	private _velocity = _pos vectorDiff _lastPos vectorMultiply 1 / _delta;
	_this set [14,_pos];

	_vehicle setVelocityTransformation [_pos,_pos,_velocity,_velocity,_vDirStart,_vDirEnd,_vUpStart,_vUpEnd,_progress];
	_vehicle setVelocity _velocity;

	if (_pos distance2D _endPos < _spread && _triggerTick <= CBA_missionTime) then {
		if !(_vehicle getVariable [QGVAR(carpetBombingDrop),false]) then {
			private _entity = _vehicle getVariable [QPVAR(entity),objNull];
			[_entity,true,"BOMBING",[LSTRING(statusBombing),RGBA_YELLOW]] call EFUNC(common,setStatus);
		};

		_weapon params ["_weapon",["_magazine",""],["_turret",[-1]]];

		private _unit = _vehicle turretUnit _turret;

		if (_infiniteAmmo) then {
			_vehicle setVehicleAmmo 1;
		};

		weaponState [_vehicle,_turret,_weapon] params ["","_muzzle","_firemode"];

		_vehicle setWeaponReloadingTime [_unit,_muzzle,0];
		_unit forceWeaponFire [_muzzle,_firemode];

		_this set [15,CBA_missionTime + _interval + random 0.1 - 0.2];
	};

	false
},{
	params ["_vehicle"];
	_vehicle setVariable [QGVAR(carpetBombing),nil,true];
	_vehicle setVariable [QGVAR(carpetBombingAbort),nil,true];
	_vehicle setVariable [QGVAR(carpetBombingDrop),nil];

	_vehicle setVariable [QGVAR(bombMagazines),nil];
	_vehicle setVariable [QGVAR(precisionBombing),nil];
	_vehicle removeEventHandler ["Fired",_vehicle getVariable [QGVAR(firedEHID),-1]];
	_vehicle setVariable [QGVAR(firedEHID),nil];
},[
	_vehicle,
	_endPos,
	_spread,
	_weapon,
	_infiniteAmmo,
	_interval,
	_startPos,
	vectorDir _vehicle,
	_vDir,
	vectorUp _vehicle,
	_vUp,
	(_startPos distance _endPos) / (speed _vehicle / 3.6),
	CBA_missionTime,
	CBA_missionTime,
	_startPos,
	0
]] call CBA_fnc_waitUntilAndExecute;
