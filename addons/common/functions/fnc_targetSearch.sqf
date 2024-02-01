#include "script_component.hpp"
#define FRIENDLY_SEARCH(CANDIDATES) if (_friendlyRange > 0) then { \
	private "_obj"; \
	_target = CANDIDATES param [CANDIDATES findIf { \
		_obj = _x; \
		_friendlies findIf {_obj distance _x < _friendlyRange} < 0 \
	},objNull]; \
} else { \
	_target = selectRandom CANDIDATES; \
}

params ["_pos","_friendlySide","_search",["_radius",500],["_friendlyRange",0]];

(_search splitString ":") params [["_type",""],["_typeDetail",""]];

if (_pos isEqualType objNull) then {_pos = getPosASL _pos};

if (_type isEqualTo "MAP") exitWith {_pos};

private _enemies = [];
private _friendlies = [];
private _target = +_pos;
_pos = ASLtoAGL _pos;

switch _type do {
	case "LASER" : {
		private "_side";
		private _laserType = ["LaserTargetE","LaserTargetW"] select ([_friendlySide,west] call BIS_fnc_sideIsFriendly);
		private _lasers = [];
		
		{
			_side = side group _x;
			
			if (_side in [west,east,independent,civilian] &&
				{[_friendlySide,_side] call BIS_fnc_sideIsFriendly}
			) then {
				_friendlies pushBack _x;
			} else {
				if ([_friendlySide,_side] call BIS_fnc_sideIsEnemy) then {
					_enemies pushBack _x;
				};
			};

			if (_x isKindOf _laserType && {!(_x getVariable [QGVAR(isDummy),false])}) then {
				_lasers pushBack _x;
			};
		} forEach (_pos nearEntities _radius);

		if (_lasers isEqualTo []) exitWith {_target = objNull};

		FRIENDLY_SEARCH(_lasers);

		if (_typeDetail isNotEqualTo "MATCH") exitWith {};
		
		_enemies = (_target nearEntities 25) arrayIntersect _enemies;

		if (_enemies isEqualTo []) then {
			// Use laser position if no enemies nearby
			_target = getPosASL _target;
		} else {
			// Use nearest enemy
			_target = [_target,_enemies] call FUNC(getNearest);
		};
	};
	case "SMOKE";
	case "IR";
	case "FLARE" : {
		private _signals = [_type,_pos,_radius] call FUNC(signalSearch);

		if !(_typeDetail in ["","ANY"]) then {
			_signals = _signals select {_x call FUNC(signalColor) isEqualTo _typeDetail};
		};

		if (_signals isEqualTo []) exitWith {_target = objNull};

		{
			if (side group _x in [west,east,independent,civilian] &&
				{[_friendlySide,side group _x] call BIS_fnc_sideIsFriendly}
			) then {
				_friendlies pushBack _x;
			};
		} forEach (_pos nearEntities _radius);
		
		FRIENDLY_SEARCH(_signals);

		if (!isNull _target) then {
			_target = getPosASL _target;
		};
	};
	case "ENEMIES";
	case "INFANTRY";
	case "VEHICLES" : {
		private "_side";
		private _filter = switch _type do {
			case "INFANTRY" : {{_x isKindOf "CAManBase"}};
			case "VEHICLES" : {
				switch _typeDetail do {
					case "STATIC" : {{_x isKindOf "StaticWeapon"}};
					case "WHEELED" : {{_x isKindOf "Car"}};
					case "TRACKED" : {{_x isKindOf "Tank"}};
					case "RADAR" : {{isVehicleRadarOn _x}};
					default {{!(_x isKindOf "CAManBase")}};
				};
			};
			default {{true}};
		};

		{
			_side = side group _x;

			if (_side in [west,east,independent,civilian] &&
				{[_friendlySide,_side] call BIS_fnc_sideIsFriendly}
			) then {
				_friendlies pushBack _x;
			} else {
				if ([_friendlySide,_side] call BIS_fnc_sideIsEnemy && _filter) then {
					_enemies pushBack _x;
				};
			};
		} forEach (_pos nearEntities _radius);

		if (_enemies isEqualTo []) exitWith {_target = objNull};

		FRIENDLY_SEARCH(_enemies);
	};
};

_target
