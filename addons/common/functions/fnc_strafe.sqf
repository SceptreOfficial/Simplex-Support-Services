#include "script_component.hpp"
#define ABORT_TIMEOUT 5

if (canSuspend) exitWith {[FUNC(strafe),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_target",[0,0,0],[[],objNull],3],
	["_pylonConfig",[],[[]]], // [[_weapon,_magazine,_turret],[_quantity,_isDuration],_interval]
	["_infiniteAmmo",true,[false]],
	["_spread",0,[0]],
	["_ingress",-1,[0]],
	["_search","",[""]],
	["_altitude",500,[0]],
	["_aimRange",-1,[0]]
];

if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(strafe)],_vehicle] call CBA_fnc_targetEvent;
};

if (_vehicle getVariable [QGVAR(strafe),false]) exitWith {
	_vehicle setVariable [QGVAR(strafeCancel),true,true];

	[{
		params ["_vehicle"];
		!(_vehicle getVariable [QGVAR(strafe),false])
	},FUNC(strafe),_this,ABORT_TIMEOUT,{
		params ["_vehicle"];
		false call FUNC(strafeCleanup);
		[FUNC(strafe),_this] call CBA_fnc_execNextFrame;
	}] call CBA_fnc_waitUntilAndExecute;
};

if (_target in [[0,0,0],objNull]) exitWith {};

if (!alive _vehicle || !canMove _vehicle || {!(_vehicle isKindOf "Air")}) exitWith {
	ERROR_F("Invalid vehicle");
};

if (_ingress < 0) then {_ingress = _target getDir _vehicle};
if (_aimRange < 0) then {_aimRange = [2600,1000] select (_vehicle isKindOf "Helicopter")};
_aimRange = _aimRange max 600;

private _weapons = [];
private _magazines = [];
private _turrets = [];
private _ammoData = [];
private _elevOffsets = [];
private _quantities = [];
private _intervals = [];
private _bombs = [];
private _totalDuration = 0;
private _durations = [];

{
	_x params [["_pylon","",["",[]]],["_quantity",0,[0,[]]],["_interval",0]];
	_quantity params [["_quantity",0],["_isDuration",false]];
	_pylon params [["_weapon",""],["_magazine",""],["_turret",[-1]]];

	if (_weapon isEqualTo "" || _quantity <= 0) then {continue};

	weaponState [_vehicle,_turret,_weapon] params ["","","_firemode","_loadedMag"];

	if (_magazine isEqualTo "") then {
		_magazine = compatibleMagazines _weapon arrayIntersect (_vehicle magazinesTurret [_turret,false]) param [0,""];

		if (_magazine isEqualTo "" && _infiniteAmmo) then {
			_magazine = compatibleMagazines _weapon param [0,""];
			_vehicle addMagazineTurret [_magazine,_turret];
			_vehicle loadMagazine [_turret,_weapon,_magazine];
		};
	};

	if (_magazine isEqualTo "") then {continue};

	if (_magazine != _loadedMag) then {
		_vehicle loadMagazine [_turret,_weapon,_magazine];
	};

	private _xAmmoData = [_weapon,_magazine] call FUNC(ammoData);
	_xAmmoData params ["_initSpeed","_airFriction","_timeToLive","_simStep","_simulation","_canLock","_otherLock","_airLock"];

	_interval = _interval max getNumber (configFile >> "CfgWeapons" >> _weapon >> _firemode >> "reloadTime");

	if (_simulation in ["shotmissile","shotrocket"] || _canLock) then {
		_interval = _interval max 0.1;
	};

	if (_initSpeed <= 0) then {
		_interval = _interval max 0.4;
		_bombs pushBack _magazine;
		_elevOffsets pushBack 0;
	} else {
		_elevOffsets pushBack ([_vehicle,_weapon] call FUNC(getElevationOffset));
	};

	private _duration = [_quantity * _interval,_quantity] select _isDuration;
	_totalDuration = _totalDuration + _duration;

	_weapons pushBack _weapon;
	_magazines pushBack _magazine;
	_turrets pushBack _turret;
	_ammoData pushBack _xAmmoData;
	_quantities pushBack [_quantity,_isDuration];
	_durations pushBack _duration;
	_intervals pushBack _interval;
} forEach _pylonConfig;

