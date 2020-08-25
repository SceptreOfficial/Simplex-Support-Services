#include "script_component.hpp"

_vehicle setVariable ["SSS_hoverDone",false];
_vehicle setVariable ["SSS_fastropeUnits",nil];

[{
	params ["_entity","_vehicle"];

	getPos _vehicle # 2 > 2 || CANCEL_CONDITION
},{
	params ["_entity","_vehicle","_position","_hoverHeight","_doFastrope"];

	if (CANCEL_CONDITION) exitWith {};

	if (_doFastrope) then {
		_hoverHeight = _hoverHeight + 2
	};
	
	private _vehicleASL = getPosASL _vehicle;
	private _surfaceASL = ATLToASL [_position # 0,_position # 1,0];
	_surfaceASL set [2,_surfaceASL # 2 max 0];
	private _intersect = (lineIntersectsSurfaces [[_position # 0,_position # 1,_vehicleASL # 2 + 100],_surfaceASL,_vehicle]) # 0 # 0;
	private _hoverPositionASL = if (isNil "_intersect") then {
		[_surfaceASL # 0,_surfaceASL # 1,_surfaceASL # 2 + _hoverHeight];
	} else {
		_intersect set [2,_intersect # 2 + _hoverHeight];
		_intersect
	};

	private _endVectorDir = _vehicleASL vectorFromTo _hoverPositionASL;
	_endVectorDir set [2,0];
	private _distance = _vehicleASL distance _hoverPositionASL;
	private _timeMultiplier = [0.11,0.32] select (_distance < 50);

	[{
		params ["_args","_PFHID"];
		_args params [
			"_entity",
			"_vehicle",
			"_doFastrope",
			"_startPositionASL",
			"_hoverPositionASL",
			"_startVelocity",
			"_startVectorDir",
			"_endVectorDir",
			"_startVectorUp",
			"_timeStart",
			"_timeEnd"
		];

		if (!local _vehicle || _vehicle getVariable "SSS_hoverDone" || CANCEL_CONDITION) exitWith {
			[_PFHID] call CBA_fnc_removePerFrameHandler;
			_vehicle setVariable ["SSS_hoverDone",true,true];
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
				params ["_entity","_vehicle"];

				_vehicle setVectorDirAndUp [vectorDir _vehicle,[0,0,1]];
				_vehicle setVelocity [0,0,0];
				_vehicle setVelocityModelSpace [0,0,0];

				!local _vehicle || _vehicle getVariable ["SSS_hoverDone",false] || CANCEL_CONDITION
			},{
				params ["_entity","_vehicle"];

				// Make sure it doesn't drop
				[{
					private _velocity = velocity _this;
					if (_velocity # 2 < 0) then {
						_velocity set [2,0];
						_this setVelocity _velocity;
					};
				
					!alive _this || !alive driver _this;
				},{},_vehicle,3] call CBA_fnc_waitUntilAndExecute;

				_vehicle setVariable ["SSS_hoverDone",true,true];
				_vehicle setVariable ["SSS_fastropeUnits",nil,true];
			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;

			if (_doFastrope) then {
				NOTIFY(_entity,localize LSTRING(FastropingAtLocation));
				[_entity,_vehicle] call FUNC(transportFastrope);
			} else {
				NOTIFY(_entity,localize LSTRING(HoveringAtLocation));
				["SSS_requestCompleted",[_entity,["HOVER",false]]] call CBA_fnc_globalEvent;
			};
		};
	},0,[
		_entity,
		_vehicle,
		_doFastrope,
		getPosASL _vehicle,
		_hoverPositionASL,
		velocity _vehicle,
		vectorDir _vehicle,
		_endVectorDir,
		vectorUp _vehicle,
		CBA_missionTime,
		CBA_missionTime + (_distance * _timeMultiplier)
	]] call CBA_fnc_addPerFrameHandler;
},_this] call CBA_fnc_waitUntilAndExecute;
