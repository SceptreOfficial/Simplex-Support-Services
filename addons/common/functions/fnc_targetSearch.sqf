#include "script_component.hpp"

params ["_target","_friendlySide","_search",["_radius",500],["_friendlyRange",0]];

(_search splitString ":") params [["_type",""],["_typeDetail",""]];

switch (_type) do {
	case "MAP" : {
		if (_target isEqualType objNull) then {_target = getPosASL _target};
	};
	case "ENEMIES";
	case "INFANTRY";
	case "VEHICLES" : {
		private _enemies = [];
		private _friendlies = [];
		private ["_enemy","_side"];

		{
			_side = side group _x;
			
			if !(_side in [west,east,independent,civilian]) then {continue};
			
			if ([_friendlySide,_side] call BIS_fnc_sideIsEnemy) then {
				_enemies pushBack _x;
			} else {
				_friendlies pushBack _x;
			};
		} forEach (switch _type do {
			case "INFANTRY" : {_target nearEntities ["CAManBase",_radius]};
			case "VEHICLES" : {_target nearEntities [["LandVehicle","Air","Ship"],_radius]};
			default {_target nearEntities _radius};
		});

		if (_friendlyRange > 0) then {
			_target = selectRandom (_enemies select {
				_enemy = _x;
				_friendlies findIf {_enemy distance _x < _friendlyRange} < 0
			})
		} else {
			_target = selectRandom _enemies;
		};

		if (isNil "_target") then {_target = objNull};
	};
	case "LASER" : {
		_target = selectRandom (_target nearEntities [["LaserTargetE","LaserTargetW"] select ([_friendlySide,west] call BIS_fnc_sideIsFriendly),_radius]);
		if (isNil "_target") then {_target = objNull};
	};
	case "SMOKE";
	case "IR";
	case "FLARE" : {
		if (_typeDetail isEqualTo "") then {
			_target = selectRandom ([_type,_target,_radius] call FUNC(signalSearch));
		} else {
			_target = selectRandom (([_type,_target,_radius] call FUNC(signalSearch)) select {_x call FUNC(signalColor) isEqualTo _typeDetail});
		};
		
		if (isNil "_target") exitWith {_target = objNull};
		_target = getPosASL _target;
	};
};

_target
