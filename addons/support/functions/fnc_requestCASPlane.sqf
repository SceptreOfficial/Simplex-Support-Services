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
	NOTIFY_NOT_READY_COOLDOWN(_entity);
};

["SSS_requestSubmitted",[_entity,[_selectedWeapon,_position,_approachDirection,_signalSelection,_smokeColorSelection]]] call CBA_fnc_globalEvent;

[_entity,_entity getVariable "SSS_cooldownDefault","Rearmed and ready for further tasking."] call EFUNC(common,cooldown);

// Notify
private _message = format ["%1 from %2. ETA 45s. %3",mapGridPosition _position,DIRECTIONS # _approachDirection,switch (_signalSelection) do {
	case 0 : {format ["Firing %1 on map coordinates.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]};
	case 1 : {format ["Will fire %1 at laser target.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]};
	case 2 : {format ["Will fire %1 at %2 smoke.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName"),SMOKE_COLORS # _smokeColorSelection]};
	case 3 : {format ["Will fire %1 at IR strobe.",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]};
}];

NOTIFY(_entity,_message);

// Update task martker
[_entity,true,_position] call EFUNC(common,updateMarker);

// Define approach parameters
_approachDirection = _approachDirection * 45;
private _direction = _approachDirection - 180;
private _startPos = _position getPos [7000,_approachDirection];
private _endPos = _position getPos [5000,_direction];
_startPos set [2,3500];
_endPos set [2,3500];

// Create vehicle/AI
private _vehicle = createVehicle [_entity getVariable "SSS_classname",[0,0,0],[],0,"FLY"];
(createVehicleCrew _vehicle) deleteGroupWhenEmpty true;
private _group = createGroup [_entity getVariable "SSS_side",true];
crew _vehicle joinSilent _group;

// Setup vehicle/AI
_vehicle allowFleeing 0;
_vehicle setBehaviour "CARELESS";
_vehicle setCombatMode "BLUE";
{_x disableAI "AUTOTARGET"} forEach crew _vehicle;

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

// Create target logic
private _target = (createGroup sideLogic) createUnit ["Logic",_position,[],0,"CAN_COLLIDE"];
_vehicle setVariable ["SSS_manualControlDone",false,true];
_vehicle setVariable ["SSS_lastPosASL",AGLToASL _position];

// Prep manual control
private _vectorDir = getPosASL _vehicle vectorFromTo getPosASL _target;
private _vectorUp = _vectorDir vectorCrossProduct [-(_vectorDir # 1),_vectorDir # 0,0];
private _offset = switch (_weaponType) do {
	case "rocketlauncher" : {5};
	case "missilelauncher" : {12};
	default {0};
};

// Manual control PFH
[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_target","_endPos","_startPositionASL","_startVelocity","_startVectorDir","_startVectorUp","_timeStart","_timeEnd","_offset"];

	private _interval = linearConversion [_timeStart,_timeEnd,CBA_missionTime,0,1];

	if (_interval > 1 || !local _vehicle || !alive _vehicle || !alive driver _vehicle || {_vehicle distance _target < 600 || _vehicle getVariable "SSS_manualControlDone"}) exitWith {
		[_PFHID] call CBA_fnc_removePerFrameHandler;

		if (!alive _vehicle) exitwith {};
		
		_vehicle setVariable ["SSS_manualControlDone",true,true];
		
		// Return to origin and de-spawn
		_vehicle setVariable ["SSS_WPDone",false];
		private _WP = group _vehicle addWaypoint [_endPos,0];
		_WP setWaypointType "Move";
		_WP setWaypointStatements WP_DONE;

		private _endCode = {
			if (!alive _this) exitwith {};
			{_this deleteVehicleCrew _x} forEach crew _this;
			deleteVehicle _this;
		};

		[{!alive _this || !alive driver _this || _this getVariable "SSS_WPDone"},_endCode,_vehicle,120,_endCode] call CBA_fnc_waitUntilAndExecute;
	};

	private _targetPosASL = getPosASLVisual _target;
	_targetPosASL set [2,_targetPosASL # 2 + _offset];
	private _lastPosASL = _vehicle getVariable "SSS_lastPosASL";
	private _distance = _lastPosASL distance _targetPosASL;

	// Track target logic
	if (_distance > 0.1) then {
		private _newPos = _lastPosASL getPos [_distance min 2,_lastPosASL getDir _targetPosASL];
		_targetPosASL = [_newPos # 0,_newPos # 1,_targetPosASL # 2 + _offset];
	};

	_vehicle setVariable ["SSS_lastPosASL",_targetPosASL];

	private _vectorDir = getPosASLVisual _vehicle vectorFromTo _targetPosASL;
	private _vectorUp = _vectorDir vectorCrossProduct [-(_vectorDir # 1),_vectorDir # 0,0];

	_vehicle setVelocityTransformation [
		_startPositionASL,_targetPosASL,
		_startVelocity,[0,0,0],
		_startVectorDir,_vectorDir,
		_startVectorUp,_vectorUp,
		_interval
	];

	_vehicle setVelocityModelSpace [0,120,0];
},0,[_vehicle,_target,_endPos,getPosASL _vehicle,velocity _vehicle,_vectorDir,_vectorUp,CBA_missionTime,CBA_missionTime + 65,_offset]] call CBA_fnc_addPerFrameHandler;

// Firing 0.2s PFH
[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_entity","_target","_weapon","_weaponType","_signalSelection","_smokeColorSelection"];

	if (isNull _entity || !local _vehicle || !alive _vehicle || !alive driver _vehicle || {_vehicle getVariable ["SSS_fireProgress",3] <= 0 || _vehicle getVariable "SSS_manualControlDone"}) exitwith {
		[_PFHID] call CBA_fnc_removePerFrameHandler;
		
		if (!isNull _entity) then {
			[_entity,false] call EFUNC(common,updateMarker);
			["SSS_requestCompleted",[_entity]] call CBA_fnc_globalEvent;
		};

		if (!alive _vehicle) exitWith {};

		_vehicle setVariable ["SSS_manualControlDone",true,true];

		// Only do 1/4 of the cooldown time if no target was found
		if (!isNull _entity && !(_vehicle getVariable ["SSS_signalFound",false])) then {
			private _cooldown = (_entity getVariable "SSS_cooldown") min ((_entity getVariable "SSS_cooldownDefault") * 0.25);
			_entity setVariable ["SSS_cooldown",_cooldown,true];
			NOTIFY_1(_entity,"No suitable signal was found. Ready for new requests in %1",PROPER_COOLDOWN(_entity));
		};

		// Delete targets
		[{{deleteVehicle _x} forEach _this},[_target,_vehicle getVariable ["SSS_laserTarget",objNull]],10] call CBA_fnc_waitAndExecute;

		// Countermeasures
		_vehicle addMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine",[-1]];
		_vehicle addWeaponTurret ["CMFlareLauncher",[-1]];
		[{
			[{_this forceWeaponFire ["CMFlareLauncher","Single"]; false},{},_this,2] call CBA_fnc_waitUntilAndExecute;
		},driver _vehicle,1 + random 3] call CBA_fnc_waitAndExecute;
	};

	private _distance = _vehicle distance _target;

	// Find / Select target signal
	if (!(_vehicle getVariable ["SSS_signalFound",false]) && _distance < 2500) then {
		private _signal = switch (_signalSelection) do {
			case 0 : {_target};
			case 1 : {selectRandom (_target nearEntities [LASER_TYPE,SEARCH_RADIUS])};
			case 2 : {
				private _smokeColor = SMOKE_COLORS # _smokeColorSelection;
				selectRandom ((_target nearObjects ["SmokeShell",SEARCH_RADIUS]) select {(_x call EFUNC(common,getSmokeColor)) isEqualTo _smokeColor})
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
		private _laserTarget = _vehicle getVariable ["SSS_laserTarget",objNull];
		
		if (isNull _laserTarget) then {
			_laserTarget = createVehicle [LASER_TYPE,_target,[],0,"NONE"];
			_laserTarget attachTo [_target,[0,0,1]];
			_vehicle setVariable ["SSS_laserTarget",_laserTarget];
			_laserTarget
		};

		_vehicle reveal (laserTarget _laserTarget);
		_vehicle doWatch (laserTarget _laserTarget);
		_vehicle doTarget (laserTarget _laserTarget);
		(driver _vehicle) fireAtTarget [_laserTarget,_weapon];

		if (_weaponType isEqualTo "bomblauncher") then {
			_vehicle setVariable ["SSS_fireProgress",0];
			_vehicle setVariable ["SSS_manualControlDone",true,true];
		} else {
			_vehicle setVariable ["SSS_fireProgress",(_vehicle getVariable ["SSS_fireProgress",3]) - 0.2];
		};
	};
},0.2,[_vehicle,_entity,_target,_weapon,_weaponType,_signalSelection,_smokeColorSelection]] call CBA_fnc_addPerFrameHandler;

// Execute custom code
_vehicle call (_entity getVariable "SSS_customInit");
