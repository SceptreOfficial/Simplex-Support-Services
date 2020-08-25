#include "script_component.hpp"

#define SEARCH_RADIUS 350

params ["_entity","_vehicle","_position","_firstCall"];

if (_firstCall) then {
	_entity setVariable ["SSS_deniedSignals",[],true];
};

(date call BIS_fnc_sunriseSunsetTime) params ["_sunrise","_sunset"];

private _signalType = if (daytime > _sunrise && daytime < _sunset) then {
	if (_firstCall) then {
		NOTIFY(_entity,localize LSTRING(ArrivedAtPickupDestinationWaitSmoke));
	} else {
		NOTIFY(_entity,localize LSTRING(DisregardingSignalRequireNewSmoke));
	};

	"SmokeShell"
} else {
	if (_firstCall) then {
		NOTIFY(_entity,localize LSTRING(ArrivedAtPickupDestinationWaitIR));
	} else {
		NOTIFY(_entity,localize LSTRING(DisregardingSignalRequireNewIR));
	};

	"IRStrobeBase"
};

[{
	params ["_args","_PFHID"];
	_args params ["_entity","_vehicle","_position","_signalType"];

	if (CANCEL_CONDITION) exitWith {
		CANCEL_ORDER(_entity);
		[_PFHID] call CBA_fnc_removePerFrameHandler;
	};

	private _signal = ((_position nearObjects [_signalType,SEARCH_RADIUS]) - (_entity getVariable "SSS_deniedSignals")) # 0;
	if (isNil "_signal") exitWith {};

	[_PFHID] call CBA_fnc_removePerFrameHandler;

	// Wait until signal approved or denied
	_entity setVariable ["SSS_needConfirmation",true,true];

	private _signalSeen = if (_signalType == "SmokeShell") then {
		format [localize LSTRING(SignalSeenSmoke),toLower (_signal call EFUNC(common,getSmokeColor))]
	} else {
		localize LSTRING(SignalSeenIR)
	};

	NOTIFY_1(_entity,localize LSTRING(WeSeeSignalConfirm),_signalSeen);

	private _signalPos = getPos _signal;
	_signalPos set [2,0];

	[{
		params ["_entity","_vehicle"];

		isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || !(_entity getVariable "SSS_needConfirmation")}}
	},{
		params ["_entity","_vehicle","_position","_signalPos","_signal"];

		if (CANCEL_CONDITION) exitWith {
			CANCEL_ORDER(_entity);
			_entity setVariable ["SSS_needConfirmation",false,true];
			_entity setVariable ["SSS_deniedSignals",[],true];
		};

		// Signal denied
		if !(_entity getVariable "SSS_signalApproved") exitWith {
			_entity setVariable ["SSS_deniedSignals",(_entity getVariable "SSS_deniedSignals") + [_signal],true];
			[_entity,_vehicle,_position,false] call FUNC(transportSmokeSignal);
		};

		// Signal approved
		NOTIFY(_entity,localize LSTRING(SignalConfirmedClearLZ));
		_entity setVariable ["SSS_deniedSignals",[],true];

		if (!isNull _signal) then {
			_signalPos = getPos _signal;
			_signalPos set [2,0];
		};

		_vehicle setVariable ["SSS_WPDone",false];
		[_entity,_vehicle] call EFUNC(common,clearWaypoints);
		[_vehicle,_signalPos,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);
		private _pad = createVehicle ["Land_HelipadEmpty_F",_signalPos,[],0,"CAN_COLLIDE"];

		[{WAIT_UNTIL_WPDONE},{
			params ["_entity","_vehicle","_pad"];

			if (CANCEL_CONDITION) exitWith {
				CANCEL_ORDER(_entity);
				deleteVehicle _pad;
			};

			// Begin landing
			(group _vehicle) setSpeedMode "LIMITED";
			doStop _vehicle;
			[{_this land "GET IN"},_vehicle] call CBA_fnc_execNextFrame;

			[{WAIT_UNTIL_LAND},{
				params ["_entity","_vehicle","_pad"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
					_vehicle doFollow _vehicle;
					_vehicle land "NONE";
					deleteVehicle _pad;
				};

				END_ORDER(_entity,localize LSTRING(TouchdownLoadUp));

				[{deleteVehicle _this},_pad,5] call CBA_fnc_waitAndExecute;

				["SSS_requestCompleted",[_entity,["PICKUP"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
	},[_entity,_vehicle,_position,_signalPos,_signal]] call CBA_fnc_waitUntilAndExecute;
},5,[_entity,_vehicle,_position,_signalType]] call CBA_fnc_addPerFrameHandler;
