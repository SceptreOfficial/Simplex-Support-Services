#include "..\script_component.hpp"
/*
	Authors: Sceptre
	Makes an artillery unit fire on target location

	Parameters:
	0: Artillery <OBJECT>
	1: Target <OBJECT | ARRAY>
	2: Magazines (Optional) <ARRAY | STRING>
	3: Rounds to fire (Optional) <SCALAR>
	5: Firing delay (Minimum delay between each round) (Optional) <ARRAY>

	Returns:
	Success <BOOL>

	CBA Events:
	QGVAR(firing) 		params ["_vehicle","_area","_magazine","_rounds","_firingDelay","_ETA"];
	QGVAR(complete) 	params ["_vehicle","_area","_magazine","_rounds","_firingDelay"];
	QGVAR(splash)  		params ["_vehicle","_area","_magazine","_rounds","_firingDelay"];
*/

if (canSuspend) exitWith {
	[FUNC(fire),_this] call CBA_fnc_directCall;
};

params [
	["_vehicle",objNull,[objNull]],
	["_target",[0,0,0],[objNull,[]]],
	["_magazines","",["",[]]],
	["_rounds",4,[0]],
	["_firingDelay",0,[0,[]],2]
];

if (!local _vehicle) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(fire)],_vehicle] call CBA_fnc_targetEvent;
};

if (_vehicle isKindOf "B_Ship_MRLS_01_base_F" || _vehicle isKindOf "OPTRE_archer_system_base") exitWith {_this call FUNC(fireVLS)};

private "_area";
private _gunner = gunner _vehicle;
private _targeting = "AREA";

switch true do {
	case (_target isEqualType objNull) : {
		_target = getPosASL _target;
		_area = [_target,0,0,0,false];
	};
	case (_target isEqualTypeArray [0,0,0]) : {
		_area = [_target,0,0,0,false];
	};
	case (_target isEqualTypeArray [[],0,0,0,false]) : {
		_area = _target;
		_target = _target # 0;

		if (_target isEqualType objNull) then {
			_target = getPosASL _target;
			_area set [0,_target];
		};
	};
	case (_target isEqualTypeParams [[]]) : {
		_target params ["_tArea",["_creeping",false,[false]],["_random",false,[false]]];
		_area = _tArea;
		_target = _tArea # 0;

		if (_target isEqualType objNull) then {
			_target = getPosASL _target;
			_area set [0,_target];
		};

		_targeting = switch true do { 
			case (_creeping && _random) : {"CREEPING_RANDOM"};
			case _creeping : {"CREEPING_UNIFORM"};
			default {"AREA"};
		};
	};
};

// Validation
if (!alive _gunner || isPlayer _gunner || _target distance2D [0,0,0] < 0.1 || _rounds <= 0 || isNil "_area" || _magazines isEqualTo []) exitWith {false};

// Check if busy
if (_vehicle getVariable [QGVAR(firing),false] && !(_vehicle getVariable [QGVAR(recursive),false])) exitWith {false};

// Format firing delay
if (_firingDelay isEqualType 0) then {_firingDelay = [_firingDelay,_firingDelay]};

// Get mag
if (_magazines isEqualType "") then {_magazines = [_magazines]};

private _magazine = _magazines # (_vehicle getVariable [QGVAR(magIndex),0]);
private _turretPath = _vehicle unitTurret _gunner;
private _weapon = (_vehicle weaponsTurret _turretPath) # 0;

if (_magazine isEqualTo "") then {
	_magazine = _vehicle currentMagazineTurret _turretPath;
} else {
	// Give mag
	if !(toLower _magazine in (magazines _vehicle apply {toLower _x})) then {
		_vehicle addMagazineTurret [_magazine,_turretPath];
	};

	// Load mag
	if (_vehicle currentMagazineTurret _turretPath != _magazine) then {
		_vehicle loadMagazine [_turretPath,_weapon,_magazine];
	};
};

