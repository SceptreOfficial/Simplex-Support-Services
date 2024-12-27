#include "..\script_component.hpp"

params [
	["_pos",[0,0,0],[[]],3],
	["_dir",0,[0]],
	["_distance",4000,[0]],
	["_height",500,[0]],
	["_class","",["",[]]],
	["_offset",0,[0]],
	["_scriptedWaypoint",[],[[],""]],
	["_startPos",[0,0,0],[[]],3]
];

_class params [["_class","",[""]],["_side",sideEmpty,[sideEmpty]]];

if (_class isEqualTo "") then {
	_class = "C_Plane_Civil_01_F";
};

_distance = _distance max 100;

if (_startPos isEqualTo [0,0,0]) then {
	_startPos = _pos getPos [_distance,_dir - 180];
	_startPos set [2,_height];
} else {
	_dir = _startPos getDir _pos;
};

private _endPos = _pos getPos [_distance,_dir];
_endPos set [2,_height];

_pos = _pos getPos [_offset,_dir - 180];

private _vehicle = createVehicle [_class,_startPos,[],0,"FLY"];
_vehicle setDir _dir;
_vehicle setPos _startPos;
_vehicle setVectorUp [0,0,1];
_vehicle setVelocityModelSpace [0,getNumber (configOf _vehicle >> "maxSpeed") / 3.6,0];

private _group = if (_side in [west,east,independent,civilian]) then {
	_side createVehicleCrew _vehicle;
} else {
	private _group = createVehicleCrew _vehicle;
	_group deleteGroupWhenEmpty true;
	_group addVehicle _vehicle;
	_group
};

_vehicle flyInHeight _height;
_vehicle lockDriver true;
_group allowFleeing 0;
_group setBehaviour "CARELESS";
_group setCombatMode "BLUE";
//_group call FUNC(AICompat);

{
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
	_x disableAI "AUTOCOMBAT";
} forEach units _group;

_group setVariable [QGVAR(flybyVehicle),_vehicle,true];

if !(_scriptedWaypoint in [[],""]) then {
	_scriptedWaypoint params [["_script","",[""]],["_args",[],[[]]]];

	private _wp1 = _group addWaypoint [_pos,0];
	_wp1 setWaypointType "SCRIPTED";
	_wp1 setWaypointScript format ["%1 %2",_script,_args];
	_wp1 setWaypointPosition [ATLToASL _pos,-1];
	_wp1 setWaypointDescription QGVAR(flyby1);
} else {
	private _wp1 = _group addWaypoint [_pos,0];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointDescription QGVAR(flyby1);
};

private _wp2 = _group addWaypoint [ASLToAGL _endPos,0];
_wp2 setWaypointType "MOVE";
_wp2 setWaypointDescription QGVAR(flyby2);
_wp2 setWaypointStatements [QUOTE(!(group this getVariable [ARR_2(QQGVAR(flybyHold),false)])),""];

_group addEventHandler ["WaypointComplete",{
	params ["_group","_waypointIndex"];

	private _vehicle = _group getVariable [QGVAR(flybyVehicle),objNull];

	if (!alive _vehicle) exitWith {};

	if (waypointDescription _this == QGVAR(flyby1)) then {
		[QGVAR(flybyPosReached),[_vehicle]] call CBA_fnc_globalEvent;	
	};

	if (waypointDescription _this == QGVAR(flyby2)) then {
		[QGVAR(flybyEnd),[_vehicle]] call CBA_fnc_globalEvent;

		[{
			[{
				params ["_vehicle","_group"];
				_group getVariable [QGVAR(flybyDelete),true]
			},{
				params ["_vehicle","_group"];

				private _cargo = _vehicle getVariable [QEGVAR(common,slingloadCargo),objNull];
				[_vehicle,objNull] call FUNC(slingload);

				deleteVehicleCrew _cargo;
				deleteVehicle _cargo;

				deleteVehicleCrew _vehicle;
				deleteVehicle _vehicle;
				deleteGroup _group;
			},_this] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_group],3] call CBA_fnc_waitAndExecute;
	};
}];

_vehicle addEventHandler ["Killed",{
	params ["_vehicle"];
	[QGVAR(flybyKilled),[_vehicle]] call CBA_fnc_globalEvent;
}];

[QGVAR(flybyStart),[_vehicle]] call CBA_fnc_globalEvent;

_vehicle