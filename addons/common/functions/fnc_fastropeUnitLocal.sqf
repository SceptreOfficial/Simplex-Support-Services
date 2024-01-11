#include "script_component.hpp"

params ["_unit","_vehicle","_line"];
_line params ["_hook","_anchor","_rope","_length"];

[_unit] orderGetIn false;
unassignVehicle _unit;
moveOut _unit;
_unit setPosASL (getPosASL _hook vectorAdd [0,0,-2]);
_unit setDir random 360;
//if (!isPlayer _unit) then {_unit setDir random 360};

_unit switchMove QPVAR(fastrope);

// mod compat
if (!isNil "WMO_noRoadway") then {WMO_noRoadway pushBack _vehicle};

private _endHeight = getPosASL _hook # 2 - _length - 0.3;
//private _endHeight = getPosASL _anchor # 2;

[{
	params ["_unit","_vehicle","_endHeight","_lastTime"];

	private _height = getPosASL _unit # 2 - _endHeight;
	private _speed = velocity _unit # 2;
	private _delta = CBA_missionTime - _lastTime max 0.000001;

	if (_speed < -7) then {_unit setVelocity [0,0,_speed + 18 / (1 / _delta)]};
	if (_height < 4 && _speed < -1.5) then {_unit setVelocity [0,0,_speed + 18 / (1 / _delta)]};

	_this set [3,CBA_missionTime];

	!alive _unit || _height < 0.1 || isTouchingGround _unit
},{
	params ["_unit","_vehicle"];

	_unit switchMove "";
	_unit setVectorUp [0,0,1];
	_unit setVariable [QPVAR(fastroping),nil,true];
	
	// Tell AI to make room
	if (!isPlayer _unit) then {
		[{(_this # 0) doMove (_this # 1)},[_unit,_vehicle getPos [sizeOf typeOf _vehicle / 2,random 360]],2] call CBA_fnc_execAfterNFrames;
	};

	// mod compat
	if (!isNil "WMO_noRoadway") then {WMO_noRoadway deleteAt (WMO_noRoadway find _vehicle)};
	
	[QGVAR(fastropingDone),[_unit,_vehicle],_vehicle] call CBA_fnc_targetEvent;
},[_unit,_vehicle,_endHeight,CBA_missionTime]] call CBA_fnc_waitUntilAndExecute;
