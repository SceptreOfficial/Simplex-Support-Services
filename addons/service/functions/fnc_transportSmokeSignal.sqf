#include "script_component.hpp"

#define SEARCH_RADIUS 350

params ["_vehicle","_position","_firstCall"];

private _signalType = if (sunOrMoon isEqualTo 1) then {
	if (_firstCall) then {
		NOTIFY(_vehicle,"Arrived at pickup destination. Pop smoke to confirm landing position.")
	} else {
		NOTIFY(_vehicle,"Disregarding that signal. Pop a new smoke to confirm landing position.")
	};
	"SmokeShell"
} else {
	if (_firstCall) then {
		NOTIFY(_vehicle,"Arrived at pickup destination. Deploy IR signal to confirm landing position.")
	} else {
		NOTIFY(_vehicle,"Disregarding that signal. Deploy a new IR signal to confirm landing position.")
	};
	"IRStrobeBase"
};

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_position","_signalType"];

	if (CANCEL_CONDITION) exitWith {
		CANCEL_ORDER(_vehicle,"Pickup")
		[_PFHID] call CBA_fnc_removePerFrameHandler;
	};

	private _signal = ((_position nearObjects [_signalType,SEARCH_RADIUS]) - (_vehicle getVariable "SSS_deniedSignals")) # 0;
	if (isNil "_signal") exitWith {};

	[_PFHID] call CBA_fnc_removePerFrameHandler;

	// Wait until signal approved or denied
	_vehicle setVariable ["SSS_needConfirmation",true,true];
	private _signalSeen = ["an IR signal",format ["a %1 smoke",_signal call EFUNC(common,getSmokeColor)]] select (_signalType == "SmokeShell");
	NOTIFY_1(_vehicle,"We see %1. Do you confirm?",_signalSeen)

	private _signalPos = getPos _signal;
	_signalPos set [2,0];

	[{WAIT_CONDITION_BASE || !(_vehicle getVariable "SSS_needConfirmation")},{
		params ["_vehicle","_position","_signalPos","_signal"];

		if (CANCEL_CONDITION) exitWith {
			CANCEL_ORDER(_vehicle,"Pickup")
			_vehicle setVariable ["SSS_needConfirmation",false,true];
			_vehicle setVariable ["SSS_deniedSignals",[],true];
		};

		// Signal denied
		if !(_vehicle getVariable "SSS_signalApproved") exitWith {
			_vehicle setVariable ["SSS_deniedSignals",(_vehicle getVariable "SSS_deniedSignals") + [_signal],true];
			[_vehicle,_position,false] call FUNC(transportSmokeSignal);
		};

		// Signal approved
		NOTIFY(_vehicle,"Signal confirmed. Clear the LZ.")
		_vehicle setVariable ["SSS_deniedSignals",[],true];

		if (!isNull _signal) then {
			_signalPos = getPos _signal;
			_signalPos set [2,0];
		};

		_vehicle setVariable ["SSS_WPDone",false];
		_vehicle call EFUNC(common,clearWaypoints);
		[_vehicle,_signalPos,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);
		private _pad = createVehicle ["Land_HelipadEmpty_F",_signalPos,[],0,"CAN_COLLIDE"];

		[{WAIT_CONDITION_WPDONE},{
			params ["_vehicle","_pad"];

			if (CANCEL_CONDITION) exitWith {
				CANCEL_ORDER(_vehicle,"Pickup")
				deleteVehicle _pad;
			};

			// Begin landing
			(group _vehicle) setSpeedMode "LIMITED";
			doStop _vehicle;
			_vehicle land "GET IN";

			[{WAIT_CONDITION_LAND},{
				params ["_vehicle","_pad"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_vehicle,"Pickup")
					_vehicle doFollow _vehicle;
					_vehicle land "NONE";
					deleteVehicle _pad;
				};

				END_ORDER(_vehicle,"Touchdown. Load up!")

				[{
					params ["_vehicle"];
					(!alive _vehicle || !alive driver _vehicle) || _vehicle getVariable "SSS_onTask"
				},{
					deleteVehicle (_this # 1);
				},[_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;

			},[_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
	},[_vehicle,_position,_signalPos,_signal]] call CBA_fnc_waitUntilAndExecute;
},5,[_vehicle,_position,_signalType]] call CBA_fnc_addPerFrameHandler;
