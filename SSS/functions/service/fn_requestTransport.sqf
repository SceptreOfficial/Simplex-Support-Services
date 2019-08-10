#include "script_component.hpp"

params ["_vehicle","_request",["_position",[],[[]]],["_extraParameters",[],[[]]]];

if (!alive _vehicle) exitWith {};
if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {[_vehicle,true] remoteExecCall ["SSS_fnc_respawn",2];};

switch (_request) do {
	// RTB
	case 0 : {
		if !(_vehicle getVariable "SSS_awayFromBase") exitWith {NOTIFY(_vehicle,"Already at base.")};

		INTERRUPT(_vehicle)

		[{!(_this getVariable "SSS_onTask")},{
			params ["_vehicle"];
			private _position = getPos (_vehicle getVariable "SSS_base");

			// Begin order
			_vehicle setVariable ["SSS_onTask",true];
			[_vehicle,true,_position] call SSS_fnc_updateMarker;
			NOTIFY(_vehicle,"Heading back to base.")

			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,_position,0,"MOVE","CARELESS","YELLOW","NORMAL","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle"];

				if (CANCEL_CONDITION) exitWith {CANCEL_ORDER(_vehicle,"RTB")};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				_vehicle land "LAND";

				[{WAIT_CONDITION_LAND},{
					params ["_vehicle"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_vehicle,"RTB")
						_vehicle doFollow _vehicle;
						_vehicle land "NONE";
					};

					END_ORDER(_vehicle,"Arrived at base. Ready for further tasking.")
					_vehicle setVariable ["SSS_awayFromBase",false,true];

					// Refresh vehicle
					_vehicle setFuel 1;
					_vehicle setVehicleAmmo 1;
					_vehicle setDamage 0;
					_vehicle engineOn false;
					_vehicle doFollow _vehicle;

				},_vehicle] call CBA_fnc_waitUntilAndExecute;
			},_vehicle] call CBA_fnc_waitUntilAndExecute;
		},_vehicle] call CBA_fnc_waitUntilAndExecute;
	};
	// Pickup
	case 1 : {
		INTERRUPT(_vehicle)

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position"];

			BEGIN_ORDER(_vehicle,_position,"Heading to pickup destination. Prepare to signal on arrival.")

			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			private _prepDist = [100,300] select (_vehicle distance2D _position > 300);
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","","","","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle","_position"];

				if (CANCEL_CONDITION) exitWith {CANCEL_ORDER(_vehicle,"Pickup")};

				// Loiter until smoke found
				(group _vehicle) setSpeedMode "LIMITED";
				private _WP = (group _vehicle) addWaypoint [_position,0];
				_WP setWaypointType "LOITER";
				_WP setWaypointLoiterRadius 200;
				_WP setWaypointLoiterType (["CIRCLE","CIRCLE_L"] # (floor random 2));
				_WP setWaypointSpeed "LIMITED";

				// Carry on with external function
				[_vehicle,_position,true] call SSS_fnc_transportSmokeSignal;

			},[_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};
	// Land / Land (eng off)
	case 2;
	case 3 : {
		INTERRUPT(_vehicle)

		private _engineOn = _request isEqualTo 2;

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position","_engineOn"];
			private _nearestPads = nearestObjects [_position,[
				"Land_HelipadSquare_F","Land_HelipadRescue_F",
				"Land_HelipadCivil_F","Land_HelipadCircle_F",
				"Land_HelipadEmpty_F","HeliH",
				"HeliHCivil","HeliHRescue"
			],50];
			private _pad = [_nearestPads # 0,"Land_HelipadEmpty_F" createVehicle _position] select (_nearestPads isEqualTo []);

			BEGIN_ORDER(_vehicle,_position,"Heading to the LZ.")

			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,getPos _pad,0,"MOVE","","","","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle","_pad","_engineOn"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_vehicle,"Landing")
					deleteVehicle _pad;
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				_vehicle land "GET IN";

				[{WAIT_CONDITION_LAND},{
					params ["_vehicle","_pad","_engineOn"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_vehicle,"Landing")
						_vehicle doFollow _vehicle;
						_vehicle land "NONE";
						deleteVehicle _pad;
					};

					END_ORDER(_vehicle,"Landed at location. Ready for further tasking.")
					if (!_engineOn) then {_vehicle engineOn false;};

					[{
						params ["_vehicle"];
						(!alive _vehicle || !alive driver _vehicle) || _vehicle getVariable "SSS_onTask"
					},{
						deleteVehicle (_this # 1);
					},[_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;

				},[_vehicle,_pad,_engineOn]] call CBA_fnc_waitUntilAndExecute;
			},[_vehicle,_pad,_engineOn]] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_position,_engineOn]] call CBA_fnc_waitUntilAndExecute;
	};
	// Move
	case 4 : {
		INTERRUPT(_vehicle)

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position"];

			BEGIN_ORDER(_vehicle,_position,"Moving to requested location.")

			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle"];

				if (CANCEL_CONDITION) exitWith {CANCEL_ORDER(_vehicle,"Move")};

				END_ORDER(_vehicle,"Destination reached. Ready for further tasking.")

			},_vehicle] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};
	// Hover / Fastrope
	case 5 : {
		INTERRUPT(_vehicle)

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position","_extraParameters"];
			_extraParameters params ["_hoverHeight","_fastrope"];

			private _message = [format ["Moving to location to hover at %1m.",_hoverHeight],"Moving to location to fastrope."] select (_fastrope);
			BEGIN_ORDER(_vehicle,_position,_message)

			_position set [2,-100];
			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle","_position","_hoverHeight","_fastrope"];

				if (CANCEL_CONDITION) exitWith {
					private _task = ["Hover","Fastope"] select _fastrope;
					CANCEL_ORDER(_vehicle,_task)
				};

				// Begin precision hover/fastrope
				_vehicle flyInHeight _hoverHeight;
				[_vehicle,_position,_hoverHeight,_fastrope] call SSS_fnc_transportHover;

				[{
					params ["_vehicle"];
					_vehicle getVariable ["SSS_hoverDone",false] || !alive _vehicle || _vehicle getVariable "SSS_interrupt"
				},{
					params ["_vehicle","_fastrope"];

					if (CANCEL_CONDITION) exitWith {
						private _task = ["Hover","Fastope"] select _fastrope;
						CANCEL_ORDER(_vehicle,_task)
						_vehicle setVariable ["SSS_hoverDone",true];
					};

					// End order without notify (handled in fnc_transportHover)
					_vehicle setVariable ["SSS_onTask",false];
					[_vehicle,false] call SSS_fnc_updateMarker;

				},[_vehicle,_fastrope]] call CBA_fnc_waitUntilAndExecute;
			},[_vehicle,_position,_hoverHeight,_fastrope]] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_position,_extraParameters]] call CBA_fnc_waitUntilAndExecute;
	};
	// Loiter
	case 6 : {
		INTERRUPT(_vehicle)

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position"];

			BEGIN_ORDER(_vehicle,_position,"Moving to requested location to loiter.")

			private _prepDist = [100,300] select (_vehicle distance2D _position > 300);
			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","","","","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle","_position"];

				if (CANCEL_CONDITION) exitWith {CANCEL_ORDER(_vehicle,"Loiter")};

				// Loiter
				(group _vehicle) setSpeedMode "LIMITED";
				private _WP = (group _vehicle) addWaypoint [_position,0];
				_WP setWaypointType "LOITER";
				_WP setWaypointLoiterRadius 200;
				_WP setWaypointLoiterType (["CIRCLE","CIRCLE_L"] # (floor random 2));
				_WP setWaypointSpeed "LIMITED";

				// End order without removing marker
				_vehicle setVariable ["SSS_onTask",false];
				NOTIFY(_vehicle,"Loiter destination reached. Loitering until further tasking.")

			},[_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};
};
