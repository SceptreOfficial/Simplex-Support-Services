#include "script_component.hpp"

#define LASER_TYPE ["LaserTargetE","LaserTargetW"] select (side _vehicle getFriend west > 0.6)
#define SMOKE_COLORS ["white","black","red","orange","yellow","green","blue","purple"]
#define SEARCH_RADIUS 350
#define DIRECTIONS ["N","NE","E","SE","S","SW","W","NW"]

params ["_entity","_selectedWeapon","_position","_approachDirection","_signalSelection","_smokeColorSelection"];
_selectedWeapon params ["_weapon","_magazine"];

if (isNull _entity) exitwith {};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(requestCASPlane),2];
};

if ((_entity getVariable "SSS_cooldown") > 0) exitWith {
	NOTIFY_1(_entity,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_entity));
};

[_entity,_entity getVariable "SSS_cooldownDefault","Rearmed and ready for further tasking."] call FUNC(cooldown);

private _messageDetails = switch (_signalSelection) do {
	case 0 : {format ["Firing %1 on map coordinates.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]};
	case 1 : {format ["Will fire %1 at laser target.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]};
	case 2 : {format ["Will fire %1 at %2 smoke.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName"),SMOKE_COLORS # _smokeColorSelection]};
	case 3 : {format ["Will fire %1 at IR strobe.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]};
};

private _message = format ["%1 from %2. ETA 45s. %3",mapGridPosition _position,DIRECTIONS # _approachDirection,_messageDetails];
NOTIFY(_entity,_message);

[_entity,true,_position] call FUNC(updateMarker);

_approachDirection = _approachDirection * 45;
private _direction = _approachDirection - 180;
private _startPos = _position getPos [6000,_approachDirection];
private _endPos = _position getPos [6000,_direction];
_startPos set [2,3500];
_endPos set [2,3500];

// Create vehicle
private _vehicle = createVehicle [_entity getVariable "SSS_classname",[0,0,0],[],0,"FLY"];
(createVehicleCrew _vehicle) deleteGroupWhenEmpty true;
private _group = createGroup [_entity getVariable "SSS_side",true];
crew _vehicle joinSilent _group;
_vehicle allowFleeing 0;
_vehicle setBehaviour "CARELESS";
_vehicle setCombatMode "BLUE";
{
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
} forEach crew _vehicle;
_vehicle lockDriver true;
_vehicle engineOn true;
_vehicle flyInHeight 2000;
_vehicle setDir _direction;
_vehicle setFormDir _direction;
_vehicle setPos _startPos;

_vehicle setVariable ["SSS_parentEntity",_entity,true];
_entity setVariable ["SSS_vehicle",_vehicle,true];
_group setVariable ["SSS_protectWaypoints",true,true];

// Clear all weapons and add selected weapon
{_vehicle removeMagazine _x} forEach magazines _vehicle;
{_vehicle removeWeapon _x} forEach weapons _vehicle;
_vehicle addMagazine _magazine;
_vehicle addWeapon _weapon;
private _weaponType = toLower ((_weapon call BIS_fnc_itemType) # 1);

private _target = (createGroup sideLogic) createUnit ["Logic",_position,[],0,"CAN_COLLIDE"];
_vehicle setVariable ["SSS_manualControlDone",false,true];
_vehicle setVariable ["SSS_lastPosASL",AGLToASL _position];

private _vectorDir = getPosASL _vehicle vectorFromTo getPosASL _target;
private _vectorUp = _vectorDir vectorCrossProduct [-(_vectorDir # 1),_vectorDir # 0,0];

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_target","_endPos","_manualControlArgs"];
	_manualControlArgs params [
		"_startPositionASL",
		"_startVelocity",
		"_startVectorDir",
		"_startVectorUp",
		"_timeStart",
		"_timeEnd"
	];

	private _interval = linearConversion [_timeStart,_timeEnd,CBA_missionTime,0,1];

	if (_interval > 1 || !local _vehicle || !alive _vehicle || _vehicle distance _target < 600 || _vehicle getVariable "SSS_manualControlDone") exitWith {
		[_PFHID] call CBA_fnc_removePerFrameHandler;

		if (!alive _vehicle) exitwith {};

		_vehicle setVariable ["SSS_manualControlDone",true,true];
		_vehicle doMove _endPos;

		[{
			params ["_vehicle","_endPos"];
			!alive _vehicle || _vehicle distance2D _endPos < 500
		},{
			params ["_vehicle"];
			if (!alive _vehicle) exitwith {};
			{_vehicle deleteVehicleCrew _x} forEach crew _vehicle;
			deleteVehicle _vehicle;
		},[_vehicle,_endPos],120,{
			params ["_vehicle"];
			if (!alive _vehicle) exitwith {};
			{_vehicle deleteVehicleCrew _x} forEach crew _vehicle;
			deleteVehicle _vehicle;
		}] call CBA_fnc_waitUntilAndExecute;
	};

	private _targetPosASL = getPosASL _target;
	private _lastPosASL = _vehicle getVariable "SSS_lastPosASL";
	private _distance = _lastPosASL distance _targetPosASL;
	if (_distance > 0.1) then {
		private _newPos = _lastPosASL getPos [_distance min 2,_lastPosASL getDir _targetPosASL];
		_targetPosASL = [_newPos # 0,_newPos # 1,_targetPosASL # 2];
	};

	_vehicle setVariable ["SSS_lastPosASL",_targetPosASL];

	private _vectorDir = getPosASL _vehicle vectorFromTo _targetPosASL;
	private _vectorUp = _vectorDir vectorCrossProduct [-(_vectorDir # 1),_vectorDir # 0,0];

	_vehicle setVelocityTransformation [
		_startPositionASL,_targetPosASL,
		_startVelocity,[0,0,0],
		_startVectorDir,_vectorDir,
		_startVectorUp,_vectorUp,
		_interval
	];

	_vehicle setVelocityModelSpace [0,130,0];
},0,[_vehicle,_target,_endPos,[
	getPosASL _vehicle,
	velocity _vehicle,
	_vectorDir,
	_vectorUp,
	CBA_missionTime,
	CBA_missionTime + 45
]]] call CBA_fnc_addPerFrameHandler;

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_entity","_target","_weapon","_weaponType","_signalSelection","_smokeColorSelection"];

	if (isNull _entity || !local _vehicle || !alive _vehicle || _vehicle getVariable ["SSS_fireInt",3] <= 0 || _vehicle getVariable "SSS_manualControlDone") exitwith {
		[_PFHID] call CBA_fnc_removePerFrameHandler;
		_vehicle setVariable ["SSS_manualControlDone",true,true];

		if (!isNull _entity && alive _vehicle && !(_vehicle getVariable ["SSS_signalFound",false])) then {
			private _cooldown = (_entity getVariable "SSS_cooldown") min ((_entity getVariable "SSS_cooldownDefault") * 0.25);
			_entity setVariable ["SSS_cooldown",_cooldown,true];
			NOTIFY_1(_entity,"No suitable signal was found. Ready for new requests in %1",PROPER_COOLDOWN(_entity));
		};

		[{{deleteVehicle _x} forEach _this},[_target,_vehicle getVariable ["SSS_laserTarget",objNull]],10] call CBA_fnc_waitAndExecute;

		// Countermeasures
		_vehicle addMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine",[-1]];
		_vehicle addWeaponTurret ["CMFlareLauncher",[-1]];
		[{
			[{_this forceWeaponFire ["CMFlareLauncher","Single"]; false},{},_this,2] call CBA_fnc_waitUntilAndExecute;
		},driver _vehicle,1] call CBA_fnc_waitAndExecute;

		if (isNull _entity) exitWith {};

		[_entity,false] call FUNC(updateMarker);
	};

	private _distance = _vehicle distance _target;

	// Find / Select target signal
	if (!(_vehicle getVariable ["SSS_signalFound",false]) && _distance < 2500) then {
		private _signal = switch (_signalSelection) do {
			case 0 : {_target};
			case 1 : {selectRandom (_target nearEntities [LASER_TYPE,SEARCH_RADIUS])};
			case 2 : {
				private _smokeColor = SMOKE_COLORS # _smokeColorSelection;
				selectRandom ((_target nearObjects ["SmokeShell",SEARCH_RADIUS]) select {(_x call FUNC(getSmokeColor)) isEqualTo _smokeColor})
			};
			case 3 : {selectRandom (_target nearObjects ["IRStrobeBase",SEARCH_RADIUS])};
		};

		if (isNil "_signal") exitWith {};
		_vehicle setVariable ["SSS_signal",_signal];
		_vehicle setVariable ["SSS_signalFound",true];
	};

	private _signal = _vehicle getVariable ["SSS_signal",objNull];

	// Update target position
	if (!isNull _signal) then {
		_target setPos (getPos _signal);
		_target setVectorUp [0,0,1];
	};

	// Fire on target
	if (_distance < 1200 && _vehicle getVariable ["SSS_signalFound",false]) then {
		private _laserTarget = if (isNull (_vehicle getVariable ["SSS_laserTarget",objNull])) then {
			private _laserTarget = createVehicle [LASER_TYPE,_target,[],0,"NONE"];
			if (_weaponType isEqualTo "rocketlauncher") then {
				_laserTarget attachTo [_target,[0,0,5 + random 5]];
			} else {
				_laserTarget attachTo [_target,[0,0,random 5]];
			};
			_vehicle setVariable ["SSS_laserTarget",_laserTarget];
			_laserTarget
		} else {
			_vehicle getVariable "SSS_laserTarget"
		};

		_vehicle reveal (laserTarget _laserTarget);
		_vehicle doWatch (laserTarget _laserTarget);
		_vehicle doTarget (laserTarget _laserTarget);
		(driver _vehicle) fireAtTarget [_laserTarget,_weapon];

		if (_weaponType isEqualTo "bomblauncher") then {
			_vehicle setVariable ["SSS_fireInt",0];
			_vehicle setVariable ["SSS_manualControlDone",true,true];
		} else {
			_vehicle setVariable ["SSS_fireInt",(_vehicle getVariable ["SSS_fireInt",3]) - 0.2];
		};
	};
},0.2,[_vehicle,_entity,_target,_weapon,_weaponType,_signalSelection,_smokeColorSelection]] call CBA_fnc_addPerFrameHandler;
