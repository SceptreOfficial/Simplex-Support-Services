#include "script_component.hpp"

params ["_player","_entity","_request"];

private _selection = _request getOrDefault ["selection",[]];
private _aiHandling = _request getOrDefault ["aiHandling",0];

_selection param [0,[]] params ["_class","_formatting","_init","_thisArgs","_load","_requestLimit","_quantity",["_itemGroup",grpNull],["_itemVehicles",[]]];
_formatting params ["_name","_icon","_tooltip","_info"];

private _posASL = _entity getVariable QPVAR(base);
private _dir = _entity getVariable QPVAR(baseDir);

private _msg = {
	format [LLSTRING(notifyStationSpawned),_this # 0,_this # 1 call EFUNC(common,formatGrid)]
};

NOTIFY_2(_entity,_msg,_name,_posASL);
[_entity,true] call EFUNC(common,cooldown);

if !(_class isEqualType []) then {_class = [_class]};

{
	private _object = objNull;

	if (_x isKindOf "CAManBase") then {
		if (isNull _itemGroup) then {
			if (_aiHandling == 0) then {
				_itemGroup = group _player;	
			};

			if (isNull _itemGroup) then {
				_itemGroup = createGroup [_entity getVariable QPVAR(side),true];
			};
		};

		_object = _itemGroup createUnit [_x,[0,0,0],[],0,"CAN_COLLIDE"];
	} else {
		_object = _x createVehicle [0,0,0];
		_itemVehicles pushBack _object;
	};

	[_object,_posASL] call EFUNC(common,placementSearch) params ["_safePos","_safeUp"];

	if (!isNil "_safePos") then {
		_object setPosASL _safePos;
		_object setDir _dir;
		_object setVectorUp _safeUp;
	} else {
		_object setPosASL _posASL;
		_object setDir _dir;
		_object setVectorUp surfaceNormal _posASL;
	};
	
	_object setVariable [QPVAR(requester),_player,true];

	_object call _init;
	_object call (_entity getVariable [QPVAR(itemInit),{}]);
} forEach _class;

if (!isNull _itemGroup) then {
	{_itemGroup addVehicle _x} forEach _itemVehicles;
};
