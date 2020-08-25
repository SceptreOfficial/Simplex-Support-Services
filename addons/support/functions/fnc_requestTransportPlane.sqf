#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_request","",[""]],["_position",[],[[]]],["_extraParams",[],[[]]]];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {
	_vehicle call EFUNC(common,respawn);
};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestTransportPlane),_vehicle];
};

["SSS_requestSubmitted",[_entity,[_request,_position,_extraParams]]] call CBA_fnc_globalEvent;

switch (toUpper _request) do {
	case "RTB" : {
		if !(_entity getVariable "SSS_awayFromBase") exitWith {};

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle"];

			private _position = ASLToAGL (_entity getVariable "SSS_base");

			// Begin order
			_entity setVariable ["SSS_onTask",true,true];
			[_entity,true,_position] call EFUNC(common,updateMarker);
			NOTIFY(_entity,localize LSTRING(ReturningToBase));

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE,[2,2,2]] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				_vehicle action ["Land",_vehicle];

				[{WAIT_UNTIL_PLANE_LANDED},{
					params ["_entity","_vehicle"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity);
						_vehicle doFollow _vehicle;
					};

					_vehicle setDir (_entity getVariable "SSS_baseDir");
					_vehicle setPosASL (_entity getVariable "SSS_base");

					END_ORDER(_entity,localize LSTRING(ArrivedAtBase));
					_entity setVariable ["SSS_awayFromBase",false,true];
					_vehicle engineOn false;
					_vehicle setFuel 0;
					_vehicle doFollow _vehicle;

					[_entity,_vehicle] call EFUNC(common,resetOnRTB);

					["SSS_requestCompleted",[_entity,["RTB"]]] call CBA_fnc_globalEvent;
				},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
	};

	case "MOVE" : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			if !(_entity getVariable "SSS_awayFromBase") then {
				PLANE_TAKEOFF(_vehicle);
			};

			BEGIN_ORDER(_entity,_position,localize LSTRING(MovingToRequestLocation));

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				END_ORDER(_entity,localize LSTRING(DestinationReached));

				["SSS_requestCompleted",[_entity,["MOVE"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};

	case "PARADROP" : {
		_extraParams params ["_jumpDelay","_AIOpeningHeight"];

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_jumpDelay","_AIOpeningHeight"];

			if !(_entity getVariable "SSS_awayFromBase") then {
				PLANE_TAKEOFF(_vehicle);
			};

			BEGIN_ORDER(_entity,_position,localize LSTRING(MovingToLocationForParadrop));

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_position","_jumpDelay","_AIOpeningHeight"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				(group _vehicle) addWaypoint [_vehicle getRelPos [5000,0],0];
				(group _vehicle) addWaypoint [_position,100];
				
				[_entity,_vehicle,_jumpDelay,_AIOpeningHeight] call FUNC(transportParadrop);

				END_ORDER(_entity,localize LSTRING(GoGoGo));

				["SSS_requestCompleted",[_entity,["PARADROP"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle,_position,_jumpDelay,_AIOpeningHeight]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_jumpDelay,_AIOpeningHeight]] call CBA_fnc_waitUntilAndExecute;
	};

	case "LOITER" : {
		_extraParams params ["_loiterRadius","_loiterDirection"];

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_loiterRadius","_loiterDirection"];

			if !(_entity getVariable "SSS_awayFromBase") then {
				PLANE_TAKEOFF(_vehicle);
			};

			BEGIN_ORDER(_entity,_position,localize LSTRING(MovingToRequestLocationLoiter));

			private _prepDist = [100,_loiterRadius + 100] select (_vehicle distance2D _position > (_loiterRadius + 100));
			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_position","_loiterRadius","_loiterDirection"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				// Loiter
				(group _vehicle) setSpeedMode "LIMITED";
				private _WP = (group _vehicle) addWaypoint [_position,0];
				_WP setWaypointType "LOITER";
				_WP setWaypointLoiterRadius _loiterRadius;
				_WP setWaypointLoiterType (["CIRCLE","CIRCLE_L"] # _loiterDirection);
				_WP setWaypointSpeed "LIMITED";

				// End order without removing marker
				_entity setVariable ["SSS_onTask",false,true];
				NOTIFY(_entity,localize LSTRING(DestinationReachedLoitering));

				["SSS_requestCompleted",[_entity,["LOITER"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle,_position,_loiterRadius,_loiterDirection]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_loiterRadius,_loiterDirection]] call CBA_fnc_waitUntilAndExecute;
	};
};
