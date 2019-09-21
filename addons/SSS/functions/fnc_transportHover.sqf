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

	private _dummy = (createGroup sideLogic) createUnit ["Logic",[0,0,0],[],0,"CAN_COLLIDE"];
	_dummy setPosASL [_position # 0,_position # 1,9999];

	[{
		params ["_entity","_vehicle","_position","_hoverHeight","_doFastrope","_dummy"];
		
		private _heightASL = 9999 - (getPos _dummy # 2) + _hoverHeight;
		private _hoverPositionASL = [_position # 0,_position # 1,_heightASL];
		deleteVehicle _dummy;
		private _endVectorDir = getPosASL _vehicle vectorFromTo _hoverPositionASL;
		_endVectorDir set [2,0];
		private _distance = getPosASL _vehicle distance _hoverPositionASL;
		private _timeMultiplier = [0.12,0.3] select (_distance < 50);

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

					_vehicle setVectorUp [0,0,1];
					_vehicle setVelocityModelSpace [0,0,0];

					!local _vehicle || _vehicle getVariable "SSS_hoverDone" || CANCEL_CONDITION
				},{
					params ["_entity","_vehicle"];

					[{
						private _velocity = velocityModelSpace _this;
						if (_velocity # 2 < 0) then {
							_velocity set [2,0];
							_this setVelocityModelSpace _velocity;
						};

						alive _this && alive driver _this;
					},{},_vehicle,4] call CBA_fnc_waitUntilAndExecute;

					_vehicle setVariable ["SSS_hoverDone",true,true];
					_vehicle setVariable ["SSS_fastropeUnits",nil,true];
				},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;

				if (_doFastrope) then {
					NOTIFY(_entity,"Fastroping at location.");
					[_entity,_vehicle] call FUNC(transportFastrope);
				} else {
					NOTIFY(_entity,"Hovering at location.");
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
	},[_entity,_vehicle,_position,_hoverHeight,_doFastrope,_dummy]] call CBA_fnc_execNextFrame;
},_this] call CBA_fnc_waitUntilAndExecute;