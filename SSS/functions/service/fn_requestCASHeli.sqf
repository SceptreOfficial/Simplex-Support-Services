#include "script_component.hpp"

params ["_vehicle","_request",["_position",[],[[]]]];

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
	// Search and Destroy
	case 1 : {
		INTERRUPT(_vehicle)

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position"];

			BEGIN_ORDER(_vehicle,_position,"Heading to requested location to provide CAS.")

			private _group = group _vehicle;
			{
				_group reveal _x;
				false
			} count (_position nearEntities 120);

			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,_position,0,"SAD","COMBAT","RED","FULL","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle"];

				if (CANCEL_CONDITION) exitWith {CANCEL_ORDER(_vehicle,"SAD")};

				END_ORDER(_vehicle,"Search and Destroy Complete.")

				// SAD waypoint finished, return to base
				[_vehicle,0] call SSS_fnc_requestCASHeli;

			},_vehicle] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};
	// Move
	case 2 : {
		INTERRUPT(_vehicle)

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position"];

			BEGIN_ORDER(_vehicle,_position,"Moving to requested location.")

			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,_position,0,"MOVE","CARELESS","YELLOW","NORMAL","",WP_DONE] call SSS_fnc_addWaypoint;

			[{WAIT_CONDITION_WPDONE},{
				params ["_vehicle"];

				if (CANCEL_CONDITION) exitWith {CANCEL_ORDER(_vehicle,"Move")};

				END_ORDER(_vehicle,"Destination reached. Ready for further tasking.")

			},_vehicle] call CBA_fnc_waitUntilAndExecute;
		},[_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};
	// Loiter
	case 3 : {
		INTERRUPT(_vehicle)

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_vehicle","_position"];

			BEGIN_ORDER(_vehicle,_position,"Moving to requested location to loiter.")

			private _prepDist = [100,300] select (_vehicle distance2D _position > 300);
			_vehicle setVariable ["SSS_WPDone",false];
			_vehicle call SSS_fnc_clearWaypoints;
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","CARELESS","YELLOW","NORMAL","",WP_DONE] call SSS_fnc_addWaypoint;

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
	// Gun Run
	case 4: {
		// WIP
	};
};
