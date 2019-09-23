#include "script_component.hpp"

params ["_vehicle","_unit","_ropes"];

[_unit] orderGetIn false;
moveOut _unit;

_ropes = _ropes apply {[_x # 0 distance _unit,_x]};
_ropes sort true;
_ropes = _ropes apply {_x # 1};
private _posASL = getPosASL (_ropes # 0 # 0);
_posASL set [2,_posASL # 2 - 2];
_unit setPosASL _posASL;
[_unit,"ACE_FastRoping",2] call ACE_common_fnc_doAnimation;

[{
	params ["_unit"];
	private _height = getPos _unit # 2;
	private _speed = (velocity _unit) # 2;

	if (_height > 1.5 && _speed > -7.2) then {
		_unit setVelocity [0,0,-7.2];
	} else {
		if (_speed < -1) then {
			_unit setVelocity [0,0,_speed * 0.9];
		};
	};

	_height < 0.5 || !alive _unit
},{
	params ["_unit","_vehicle"];

	[_unit,"",2] call ACE_common_fnc_doAnimation;
	_unit setVectorUp [0,0,1];
	_unit setVariable ["SSS_fastroping",nil,true];
	_vehicle setVariable ["SSS_fastropeUnits",(_vehicle getVariable "SSS_fastropeUnits") - [_unit],true];
},[_unit,_vehicle]] call CBA_fnc_waitUntilAndExecute;