// Get firing instruction
private _instruction = switch _targeting do {
	case "AREA" : {
		for "_i" from 1 to 5 do {
			_target = [_area] call CBA_fnc_randPosArea;
			private _instruction = [_vehicle,_target,_magazine,true] call FUNC(calculate);
			
			if (_instruction isNotEqualTo [] || _area select [1,2] isEqualTo [0,0]) exitWith {_instruction};
			_instruction
		};
	};
	case "CREEPING_UNIFORM" : {
		_area params ["_center","_width","_height","_dir","_isRect"];
		_width = _width max 1;
		_height = _height max 1;

		private _spacing = (_height / _rounds) * 2;
		_target = ATLToASL (_vehicle getVariable [QGVAR(creepingTarget),_target getPos [_height - _spacing/2,_dir - 180]]);
		_vehicle setVariable [QGVAR(creepingTarget),_target getPos [_spacing,_dir]];
		private _instruction = [_vehicle,_target,_magazine,true] call FUNC(calculate);

		//private _marker = createMarker [GEN_STR(_target),_target];
		//_marker setMarkerType "hd_dot";

		if (_instruction isEqualTo []) then {
			_vehicle setVariable [QGVAR(fireOption),nil];
			_instruction = [_vehicle,_target,_magazine,true] call FUNC(calculate);
		};

		_instruction
	};
	case "CREEPING_RANDOM" : {
		_area params ["_center","_width","_height","_dir","_isRect"];
		_width = _width max 1;
		_height = _height max 1;

		private _spacing = (_height / _rounds) * 2;
		private _creepingTarget = _vehicle getVariable [QGVAR(creepingTarget),_target getPos [_height - _spacing/2,_dir - 180]];
		private _creepArea = [_creepingTarget,_width,_spacing / 2,_dir,true];

		//private _marker = createMarker [GEN_STR(_creepingTarget),_creepingTarget];
		//_marker setMarkerShape "RECTANGLE";
		//_marker setMarkerSize [_creepArea # 1 - 1,_creepArea # 2 - 1];
		//_marker setMarkerDir _dir;

		_vehicle setVariable [QGVAR(creepingTarget),_creepingTarget getPos [_spacing,_dir]];

		private _instruction = for "_i" from 1 to 5 do {
			while {
				_target = [_creepArea] call CBA_fnc_randPosArea;
				!(_target inArea _area)
			} do {};
			
			//private _marker = createMarker [GEN_STR(_target),_target];
			//_marker setMarkerType "hd_dot";
			
			private _instruction = [_vehicle,_target,_magazine,true] call FUNC(calculate);
			
			if (_instruction isNotEqualTo []) exitWith {_instruction};
			_instruction
		};

		if (_instruction isEqualTo []) then {
			_vehicle setVariable [QGVAR(fireOption),nil];
			_instruction = [_vehicle,_target,_magazine,true] call FUNC(calculate);
		};

		_instruction
	};
};

if (_instruction isEqualTo []) exitWith {
	_vehicle setVariable [QGVAR(recursive),nil];
	false
};

// Start firing instruction
_instruction params ["_ETA","_mode","_modeIndex","_angle","_charge"];

_vehicle setVariable [QGVAR(firing),true];
_vehicle setVariable [QGVAR(fireOption),[_mode,_modeIndex,_charge,_angle]];

if !(_vehicle getVariable [QGVAR(velocityOverride),false]) then {
	//private _firemode = getArray (configFile >> "CfgWeapons" >> _weapon >> "modes") param [_modeIndex,""];
	//private _magazines = _vehicle magazinesTurret _turretPath;
	//private _weapons = _vehicle weaponsTurret _turretPath;

	// Remove all mags and weapons to force load magazine (no other way to fix mag reload time)
	//{_vehicle removeMagazineTurret [_x,_turretPath]} forEach _magazines;
	//{_vehicle removeWeaponTurret [_x,_turretPath]} forEach _weapons;
	//{_vehicle addMagazineTurret [_x,_turretPath]} forEach _magazines;
	//{_vehicle addWeaponTurret [_x,_turretPath]} forEach _weapons;

	//if !(_gunner selectWeapon [_weapon,currentMuzzle _gunner,_firemode]) then {
		_gunner action ["SWITCHMAGAZINE",_vehicle,_gunner,_modeIndex];
	//};	
};