_vehicle setVariable [QGVAR(bombMagazines),_bombs];

_vehicle removeEventHandler ["Fired",_vehicle getVariable [QGVAR(firedEHID),-1]];
private _EHID = _vehicle addEventHandler ["Fired",FUNC(fired)];
_vehicle setVariable [QGVAR(firedEHID),_EHID];

private _maxSpeed = getNumber (configOf _vehicle >> "maxSpeed") / 3.6;
private _minSpeed = [getNumber (configOf _vehicle >> "stallSpeed") * 1.1 / 3.6,28 min (_maxSpeed / 3)] select (_vehicle isKindOf "Helicopter");
private _speed = (_maxSpeed * 0.6) min 160 max _minSpeed;

private _hBuffer = getPosASL _vehicle # 2 / 2;
private _minDist = (_aimRange * 0.8) max (_speed * (_totalDuration + 0.5) + _hBuffer);
private _simDist = _aimRange max (_speed * (_totalDuration + 3) + _hBuffer);
private _prepDist = (_aimRange + 800) max (_maxSpeed * (_totalDuration + 6) + _hBuffer);// TODO: was 12, re-evaluate ETA and test vanilla aircraft
private _altitudeASL = if (_target isEqualType objNull) then {
	getPosASL _target # 2 + _altitude
} else {
	_target # 2 + _altitude
};

_vehicle flyInHeight _altitude;
_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];

