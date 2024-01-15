#include "script_component.hpp"

params ["_player","_entity","_request"];

private _class = _entity getVariable [QPVAR(class),""];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];
private _altitude = _request getOrDefault ["altitude",[2000,500] select (_class isKindOf "Helicopter")];
private _aimRange = _request getOrDefault ["range",[2600,1000] select (_class isKindOf "Helicopter")];
private _ingress = _request getOrDefault ["ingress",-1];
private _egress = _request getOrDefault ["egress",-1];

[_entity,true,"INGRESS",[LSTRING(statusStrafeIngress),RGBA_YELLOW]] call EFUNC(common,setStatus);

private _spawnDistance = _entity getVariable [QPVAR(spawnDistance),6000];
private _speed = (getNumber (configFile >> "CfgVehicles" >> _class >> "maxSpeed")) / 3.6;
private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];
private _ETADistance = [_virtualRunway distance2D _posASL,_spawnDistance] select (_virtualRunway isEqualTo [0,0,0]);
private _delay = (_entity getVariable QPVAR(spawnDelay)) call EFUNC(common,randomMinMax);
//DEBUG_1("Random delay: %1",_delay);

private _ETA = [_delay + (_ETADistance - _aimRange - 800) / _speed,10] call EFUNC(common,formatTime);
private _msg = {format [LLSTRING(notifyStrafeInbound),_this # 0 call EFUNC(common,formatGrid),_this # 1]};
NOTIFY_2(_entity,_msg,_posASL,_ETA);

_entity setVariable [QPVAR(cooldownTimer),_entity getVariable [QPVAR(cooldown),0],true];

_ingress = [random 360,_ingress] select (_ingress >= 0);
private _startPos = _virtualRunway;

if (_startPos isEqualTo [0,0,0]) then {
	_startPos = _posASL getPos [_spawnDistance,_ingress];
	_startPos set [2,_altitude];
};

if (_egress < 0) then {_egress = _startPos getDir _posASL};
private _endPos = _posASL getPos [_spawnDistance,_egress];
_endPos set [2,_altitude];

[{
	params ["_player","_entity","_request","_class","_posASL","_altitude","_aimRange","_ingress","_speed","_startPos","_endPos"];

	private _search = _request getOrDefault ["target",""];
	private _spread = _request getOrDefault ["spread",0];
	private _pylon1 = _request getOrDefault ["pylon1",[]];
	private _pylon2 = _request getOrDefault ["pylon2",[]];
	private _quantity1 = _request getOrDefault ["quantity1",0];
	private _quantity2 = _request getOrDefault ["quantity2",0];
	private _distribution1 = _request getOrDefault ["distribution1",false];
	private _distribution2 = _request getOrDefault ["distribution2",false];
	private _interval1 = _request getOrDefault ["interval1",0];
	private _interval2 = _request getOrDefault ["interval2",0];

	private _pylonConfig = [
		[_pylon1,[_quantity1,_distribution1],_interval1],
		[_pylon2,[_quantity2,_distribution2],_interval2]
	];

	private _vehicle = createVehicle [_class,_startPos,[],0,"FLY"];

	[_vehicle,_entity getVariable [QPVAR(pylons),[]]] call EFUNC(common,setPylons);

	// Some init scripts override loadouts.
	[EFUNC(common,setPylons),[_vehicle,_entity getVariable [QPVAR(pylons),[]]],3] call CBA_fnc_waitAndExecute;

	[
		_vehicle,
		_pylonConfig,
		_entity getVariable [QPVAR(infiniteAmmo),false],
		AGLtoASL _startPos # 2,
		[_aimRange,-1] select (_aimRange < 600)
	] call EFUNC(common,strafeDistance) params ["","","_prepDist"];

	if (_vehicle distance2D _posASL < _prepDist) then {
		_startPos = _posASL getPos [_prepDist,_ingress];
		_startPos set [2,_altitude];
	};

	_vehicle setDir (_ingress - 180);
	_vehicle setPos _startPos;
	_vehicle setVectorUp [0,0,1];
	_vehicle setVelocityModelSpace [0,_speed * 0.8,0];

	private _side = _entity getVariable [QPVAR(side),sideEmpty];
	private _group = _side createVehicleCrew _vehicle;
	_group deleteGroupWhenEmpty true;

	_vehicle lockDriver true;
	_group allowFleeing 0;
	_group setBehaviour "CARELESS";
	_group setCombatMode "BLUE";

	{
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
		_x disableAI "AUTOCOMBAT";
	} forEach units _group;

	[_vehicle,_entity,false] call EFUNC(common,commission);

	private _wp1 = _group addWaypoint [ASLToAGL _posASL,0];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointDescription QGVAR(strafeIngress);
	_wp1 setWaypointName QGVAR(strafeIngress);

	private _wp2 = _group addWaypoint [_endPos,0];
	_wp2 setWaypointType "MOVE";
	_wp2 setWaypointDescription QGVAR(strafeEgress);

	_group setVariable [QGVAR(strafeVehicle),_vehicle,true];
	_group addEventHandler ["WaypointComplete",{
		params ["_group","_waypointIndex"];

		private _vehicle = _group getVariable [QGVAR(strafeVehicle),objNull];

		if (!alive _vehicle) exitWith {};

		if (waypointDescription _this == QGVAR(strafeEgress)) then {
			[{
				params ["_vehicle","_group"];
				deleteVehicleCrew _vehicle;
				deleteVehicle _vehicle;
				deleteGroup _group;
			},[_vehicle,_group],3] call CBA_fnc_waitAndExecute;
		};
	}];

	_vehicle setVariable [QGVAR(strafeData),[_player,_entity,_request,AGLtoASL _startPos,_endPos],true];
	_vehicle setVariable [QEGVAR(common,strafeCountermeasures),_entity getVariable [QPVAR(countermeasures),true],true];

	[
		_vehicle,
		_posASL,
		_pylonConfig,
		_entity getVariable [QPVAR(infiniteAmmo),false],
		_spread,
		_ingress,
		[_search,nil,[_entity getVariable QPVAR(friendlyRange),0] select (_request getOrDefault ["dangerClose",false])],
		_altitude,
		[_aimRange,-1] select (_aimRange < 600)
	] call EFUNC(common,strafe);
},[_player,_entity,_request,_class,_posASL,_altitude,_aimRange,_ingress,_speed,_startPos,_endPos],_delay] call CBA_fnc_waitAndExecute;