private _startASL = getPosWorld _vehicle;
private _aimPosASL = _startASL getPos [600,_startASL getDir _target];
_aimPosASL set [2,_startASL # 2 + tan _angle * 600];

_gunner setVariable [QGVAR(aimPosATL),ASLToATL _aimPosASL];
_gunner setVariable [QGVAR(aimPosASL),_aimPosASL];
_gunner setVariable [QGVAR(hold),true];
_gunner setVariable [QGVAR(charge),_charge];

// Wait until aimed to open fire
_vehicle setVariable [QGVAR(weaponDirection),_vehicle weaponDirection _weapon];
_vehicle setVariable [QGVAR(aimTick),CBA_missionTime + 2];

[{
	params ["_vehicle","_gunner","_weapon","_aimDir"];

	!alive _vehicle || !alive _gunner || !(_gunner in _vehicle) || _vehicle getVariable [QGVAR(abort),false] || {
		private _dir = _vehicle weaponDirection _weapon;
		private _lastDir = _vehicle getVariable QGVAR(weaponDirection);
		_vehicle setVariable [QGVAR(weaponDirection),_dir];

		if (_dir vectorDistance _lastDir < 0.0001 && _dir vectorDistance _aimDir < 0.05) then {
			_vehicle getVariable QGVAR(aimTick) < CBA_missionTime
		} else {
			_vehicle setVariable [QGVAR(aimTick),CBA_missionTime + 0.3];
			false
		};
	}
},{
	[{_this setVariable [QGVAR(hold),nil]},_this # 1,0.15] call CBA_fnc_waitAndExecute;
},[_vehicle,_gunner,_weapon,_startASL vectorFromTo _aimPosASL],10,{
	[{_this setVariable [QGVAR(hold),nil]},_this # 1,0.15] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_waitUntilAndExecute;

if (_vehicle getVariable [QGVAR(recursive),false]) exitWith {
	_vehicle setVariable [QGVAR(recursive),nil];
	true
};

// Firing event
[QGVAR(firing),[_vehicle,_area,_magazines,_rounds,_firingDelay,_ETA]] call CBA_fnc_globalEvent;

// Limit AI
private _crew = crew _vehicle;

{
	_x setVariable [QGVAR(aimingErrorAI),_x checkAIFeature "AIMINGERROR"]; _x disableAI "AIMINGERROR";
	_x setVariable [QGVAR(autoTargetAI),_x checkAIFeature "AUTOTARGET"]; _x disableAI "AUTOTARGET";
	_x setVariable [QGVAR(targetAI),_x checkAIFeature "TARGET"]; _x disableAI "TARGET";
	_x setVariable [QGVAR(pathAI),_x checkAIFeature "PATH"]; _x disableAI "PATH";
} forEach _crew;

// Gunner event handlers
_gunner setVariable [QGVAR(fired),0];
_gunner setVariable [QGVAR(EHID),[_gunner,"FiredMan",{
	params ["_gunner","","","","","","_projectile"];
	_thisArgs params ["_vehicle","_area","_magazines","_rounds","_firingDelay","_targeting","_ETA"];

	if (_vehicle getVariable [QGVAR(velocityOverride),false]) then {
		private _curVel = velocityModelSpace _projectile;
		_projectile setVelocityModelSpace [_curVel # 0,_gunner getVariable QGVAR(charge),_curVel # 2];
	};

	private _fired = (_gunner getVariable [QGVAR(fired),0]) + 1;
	_gunner setVariable [QGVAR(fired),_fired];

	if (_fired == 1) then {
		// Splash event
		[{
			if (!alive (_this # 0)) exitWith {};
			[QGVAR(splash),_this] call CBA_fnc_globalEvent;	
		},[_vehicle,_area,_magazines,_rounds,_firingDelay],_ETA - 5] call CBA_fnc_waitAndExecute;
	};

	if (_fired >= _rounds) exitWith {};

	private _target = if (_targeting in ["CREEPING_UNIFORM","CREEPING_RANDOM"]) then {
		[_area,true,_targeting isEqualTo "CREEPING_RANDOM"]
	} else {
		_area
	};

	if (count _magazines > 1) then {
		private _magIndex = (_vehicle getVariable [QGVAR(magIndex),0]) + 1;

		if (_magIndex >= count _magazines) then {
			_vehicle setVariable [QGVAR(magIndex),0];
		} else {
			_vehicle setVariable [QGVAR(magIndex),_magIndex];
		};
	};

	_gunner setVariable [QGVAR(hold),true];

	[{
		(_this # 0) setVariable [QGVAR(recursive),true];
		_this call FUNC(fire);
	},[_vehicle,_target,_magazines,_rounds],_firingDelay call EFUNC(common,randomMinMax)] call CBA_fnc_waitAndExecute;
},[_vehicle,_area,_magazines,_rounds,_firingDelay,_targeting,_ETA]] call CBA_fnc_addBISEventHandler];

// PFH to handle force firing and ending
[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_gunner","_area","_magazines","_rounds","_firingDelay","_crew"];

	if (!alive _gunner ||
		!(_gunner in _vehicle) ||
		_gunner getVariable [QGVAR(fired),0] >= _rounds ||
		_vehicle getVariable [QGVAR(abort),false]
	) exitWith {
		// Cleanup
		_PFHID call CBA_fnc_removePerFrameHandler;
		_gunner removeEventHandler ["FiredMan",_gunner getVariable [QGVAR(EHID),-1]];
		//_gunner doWatch objNull;
		//_gunner lookAt objNull;
		//_vehicle lockCameraTo [objNull,_vehicle unitTurret _gunner,true];
		//_gunner setVariable [QGVAR(hold),nil,true];
		_vehicle setVariable [QGVAR(firing),nil,true];
		_vehicle setVariable [QGVAR(recursive),nil,true];
		_vehicle setVariable [QGVAR(fireOption),nil,true];
		_vehicle setVariable [QGVAR(creepingTarget),nil,true];
		_vehicle setVariable [QGVAR(weaponDirection),nil];
		_vehicle setVariable [QGVAR(aimTick),nil];
		_vehicle setVariable [QGVAR(magIndex),nil,true];
		_vehicle setVariable [QGVAR(abort),nil,true];
		
		{
			_x enableAIFeature ["AIMINGERROR",_x getVariable QGVAR(aimingErrorAI)]; _x setVariable [QGVAR(aimingErrorAI),nil];
			_x enableAIFeature ["AUTOTARGET",_x getVariable QGVAR(autoTargetAI)]; _x setVariable [QGVAR(autoTargetAI),nil];
			_x enableAIFeature ["TARGET",_x getVariable QGVAR(targetAI)]; _x setVariable [QGVAR(targetAI),nil];
			_x enableAIFeature ["PATH",_x getVariable QGVAR(pathAI)]; _x setVariable [QGVAR(pathAI),nil];
		} forEach _crew;

		if (!alive _vehicle) exitWith {};

		// Complete event
		[QGVAR(complete),[_vehicle,_area,_magazines,_rounds,_firingDelay]] call CBA_fnc_globalEvent;
	};

	_gunner doWatch (_gunner getVariable QGVAR(aimPosATL));
	_gunner lookAt (_gunner getVariable QGVAR(aimPosATL));
	//_vehicle lockCameraTo [_gunner getVariable QGVAR(aimPosASL),_vehicle unitTurret _gunner,false];

	if (_gunner getVariable [QGVAR(hold),false]) exitWith {};

	// FIRE
	if (isNull (_vehicle getVariable [QPVAR(entity),objNull])) then {
		_vehicle setVehicleAmmo 1;
	};
	
	//weaponState [_vehicle,_vehicle unitTurret _gunner] params ["","_muzzle","_firemode"];
	//_gunner forceWeaponFire [_muzzle,_firemode];
	_gunner fireAtTarget [objNull];
},0.05,[_vehicle,_gunner,_area,_magazines,_rounds,_firingDelay,_crew]] call CBA_fnc_addPerFrameHandler;

true
