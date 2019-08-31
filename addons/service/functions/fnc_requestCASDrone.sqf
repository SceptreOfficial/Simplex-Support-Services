#include "script_component.hpp"

params ["_entity","_position"];

if ((_entity getVariable "SSS_cooldown") > 0) exitWith {NOTIFY_1(_entity,"<t color='#f4ca00'>NOT READY.</t> Ready in %1.",PROPER_COOLDOWN(_entity))};

NOTIFY(_entity,"UAV is on the way and will signal on arrival.")
[_entity,true,_position] call EFUNC(common,updateMarker);
_entity setVariable ["SSS_activeInArea",true,true];

private _startDirection = floor random 360;
private _startPos = _position getPos [5000,_startDirection];
private _direction = _startPos getDir _position;
private _class = _entity getVariable "SSS_classname";
private _height = (AGLToASL _position # 2) + 1000;

// Create UAV
private _vehicle = createVehicle [_class,_startPos,[],0,"FLY"];
(createVehicleCrew _vehicle) deleteGroupWhenEmpty true;
private _newGroup = createGroup [_entity getVariable "SSS_side",true];
crew _vehicle joinSilent _newGroup;
_entity setVariable ["SSS_physicalVehicle",_vehicle,true];
_vehicle setDir _direction;
_vehicle setPosASL [_startPos # 0,_startPos # 1,_height];
_vehicle setVelocityModelSpace [0,80,0];
_vehicle allowFleeing 0;
_vehicle setBehaviour "CARELESS";
_vehicle setCombatMode "BLUE";
{
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
} forEach crew _vehicle;
_vehicle lockDriver true;

[_vehicle,false] remoteExecCall [QFUNC(CASDroneConnectTerminal),0,_vehicle];

_vehicle setVariable ["SSS_WPDone",false];
private _WPPosition = _position getPos [1000,(_position getDir _vehicle) - 90];
private _WP = (group _vehicle) addWaypoint [_WPPosition,0];
_WP setWaypointType "MOVE";
_WP setWaypointStatements ["true","(vehicle this) setVariable ['SSS_WPDone',true];"];
_vehicle doMove _WPPosition;
_vehicle flyInHeightASL [_height,_height,_height];

[{
	params ["_vehicle","_entity"];
	!alive _entity || {_vehicle getVariable "SSS_WPDone" || !alive _vehicle || _vehicle distance2D (_this # 5) < 200}
},{
	params ["_vehicle","_entity","_position","_startPos","_height"];

	if (!alive _entity) exitwith {};
	if (!alive _vehicle) exitwith {
		_entity setVariable ["SSS_activeInArea",false,true];
		[_entity,false] call EFUNC(common,updateMarker);
		_entity setVariable ["SSS_cooldown",_entity getVariable "SSS_cooldownDefault",true];
		[_entity,"Rearmed and ready for further tasking."] call EFUNC(common,cooldown);
	};
	[_vehicle,true] remoteExecCall [QFUNC(CASDroneConnectTerminal),0,_vehicle];
	NOTIFY(_entity,"UAV is in the requested area. Connect via UAV Terminal.")

	// Prep manual control
	private _targetPosASL = [_position # 0,_position # 1,_height];
	private _target = (createGroup sideLogic) createUnit ["LOGIC",_position,[],0,"CAN_COLLIDE"];
	_target setPosASL _targetPosASL;
	private _targetVector = getPosASL _vehicle vectorFromTo _targetPosASL;
	private _vectorDirAndUp = [([[_targetVector # 0,_targetVector # 1],-90] call BIS_fnc_rotateVector2D) + [0],[-0.3,0,0.7]];
	_vehicle setVectorDirAndUp _vectorDirAndUp;
	_target setVectorDir (_vectorDirAndUp # 0);
	_vehicle attachTo [_target];
	_vehicle setVectorUp (_vectorDirAndUp # 1);
	_entity setVariable ["SSS_loitering",true,true];

	[{
		params ["_vehicle","_entity","_position","_startPos","_target"];

		// Manual control
		private _vectorDir = vectorDirVisual _vehicle;
		_target setVectorDirAndUp [([[_vectorDir # 0,_vectorDir # 1],0.3] call BIS_fnc_rotateVector2D) + [0],[0,0,1]];
		_vehicle setVelocityModelSpace [0,80,0];

		!alive _entity || !alive _vehicle || !alive _target
	},{
		params ["_vehicle","_entity"];

		if (!alive _entity) exitwith {};
		_entity setVariable ["SSS_activeInArea",false,true];
		_entity setVariable ["SSS_loitering",false,true];
		[_entity,false] call EFUNC(common,updateMarker);
		_entity setVariable ["SSS_cooldown",_entity getVariable "SSS_cooldownDefault",true];
		[_entity,"Rearmed and ready for further tasking."] call EFUNC(common,cooldown);
	},[_vehicle,_entity,_position,_startPos,_target],_entity getVariable "SSS_loiterTime",{
		params ["_vehicle","_entity","_position","_startPos","_target"];

		detach _vehicle;
		_vehicle setVelocityModelSpace [0,80,0];
		deleteVehicle _target;

		private _group = group _vehicle;
		{deleteWaypoint [_group,0]; false} count (waypoints _group);
		private _WP = _group addWaypoint [_startPos,0];
		_WP setWaypointType "MOVE";
		_WP setWaypointCompletionRadius 100;
		_WP setWaypointStatements ["true","
			private _vehicle = vehicle this;
			{_vehicle deleteVehicleCrew _x;} forEach crew _vehicle;
			deleteVehicle _vehicle;
		"];
		_group setCurrentWaypoint _WP;
		_vehicle doFollow _vehicle;

		if (!alive _entity) exitwith {};
		_entity setVariable ["SSS_activeInArea",false,true];
		_entity setVariable ["SSS_loitering",false,true];
		[_entity,false] call EFUNC(common,updateMarker);
		_entity setVariable ["SSS_cooldown",_entity getVariable "SSS_cooldownDefault",true];
		[_entity,"Rearmed and ready for further tasking."] call EFUNC(common,cooldown);

		NOTIFY_1(_entity,"UAV is leaving the area. UAV support will be available again in %1.",PROPER_COOLDOWN(_entity))
	}] call CBA_fnc_waitUntilAndExecute;
},[_vehicle,_entity,_position,_startPos,_height,_WPPosition]] call CBA_fnc_waitUntilAndExecute;
