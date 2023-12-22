#include "script_component.hpp"

params ["_target","_friendlySide","_search",["_radius",500]];

(_search splitString ":") params [["_type",""],["_typeDetail",""]];

switch (_type) do {
	case "MAP" : {
		if (_target isEqualType objNull) then {_target = getPosASL _target};
	};
	case "ENEMIES" : {
		_target = selectRandom ((_target nearEntities _radius) select {[_friendlySide,side group _x] call BIS_fnc_sideIsEnemy});
		if (isNil "_target") then {_target = objNull};
	};
	case "INFANTRY" : {
		_target = selectRandom ((_target nearEntities ["CAManBase",_radius]) select {[_friendlySide,side group _x] call BIS_fnc_sideIsEnemy});
		if (isNil "_target") then {_target = objNull};
	};
	case "VEHICLES" : {
		_target = selectRandom ((_target nearEntities [["LandVehicle","Air","Ship"],_radius]) select {[_friendlySide,side group _x] call BIS_fnc_sideIsEnemy});
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
