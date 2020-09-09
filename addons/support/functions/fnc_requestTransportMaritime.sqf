#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_request","",[""]],["_position",[],[[]]],["_extraParams",[],[[]]]];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {
	_vehicle call EFUNC(common,respawn);
};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestTransportMaritime),_vehicle];
};

["SSS_requestSubmitted",[_entity,[_request,_position,_extraParams]]] call CBA_fnc_globalEvent;

switch (toUpper _request) do {
	case "RTB" : {
		if !(_entity getVariable "SSS_awayFromBase") exitWith {};

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle"];

			private _position = ASLtoAGL (_entity getVariable "SSS_base");

			// Begin order
			_entity setVariable ["SSS_onTask",true,true];
			[_entity,true,_position] call EFUNC(common,updateMarker);
			NOTIFY(_entity,"Returning to base.");

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE,[2,2,2]] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				END_ORDER(_entity,"Arrived at base. Ready for further tasking.");
				_entity setVariable ["SSS_awayFromBase",false,true];
				_vehicle engineOn false;
				_vehicle doFollow _vehicle;

				[_entity,_vehicle] call EFUNC(common,resetOnRTB);

				["SSS_requestCompleted",[_entity,["RTB"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
	};
	
	case "MOVE";
	case "MOVE_ENG_OFF" : {
		private _engineOn = _request == "MOVE";

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_engineOn"];

			BEGIN_ORDER(_entity,_position,"Moving to requested location.");

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle", "_engineOn"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				END_ORDER(_entity,"Destination reached. Ready for further tasking.");

				private _requestName = if (_engineOn) then {
					[{_this engineOn true},_vehicle,1] call CBA_fnc_waitAndExecute;
					"MOVE"
				} else {
					_vehicle engineOn false;
					"MOVE_ENG_OFF"
				};
				
				["SSS_requestCompleted",[_entity,[_requestName]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle,_engineOn]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_engineOn]] call CBA_fnc_waitUntilAndExecute;
	};
};
