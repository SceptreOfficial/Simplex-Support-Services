#include "script_component.hpp"

params ["_player","_entity","_request"];

private _selection = _request getOrDefault ["selection",[]];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];
private _signals = _request getOrDefault ["signals",["",""]];
private _aiHandling = _request getOrDefault ["aiHandling",0];

[_entity,true,"MOVE",[LSTRING(statusAirdropInbound),RGBA_YELLOW]] call EFUNC(common,setStatus);

private _spawnDistance = _entity getVariable [QPVAR(spawnDistance),6000];
private _speed = getNumber (configFile >> "CfgVehicles" >> _entity getVariable [QPVAR(class),""] >> "maxSpeed");
private _itemCount = count flatten (_selection apply {_x # 0});

// if virtual runway overlaps the offset, the objects could be dropped the wrong direction or just weird...
// if the offset is further than the runway pos, i could just override the runway with the direction to target - ???

private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];
private _ETADistance = [_virtualRunway distance2D _posASL,_spawnDistance] select (_virtualRunway isEqualTo [0,0,0]);
private _delay = (_entity getVariable QPVAR(spawnDelay)) call EFUNC(common,randomMinMax);
//DEBUG_1("Random delay: %1",_delay);

private _ETA = [_delay + _ETADistance / (_speed / 3.6)] call EFUNC(common,formatTime);
private _msg = {
	format [LLSTRING(notifyAirdropInbound),_this # 0 call EFUNC(common,formatGrid),_this # 1]
};

NOTIFY_2(_entity,_msg,_posASL,_ETA);

_entity setVariable [QPVAR(cooldownTimer),(_entity getVariable [QPVAR(cooldown),0]) + _itemCount * (_entity getVariable [QPVAR(itemCooldown),0]),true];
_entity setVariable [QGVAR(dropping),nil,true];

if (GVAR(cooldownTrigger) == "START") then {
	[EFUNC(common,cooldown),[_entity,false],1] call CBA_fnc_waitAndExecute;
};

[{
	params ["_player","_entity","_request","_spawnDistance"];
	_request params ["_selection","_posASL","_signals","_aiHandling"];

	private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];
	private _offsetDir = 360;
	private _offsetDist = 0;
	private _flybyDir = random 360;
	private _fnc_newHelo = {
		private _vrOffset = if (_virtualRunway isEqualTo [0,0,0]) then {[0,0,0]} else {
			(_virtualRunway getPos [_offsetDist,_offsetDir]) vectorAdd [0,0,_virtualRunway # 2]
		};

		private _vehicle = [
			_posASL getPos [_offsetDist,_offsetDir],
			_flybyDir,
			_spawnDistance,
			_entity getVariable QPVAR(altitude),
			[_entity getVariable QPVAR(class),_entity getVariable QPVAR(side)],
			0,
			QPATHTOF(waypoints\slingloadDropoff.sqf),
			_vrOffset
		] call FUNC(flyby);

		private _group = group _vehicle;
		[_group,currentWaypoint _group + 1] setWaypointPosition [getPos _vehicle,0];

		_vehicle setVariable [QGVAR(flybyData),[_player,_entity,_request,getPosASL _vehicle],true];
		[_vehicle,_entity,false] call EFUNC(common,commission);
		[_vehicle,"Deleted",{
			params ["_vehicle"];

			private _entity = _thisArgs;
			private _vehicles = _entity getVariable [QPVAR(vehicles),[]];

			if !(_vehicle in _vehicles) exitWith {};

			_vehicles = _vehicles - [_vehicle,objNull];
			_entity setVariable [QPVAR(vehicles),_vehicles,true];

			if (GVAR(cooldownTrigger) == "END" && _vehicles isEqualTo []) then {
				[_entity,false] call EFUNC(common,cooldown);
			};
		},_entity] call CBA_fnc_addBISEventHandler;

		_offsetDir = _offsetDir + 72;
		
		if (_offsetDir >= 360) then {
			_offsetDir = _offsetDir call CBA_fnc_simplifyAngle;
			_offsetDist = _offsetDist + 2.5 * ((_entity getVariable QPVAR(class)) call EFUNC(common,sizeOf));
		};

		_vehicle
	};

	private _vehicles = [call _fnc_newHelo];
	private _crewIndex = 0;
	private _objectIndex = 0;
	private _blanketGroup = grpNull;

	{
		_x params ["_class","_formatting","_init","_thisArgs","_load","_requestLimit","_quantity",["_itemGroup",grpNull],["_itemVehicles",[]]];

		private _isComposition = _class isEqualType [];
		if (!_isComposition) then {_class = [_class]};

		{
			private _object = objNull;
			private _group = grpNull;
			private _crewLoaded = false;

			if (_x isKindOf "CAManBase") then {	
				if (_aiHandling == 0) then {
					_group = group _player;

					if (isNull _group) then {
						if (isNull _blanketGroup) then {
							_blanketGroup = createGroup [_entity getVariable QPVAR(side),true];
						};

						_group = _blanketGroup;
					};
				} else {
					if (_isComposition) then {
						if (isNull _itemGroup) then {
							_itemGroup = createGroup [_entity getVariable QPVAR(side),true];
						};

						_group = _itemGroup;
					} else {
						if (isNull _blanketGroup) then {
							_blanketGroup = createGroup [_entity getVariable QPVAR(side),true];
						};

						_group = _blanketGroup;
					};
				};

				_object = _group createUnit [_x,[0,0,0],[],0,"CAN_COLLIDE"];

				if !(_object moveInAny (_vehicles # _crewIndex)) then {
					_vehicles pushBack (call _fnc_newHelo);
					_crewIndex = _crewIndex + 1;
					_object moveInAny (_vehicles # _crewIndex);
				};
			} else {
				_object = _x createVehicle [0,0,0];

				_object setVariable [QGVAR(signals),_signals,true];
				
				if (isNull (_vehicles param [_objectIndex,objNull])) then {
					_vehicles pushBack (call _fnc_newHelo);
				};

				[_vehicles # _objectIndex,_object,true,true] call EFUNC(common,slingload);
				_objectIndex = _objectIndex + 1;

				_itemVehicles pushBack _object;
			};

			_object setVariable [QPVAR(requester),_player,true];

			_object call _init;
			_object call (_entity getVariable [QPVAR(itemInit),{}]);
		} forEach _class;

		if (!isNull _itemGroup) then {
			{_itemGroup addVehicle _x} forEach _itemVehicles;
		};
	} forEach _selection;
},[_player,_entity,+[_selection,_posASL,_signals,_aiHandling],_spawnDistance],_delay] call CBA_fnc_waitAndExecute;
