#include "script_component.hpp"

params ["_entity","_position","_loiterRadius","_loiterAltitude"];

if (isNull _entity) exitwith {};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(requestCASGunship),2];
};

if ((_entity getVariable "SSS_cooldown") > 0) exitWith {
	NOTIFY_NOT_READY_COOLDOWN(_entity);
};

["SSS_requestSubmitted",[_entity,[_position,_loiterRadius,_loiterAltitude]]] call CBA_fnc_globalEvent;

NOTIFY(_entity,localize LSTRING(GunshipOnTheWay));

// Update task marker
[_entity,true,_position] call EFUNC(common,updateMarker);

// Create vehicle
private _startPosition = _position getPos [6000,floor random 360];
private _altitudeASL = (AGLToASL _position # 2) + _loiterAltitude;
private _vehicle = createVehicle [_entity getVariable "SSS_classname",_startPosition,[],0,"FLY"];
(createVehicleCrew _vehicle) deleteGroupWhenEmpty true;
private _group = createGroup [_entity getVariable "SSS_side",true];
crew _vehicle joinSilent _group;
_vehicle setDir (_startPosition getDir _position);
_vehicle setPos [_startPosition # 0,_startPosition # 1,_altitudeASL];
_vehicle setVelocityModelSpace [0,150,0];
_vehicle allowFleeing 0;
_vehicle setBehaviour "CARELESS";
_vehicle setCombatMode "BLUE";
{
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
} forEach crew _vehicle;
_vehicle lockDriver true;
_vehicle setVariable ["SSS_parentEntity",_entity,true];
_entity setVariable ["SSS_vehicle",_vehicle,true];
_group setVariable ["SSS_protectWaypoints",true,true];

// Add 40mm to the primary gunner on blackfish
if (typeOf _vehicle == "B_T_VTOL_01_armed_F") then {
	_vehicle addMagazineTurret ["240Rnd_40mm_GPR_Tracer_Red_shells",[1]];
	_vehicle addMagazineTurret ["160Rnd_40mm_APFSDS_Tracer_Red_shells",[1]];
	_vehicle addWeaponTurret ["autocannon_40mm_VTOL_01",[1]];
};

// Lock Control
_vehicle lockTurret [[1],true];

// Move towards loiter area
_entity setVariable ["SSS_active",true,true];
_entity setVariable ["SSS_requestParameters",[_position,_loiterRadius,_loiterAltitude],true];

_vehicle setVariable ["SSS_WPDone",false];
private _WP = _group addWaypoint [_position getPos [_loiterRadius,(_position getDir _startPosition) - 45],0];
_WP setWaypointType "MOVE";
_WP setWaypointSpeed "FULL";
_WP setWaypointCompletionRadius 200;
_WP setWaypointStatements ["true","(vehicle this) setVariable ['SSS_WPDone',true];"];
_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];

[{
	params ["_entity","_vehicle"];

	isNull _entity || !alive _vehicle || {_vehicle getVariable "SSS_WPDone"}
},{
	params ["_entity","_vehicle","_altitudeASL","_position","_loiterRadius","_loiterAltitude"];

	if (isNull _entity) exitwith {};
	if (!alive _vehicle) exitwith {
		_entity setVariable ["SSS_active",false,true];
		[_entity,false] call EFUNC(common,updateMarker);
		[_entity,_entity getVariable "SSS_cooldownDefault",localize LSTRING(RearmedAndReady)] call EFUNC(common,cooldown);
	};

	// Unlock control
	_vehicle lockTurret [[1],false];

	// Loiter
	private _WP = (group _vehicle) addWaypoint [_position,0];
	_WP setWaypointType "LOITER";
	_WP setWaypointLoiterType "CIRCLE_L";
	_WP setWaypointLoiterRadius _loiterRadius;
	_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];

	NOTIFY(_entity,localize LSTRING(GunshipInRequestedArea));

	_entity setVariable ["SSS_loitering",true,true];

	[{
		params ["_entity","_vehicle","_altitudeASL"];

		_vehicle flyInHeightASL [_altitudeASL,_altitudeASL,_altitudeASL];

		isNull _entity || !alive _vehicle
	},{
		params ["_entity"];

		if (isNull _entity) exitwith {};

		_entity setVariable ["SSS_active",false,true];
		_entity setVariable ["SSS_loitering",false,true];

		[_entity,false] call EFUNC(common,updateMarker);

		[_entity,_entity getVariable "SSS_cooldownDefault",localize LSTRING(RearmedAndReady)] call EFUNC(common,cooldown);

		NOTIFY(_entity,localize LSTRING(GunshipDestroyed));
	},_this,_entity getVariable "SSS_loiterTime",{
		params ["_entity","_vehicle","_altitudeASL","_position","_loiterRadius","_loiterAltitude","_startPosition"];

		// Send vehicle back to start position to de-spawn
		private _group = group _vehicle;
		{deleteWaypoint [_group,0]} forEach (waypoints _group);

		private _WP = _group addWaypoint [_startPosition,0];
		_WP setWaypointType "MOVE";
		_WP setWaypointCompletionRadius 100;
		_WP setWaypointStatements ["true","
			private _vehicle = vehicle this;
			{_vehicle deleteVehicleCrew _x} forEach crew _vehicle;
			deleteVehicle _vehicle;
		"];
		_group setCurrentWaypoint _WP;
		_vehicle doFollow _vehicle;

		// Fly at correct altitude
		[{
			params ["_vehicle","_altitude"];
			_vehicle flyInHeight _altitude;
		},[_vehicle,getPosATL _vehicle # 2],1] call CBA_fnc_waitAndExecute;

		// Lock gunner
		_vehicle lockTurret [[0],false];

		if (isNull _entity) exitwith {};

		_entity setVariable ["SSS_active",false,true];
		_entity setVariable ["SSS_loitering",false,true];

		[_entity,false] call EFUNC(common,updateMarker);

		[_entity,_entity getVariable "SSS_cooldownDefault",localize LSTRING(RearmedAndReady)] call EFUNC(common,cooldown);

		NOTIFY_1(_entity,localize LSTRING(GunshipIsLeaving),PROPER_COOLDOWN(_entity));

		["SSS_requestCompleted",[_entity]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_waitUntilAndExecute;
},[_entity,_vehicle,_altitudeASL,_position,_loiterRadius,_loiterAltitude,_startPosition]] call CBA_fnc_waitUntilAndExecute;

// Execute custom code
_vehicle call (_entity getVariable "SSS_customInit");
