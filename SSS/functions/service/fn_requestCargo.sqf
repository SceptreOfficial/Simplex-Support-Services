#include "script_component.hpp"

//To-Do: rewrite
params ["_className","_position"];

// Start cooldown timer
SSS_vehicleDropCooldown = 240;
publicVariable "SSS_vehicleDropCooldown";
["SSS_vehicleDropCooldownTimer",[side player]] call CBA_fnc_serverEvent;

// Create aircraft
private _startDirection = floor random 360;
private _startPos = _position getPos [5000,_startDirection];
private _direction = _startPos getDir _position;
private _endPos = _position getPos [5000,_direction];
_startPos set [2,500];
_endPos set [2,500];
private _aircraftClass = ["B_T_VTOL_01_vehicle_F","RHS_C130J"] select (!isNull (configFile >> "CfgVehicles" >> "RHS_C130J"));
private _aircraft = createVehicle [_aircraftClass,_startPos,[],0,"FLY"];
_aircraft allowDamage false;
createVehicleCrew _aircraft;
_aircraft setDir _direction;
_aircraft setPos _startPos;
_aircraft allowFleeing 0;
_aircraft flyInHeight 500;
private _group = group _aircraft;
_group setBehaviour "CARELESS";
_group setCombatMode "BLUE";
_group setSpeedMode "FULL";
_aircraft setCaptive true;
_group setVariable ["SSS_vehicleDropClass",_className];

private _WP1 = _group addWaypoint [_position,0];
_WP1 setWaypointType "MOVE";
_WP1 setWaypointCompletionRadius 70;
_WP1 setWaypointStatements ["true","
	private _position = getPos (vehicle this);
	_position set [2,(_position # 2) - 40];
	private _vehicle = createVehicle [(group this) getVariable 'SSS_vehicleDropClass',_position,[],0,'NONE'];
	private _para = createVehicle ['B_Parachute_02_F',getPos _vehicle,[],0,'NONE'];
	_vehicle attachTo [_para,[0,0,abs ((boundingBox _vehicle # 0) # 2)]];
	_para setDir getDir _vehicle;
	_para setPos getPos _vehicle;
	_para setVelocity [0,0,-2];
	[_vehicle,_para] spawn {
		params ['_vehicle','_para'];
		waituntil {isNull _para || !alive _vehicle};
		_vehicle setDir getDir _vehicle;
		_vehicle setPos getPos _vehicle;
		deleteVehicle _para;
	};
"];

// Create marker
private _markerID = SSS_markers select (SSS_markers pushBack format["SSS_%1",(count SSS_markers) + 1]);
publicVariable "SSS_markers";
private _marker = createMarker [_markerID,_pos];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_end";
_marker setMarkerColor "ColorGrey";
_marker setMarkerText "Vehicle Drop Request";
_group setVariable ["SSS_marker",_marker];

private _WP2 = _group addWaypoint [_endPos,0];
_WP2 setWaypointType "MOVE";
_WP2 setWaypointCompletionRadius 100;
_WP2 setWaypointStatements ["true","
	private _vehicle = (vehicle this);
	deleteMarker ((group this) getVariable 'SSS_marker');
	{_vehicle deleteVehicleCrew _x; false} count crew _vehicle;
	deleteVehicle _vehicle;
"];

[side player,"HQ"] sideChat format["Your requested vehicle is on the way. Entering from bearing %1.",_startDirection];
