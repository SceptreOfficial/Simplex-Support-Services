#include "script_component.hpp"

#define LASER_TYPE ["LaserTargetE","LaserTargetW"] select (side _vehicle getFriend west > 0.6)
#define SMOKE_COLORS ["white","black","red","orange","yellow","green","blue","purple"]
#define SEARCH_RADIUS 350

params ["_entity","_selectedWeapon","_position","_approach","_signalSelection","_smokeColorSelection"];
_selectedWeapon params ["_weapon","_magazine"];

if ((_entity getVariable "SSS_cooldown") > 0) exitWith {NOTIFY_1(_entity,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_entity))};
_entity setVariable ["SSS_cooldown",_entity getVariable "SSS_cooldownDefault",true];
[_entity,"Rearmed and ready for further tasking."] call EFUNC(common,cooldown);

private _messageDetails = switch (_signalSelection) do {
	case 0 : {"Firing on map coordinates."};
	case 1 : {"Firing on laser target if found."};
	case 2 : {format ["Firing on %1 smoke if found.",SMOKE_COLORS # _smokeColorSelection]};
	case 3 : {"Firing on IR strobe if found."};
};
private _message = format ["Incoming CAS: %1 - %2",getText (configFile >> "CfgMagazines" >> _magazine >> "displayName"),_messageDetails];
NOTIFY(_entity,_message)
[_entity,true,_position] call EFUNC(common,updateMarker);

_approach = _approach * 45;
private _direction = _approach - 180;
private _startPos = _position getPos [6000,_approach];
private _endPos = _position getPos [6000,_direction];
_startPos set [2,3500];
_endPos set [2,3500];

// Create aircraft
private _vehicle = createVehicle [_entity getVariable "SSS_classname",[0,0,0],[],0,"FLY"];
(createVehicleCrew _vehicle) deleteGroupWhenEmpty true;
private _newGroup = createGroup [_entity getVariable "SSS_side",true];
crew _vehicle joinSilent _newGroup;
_entity setVariable ["SSS_physicalVehicle",_vehicle,true];
_vehicle disableAI "TARGET";
_vehicle disableAI "AUTOTARGET";
_vehicle setCombatMode "BLUE";
_vehicle setBehaviour "CARELESS";
_vehicle flyInHeight 2000;
_vehicle engineOn true;
_vehicle setDir _direction;
_vehicle setFormDir _direction;
_vehicle setPos _startPos;

// Remove weapons and add selected weapon
{_vehicle removeWeapon _x;} forEach weapons _vehicle;
_vehicle addMagazine _magazine;
_vehicle addWeapon _weapon;
private _isBomb = toLower ((_weapon call BIS_fnc_itemType) # 1) isEqualTo "bomblauncher";

private _target = (createGroup sideLogic) createUnit ["LOGIC",_position,[],0,"CAN_COLLIDE"];
_vehicle setVariable ["SSS_manualControlDone",false,true];
_vehicle setVariable ["SSS_lastPosASL",AGLtoASL _position];

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_target","_endPos"];

	if (!local _vehicle || !alive _vehicle || _vehicle distance _target < 600 || _vehicle getVariable "SSS_manualControlDone") exitWith {
		[_PFHID] call CBA_fnc_removePerFrameHandler;
		_vehicle setVariable ["SSS_manualControlDone",true,true];
		_vehicle doMove _endPos;

		[{
			params ["_vehicle","_endPos"];
			!alive _vehicle || _vehicle distance2D _endPos < 500
		},{
			params ["_vehicle"];
			if (!alive _vehicle) exitwith {};
			{_vehicle deleteVehicleCrew _x;} forEach crew _vehicle;
			deleteVehicle _vehicle;
		},[_vehicle,_endPos],120,{
			params ["_vehicle"];
			if (!alive _vehicle) exitwith {};
			{_vehicle deleteVehicleCrew _x;} forEach crew _vehicle;
			deleteVehicle _vehicle;
		}] call CBA_fnc_waitUntilAndExecute;
	};

	// Manual control
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
	_vehicle setVectorDirAndUp [_vectorDir,_vectorUp];
	_vehicle setPosWorld (_vehicle modelToWorldWorld [0,1.2,0]);
	_vehicle setVelocityModelSpace [0,120,0];
},0,[_vehicle,_target,_endPos]] call CBA_fnc_addPerFrameHandler;

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_entity","_target","_weapon","_isBomb","_signalSelection","_smokeColorSelection"];

	if (!alive _entity || !local _vehicle || !alive _vehicle || _vehicle getVariable ["SSS_fireInt",3] <= 0 || _vehicle getVariable "SSS_manualControlDone") exitwith {
		[_PFHID] call CBA_fnc_removePerFrameHandler;
		_vehicle setVariable ["SSS_manualControlDone",true,true];

		if (alive _entity && alive _vehicle && !(_vehicle getVariable ["SSS_signalFound",false])) then {
			private _cooldown = (_entity getVariable "SSS_cooldown") min ((_entity getVariable "SSS_cooldownDefault") * 0.25);
			_entity setVariable ["SSS_cooldown",_cooldown,true];
			NOTIFY_1(_entity,"No suitable signal was found. Ready for new requests in %1",PROPER_COOLDOWN(_entity))
		};

		[{
			deleteVehicle (_this # 0);
			deleteVehicle (_this # 1);
		},[_target,_vehicle getVariable ["SSS_laserTarget",objNull]],10] call CBA_fnc_waitAndExecute;

		// Countermeasures
		_vehicle addMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine",[-1]];
		_vehicle addWeaponTurret ["CMFlareLauncher",[-1]];
		[{
			[{_this forceWeaponFire ["CMFlareLauncher","Single"];},{},_this,2] call CBA_fnc_waitUntilAndExecute;
		},driver _vehicle,1] call CBA_fnc_waitAndExecute;

		if (!alive _entity) exitWith {};
		[_entity,false] call EFUNC(common,updateMarker);
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
		private _laserTarget = if (isNull (_vehicle getVariable ["SSS_laserTarget",objNull])) then {
			private _laserTarget = createVehicle [LASER_TYPE,_target,[],0,"NONE"];
			_laserTarget attachTo [_target,[0,0,random 5]];
			_vehicle setVariable ["SSS_laserTarget",_laserTarget];
			_laserTarget
		} else {
			_vehicle getVariable "SSS_laserTarget"
		};

		_vehicle reveal (laserTarget _laserTarget);
		_vehicle doWatch (laserTarget _laserTarget);
		_vehicle doTarget (laserTarget _laserTarget);
		(driver _vehicle) fireAtTarget [_laserTarget,_weapon];

		if (_isBomb) then {
			_vehicle setVariable ["SSS_fireInt",0];
			_vehicle setVariable ["SSS_manualControlDone",true,true];
		} else {
			_vehicle setVariable ["SSS_fireInt",(_vehicle getVariable ["SSS_fireInt",3]) - 0.2];
		};
	};
},0.2,[_vehicle,_entity,_target,_weapon,_isBomb,_signalSelection,_smokeColorSelection]] call CBA_fnc_addPerFrameHandler;