_vehicle setVariable [QGVAR(strafe),true,true];
_vehicle setVariable [QGVAR(strafeHeightATL),getPos _vehicle # 2,true];
_vehicle setVariable [QGVAR(strafeHeightASL),getPosASL _vehicle # 2,true];
_vehicle setVariable [QGVAR(strafeApproach),nil,true];
_vehicle setVariable [QGVAR(firedCounts),nil];

// Disable AI targeting
private _units = PRIMARY_CREW(_vehicle);
_vehicle setVariable [QGVAR(strafeAI),_units];

{
	_x setVariable [QGVAR(strafeAIFeatures),[
		["AUTOTARGET",_x checkAIFeature "AUTOTARGET"],
		["TARGET",_x checkAIFeature "TARGET"]
	]];

	[QGVAR(enableAIFeature),[_x,["AUTOTARGET",false]],_x] call CBA_fnc_targetEvent;
	[QGVAR(enableAIFeature),[_x,["TARGET",false]],_x] call CBA_fnc_targetEvent;
} forEach _units;

// Begin approach
[{
	_this # 0 params ["_vehicle","_target","_ingress","_minDist","_simDist","_prepDist","_moveTick","","_minKMH","_KMH","_randomAngle"];

	private _relDir = ((_vehicle getDir _target) - getDir _vehicle) call CBA_fnc_simplifyAngle;
	_relDir = [_relDir,_relDir - 360] select (_relDir > 180);
	private _goodAim = abs _relDir < 50;
	_relDir = ((_target getDir _vehicle) - _ingress) call CBA_fnc_simplifyAngle;
	_relDir = [_relDir,_relDir - 360] select (_relDir > 180);
	private _goodApproach = abs _relDir < 25;
	private _distance = _vehicle distance2D _target;

	private _movePos = if (_distance > _simDist && _distance < _prepDist) then {
		if (_goodApproach && _goodAim) then {
			if !(_vehicle getVariable [QGVAR(strafeApproach),false]) then {
				_vehicle setVariable [QGVAR(strafeApproach),true,true];
				[QGVAR(strafeApproach),[_vehicle]] call CBA_fnc_localEvent;
				[QGVAR(limitSpeed),[_vehicle,_KMH]] call CBA_fnc_localEvent;
			};

			_target getPos [0,_ingress]
		} else {
			_target getPos [_prepDist * 1.4,_ingress]
		};
	} else {
		if (_distance >= _prepDist && _goodApproach) then {
			_target getPos [0,_ingress]
		} else {
			_target getPos [_prepDist * 1.4,_ingress]
		};
	};

	if (_distance <= _simDist && _distance >= _minDist && _goodApproach && _goodAim && speed _vehicle >= _minKMH) exitWith {true};

	if (CBA_missionTime > _moveTick) then {
		_this # 0 set [6,CBA_missionTime + 3];
		_vehicle doMove _movePos;
	};

	!alive _vehicle ||
	!canMove _vehicle ||
	!local _vehicle ||
	_vehicle getVariable [QGVAR(strafeCancel),false] ||
	{_target isEqualType objNull && {isNull _target}}
},{
	_this # 1 params [
		"_vehicle",
		"_target",
		"_weapons",
		"_magazines",
		"_turrets",
		"_ammoData",
		"_elevOffsets",
		"_quantities",
		"_intervals",
		"_infiniteAmmo",
		"_spread",
		"_search",
		"_aimRange",
		"_durations"
	];

	if (!alive _vehicle ||
		!canMove _vehicle ||
		!local _vehicle ||
		_vehicle getVariable [QGVAR(strafeCancel),false] ||
		{_target isEqualType objNull && {isNull _target}}
	) exitWith {false call FUNC(strafeCleanup)};
	
	if (!isNil {_vehicle getVariable QGVAR(strafeSimEHID)}) exitWith {
		false call FUNC(strafeCleanup);
		ERROR_F("Invalid vehicle");
	};

	if !(_vehicle getVariable [QGVAR(strafeApproach),false]) then {
		_vehicle setVariable [QGVAR(strafeApproach),true,true];
		[QGVAR(strafeApproach),[_vehicle]] call CBA_fnc_localEvent;
	};

	_target = [_target,side group _vehicle,_search] call FUNC(targetSearch);

	if (_target isEqualType objNull && {isNull _target}) exitWith {
		NOTIFY(_vehicle,LSTRING(strafeNoTarget));
		false call FUNC(strafeCleanup);
	};

	NOTIFY(_vehicle,LSTRING(strafeFiring));

	// Open pylon bays
	{
		private _pylonIndex = _forEachIndex + 1;
		_vehicle animateBay [_pylonIndex,1,false];
	} forEach getPylonMagazines _vehicle;

	// Begin simulation
	if (OPTION(debug)) then {setAccTime 1};
	private _ID = addMissionEventHandler ["EachFrame",{call FUNC(strafeSim)},[
		_vehicle,
		_target,
		_weapons,
		_infiniteAmmo,
		_spread,
		_quantities,
		_intervals,
		_aimRange,
		_elevOffsets,
		_magazines,
		_ammoData,
		_durations,
		velocityModelSpace _vehicle,
		getPosASL _vehicle,
		velocity _vehicle,
		0,
		0,
		[vectorDir _vehicle,vectorUp _vehicle] call FUNC(yawPitchBank),
		[[],[],[],CBA_missionTime - 2],
		CBA_missionTime,
		0,
		_turrets,
		30//[200,40] select (_vehicle isKindOf "Helicopter")
	]];

	_vehicle setVariable [QGVAR(strafeSimEHID),_ID];

	[QGVAR(strafeSim),[_vehicle]] call CBA_fnc_globalEvent;
},[[
	_vehicle,
	_target,
	_ingress,
	_minDist,
	_simDist,
	_prepDist,
	0,
	_target getPos [0,0],
	_minSpeed * 3.6,
	_speed * 3.6,
	selectRandom [45,-45]
],[
	_vehicle,
	_target,
	_weapons,
	_magazines,
	_turrets,
	_ammoData,
	_elevOffsets,
	_quantities,
	_intervals,
	_infiniteAmmo,
	_spread,
	_search,
	_aimRange,
	_durations
]]] call CBA_fnc_waitUntilAndExecute;
