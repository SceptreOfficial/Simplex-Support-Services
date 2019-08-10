#include "script_component.hpp"

params ["_vehicle","_position","_hoverHeight","_fastrope"];

_vehicle setVariable ["SSS_hoverDone",false];
_vehicle setVariable ["SSS_fastropeUnits",nil];

if (_fastrope) then {_hoverHeight = _hoverHeight + 3};
private _dummy = (createGroup sideLogic) createUnit ["LOGIC",[0,0,0],[],0,"CAN_COLLIDE"];
_dummy setPosASL [_position # 0,_position # 1,9999];
private _hoverPositionASL = [_position # 0,_position # 1,9999 - ((getPos _dummy) # 2) + _hoverHeight];
deleteVehicle _dummy;

private _endVectorDir = [getPosASL _vehicle,_hoverPositionASL] call BIS_fnc_vectorFromXToY;
_endVectorDir set [2,0];

[{
	params ["_args","_PFHID"];
	_args params [
		"_vehicle","_fastrope",
		"_startPositionASL","_hoverPositionASL",
		"_startVelocity","_startVectorDir",
		"_endVectorDir","_startVectorUp",
		"_timeStart","_timeEnd"
	];

	if (!local _vehicle || (!alive _vehicle || !alive driver _vehicle) || _vehicle getVariable "SSS_hoverDone") exitWith {
		[_PFHID] call CBA_fnc_removePerFrameHandler;
		_vehicle setVariable ["SSS_hoverDone",true];
		_vehicle setVariable ["SSS_fastropeUnits",nil,true];
	};

	private _interval = linearConversion [_timeStart,_timeEnd,CBA_missionTime,0,1];

	if (_interval <= 1) then {
		_vehicle setVelocityTransformation [
			_startPositionASL,_hoverPositionASL,
			_startVelocity,[0,0,0],
			_startVectorDir,_endVectorDir,
			_startVectorUp,[0,0,1],
			_interval
		];
	} else {
		[_PFHID] call CBA_fnc_removePerFrameHandler;

		[{
			params ["_vehicle"];

			_vehicle setVectorUp [0,0,1];
			_vehicle setVelocity [0,0,0];

			!local _vehicle || (!alive _vehicle || !alive driver _vehicle) || (_vehicle getVariable "SSS_hoverDone" && isNil {_vehicle getVariable "SSS_fastropeUnits"})
		},{
			params ["_vehicle"];

			[{
				private _velocity = velocity _this;
				if (_velocity # 2 < 0) then {
					_velocity set [2,0];
					_this setVelocity _velocity;
				};

				alive _vehicle && alive driver _vehicle;
			},{},_vehicle,4] call CBA_fnc_waitUntilAndExecute;

			_vehicle setVariable ["SSS_hoverDone",true];
			_vehicle setVariable ["SSS_fastropeUnits",nil,true];
		},_vehicle] call CBA_fnc_waitUntilAndExecute;

		if (_fastrope) then {
			NOTIFY(_vehicle,"Fastroping at location.")
			_vehicle call SSS_fnc_transportFastrope;
		} else {
			NOTIFY(_vehicle,"Hovering at location.")
		};
	};
},0,[
	_vehicle,_fastrope,
	getPosASL _vehicle,_hoverPositionASL,
	velocity _vehicle,vectorDir _vehicle,
	_endVectorDir,vectorUp _vehicle,
	CBA_missionTime,CBA_missionTime + ((_vehicle distance _position) * 0.1)
]] call CBA_fnc_addPerFrameHandler;
