#include "script_component.hpp"

#define SEARCH_RADIUS 350

params ["_entity","_vehicle","_position","_firstCall"];

if (_firstCall) then {
	_entity setVariable ["SSS_deniedSignals",[],true];
};

private _signalType = if (sunOrMoon isEqualTo 1) then {
	if (_firstCall) then {
		NOTIFY(_entity,"Arrived at pickup destination. Pop smoke to confirm landing position.");
	} else {
		NOTIFY(_entity,"Disregarding that signal. Pop a new smoke to confirm landing position.");
	};

	"SmokeShell"
} else {
	if (_firstCall) then {
		NOTIFY(_entity,"Arrived at pickup destination. Deploy IR signal to confirm landing position.");
	} else {
		NOTIFY(_entity,"Disregarding that signal. Deploy a new IR signal to confirm landing position.");
	};

	"IRStrobeBase"
};

[{
	params ["_args","_PFHID"];
	_args params ["_entity","_vehicle","_position","_signalType"];

	if (CANCEL_CONDITION) exitWith {
		CANCEL_ORDER(_entity,"Pickup");
		[_PFHID] call CBA_fnc_removePerFrameHandler;
	};

	private _signal = ((_position nearObjects [_signalType,SEARCH_RADIUS]) - (_entity getVariable "SSS_deniedSignals")) # 0;
	if (isNil "_signal") exitWith {};

	[_PFHID] call CBA_fnc_removePerFrameHandler;

	// Wait until signal approved or denied
	_entity setVariable ["SSS_needConfirmation",true,true];

	private _signalSeen = if (_signalType == "SmokeShell") then {
		format ["a %1 smoke",_signal call FUNC(getSmokeColor)]
	} else {
		"an IR signal"
	};

	NOTIFY_1(_entity,"We see %1. Do you confirm?",_signalSeen);

	private _signalPos = getPos _signal;
	_signalPos set [2,0];

	[{
		params ["_entity","_vehicle"];

		isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || !(_entity getVariable "SSS_needConfirmation")}}
	},{
		params ["_entity","_vehicle","_position","_signalPos","_signal"];

		if (CANCEL_CONDITION) exitWith {
			CANCEL_ORDER(_entity,"Pickup");
			_entity setVariable ["SSS_needConfirmation",false,true];
			_entity setVariable ["SSS_deniedSignals",[],true];
		};

		// Signal denied
		if !(_entity getVariable "SSS_signalApproved") exitWith {
			_entity setVariable ["SSS_deniedSignals",(_entity getVariable "SSS_deniedSignals") + [_signal],true];
			[_entity,_vehicle,_position,false] call FUNC(transportSmokeSignal);
		};

		// Signal approved
		NOTIFY(_entity,"Signal confirmed. Clear the LZ.");
		_entity setVariable ["SSS_deniedSignals",[],true];

		if (!isNull _signal) then {
			_signalPos = getPos _signal;
			_signalPos set [2,0];
		};

		_vehicle setVariable ["SSS_WPDone",false];
		[_entity,_vehicle] call FUNC(clearWaypoints);
		[_vehicle,_signalPos,0,"MOVE","","","","",WP_DONE] call FUNC(addWaypoint);
		private _pad = createVehicle ["Land_HelipadEmpty_F",_signalPos,[],0,"CAN_COLLIDE"];

		[{WAIT_UNTIL_WPDONE},{
			params ["_entity","_vehicle","_pad"];

			if (CANCEL_CONDITION) exitWith {
				CANCEL_ORDER(_entity,"Pickup");
				deleteVehicle _pad;
			};

			// Begin landing
			(group _vehicle) setSpeedMode "LIMITED";
			doStop _vehicle;
			_vehicle land "GET IN";

			[{WAIT_UNTIL_LAND},{
				params ["_entity","_vehicle","_pad"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity,"Pickup");
					_vehicle doFollow _vehicle;
					_vehicle land "NONE";
					deleteVehicle _pad;
				};

				END_ORDER(_entity,"Touchdown. Load up!");

				[{
					params ["_entity","_vehicle"];
					isNull _entity || !alive _vehicle || !alive driver _vehicle || _entity getVariable "SSS_onTask"
				},{
					deleteVehicle (_this # 2);
				},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;

			},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
	},[_entity,_vehicle,_position,_signalPos,_signal]] call CBA_fnc_waitUntilAndExecute;
},5,[_entity,_vehicle,_position,_signalType]] call CBA_fnc_addPerFrameHandler;
