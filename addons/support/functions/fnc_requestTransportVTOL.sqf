#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_request","",[""]],["_position",[],[[]]],["_extraParams",[],[[]]]];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {
	_vehicle call EFUNC(common,respawn);
};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestTransportVTOL),_vehicle];
};

["SSS_requestSubmitted",[_entity,[_request,_position,_extraParams]]] call CBA_fnc_globalEvent;

switch (toUpper _request) do {
	case "RTB" : {
		if !(_entity getVariable "SSS_awayFromBase") exitWith {};

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle"];

			private _base = _entity getVariable "SSS_base";
			private _position = ASLToAGL _base;
			private _pad = "Land_HelipadEmpty_F" createVehicle _position;
			_pad setPosASL _base;

			// Begin order
			_entity setVariable ["SSS_onTask",true,true];
			[_entity,true,_position] call EFUNC(common,updateMarker);
			NOTIFY(_entity,localize LSTRING(ReturningToBase));

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE,[2,2,2]] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_pad"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
					deleteVehicle _pad;
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				_vehicle land "LAND";

				[{WAIT_UNTIL_LAND},{
					params ["_entity","_vehicle","_pad"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity);
						_vehicle doFollow _vehicle;
						_vehicle land "NONE";
						deleteVehicle _pad;
					};

					END_ORDER(_entity,localize LSTRING(ArrivedAtBase));
					_entity setVariable ["SSS_awayFromBase",false,true];
					_vehicle engineOn false;
					_vehicle doFollow _vehicle;
					deleteVehicle _pad;

					[_entity,_vehicle] call EFUNC(common,resetOnRTB);

					["SSS_requestCompleted",[_entity,["RTB"]]] call CBA_fnc_globalEvent;
				},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
	};

	case "PICKUP" : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			BEGIN_ORDER(_entity,_position,localize LSTRING(HeadingToPickupLocationPrepareSignal));

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			private _prepDist = [100,300] select (_vehicle distance2D _position > 300);
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_position"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				// Loiter until smoke found
				(group _vehicle) setSpeedMode "LIMITED";
				private _WP = (group _vehicle) addWaypoint [_position,0];
				_WP setWaypointType "LOITER";
				_WP setWaypointLoiterRadius 200;
				_WP setWaypointLoiterType (["CIRCLE","CIRCLE_L"] # (floor random 2));
				_WP setWaypointSpeed "LIMITED";

				// Carry on with external function
				[_entity,_vehicle,_position,true] call FUNC(transportSmokeSignal);

			},[_entity,_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};

	case "LAND";
	case "LAND_ENG_OFF" : {
		private _engineOn = _request == "LAND";

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_engineOn"];

			private _nearestPads = nearestObjects [_position,[
				"Land_HelipadSquare_F","Land_HelipadRescue_F",
				"Land_HelipadCivil_F","Land_HelipadCircle_F",
				"Land_HelipadEmpty_F","HeliH",
				"HeliHCivil","HeliHRescue"
			],35];

			private _deletePad = false;
			private _pad = if (_nearestPads isEqualTo []) then {
				_deletePad = true;
				private _dummy = (createGroup sideLogic) createUnit ["Logic",[0,0,0],[],0,"CAN_COLLIDE"];
				_dummy setPosASL [_position # 0,_position # 1,9999];
				private _surfacePositionASL = [_position # 0,_position # 1,9999 - (getPos _dummy # 2)];
				deleteVehicle _dummy;

				private _pad = "Land_HelipadEmpty_F" createVehicle _position;
				_pad setPosASL _surfacePositionASL;
				_pad
			} else {
				_nearestPads # 0
			};

			BEGIN_ORDER(_entity,_position,localize LSTRING(HeadingToLZ));

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,getPos _pad,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_pad","_deletePad","_engineOn"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
					if (_deletePad) then {
						deleteVehicle _pad;
					};
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				_vehicle land "GET IN";

				[{WAIT_UNTIL_LAND},{
					params ["_entity","_vehicle","_pad","_deletePad","_engineOn"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity);
						_vehicle doFollow _vehicle;
						_vehicle land "NONE";
						if (_deletePad) then {
							deleteVehicle _pad;
						};
					};

					END_ORDER(_entity,localize LSTRING(LandedAtLocation));

					private _requestName = if (_engineOn) then {
						group _vehicle setBehaviour "AWARE"; // VTOLs ignore engineOn command otherwise

						[{
							params ["_entity","_vehicle"];
							isNull _entity || {_entity getVariable "SSS_onTask" || {!alive _vehicle || !alive driver _vehicle}}
						},{
							params ["_entity","_vehicle"];
							group _vehicle setBehaviour "CARELESS";
						},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;

						[{_this engineOn true},{},_vehicle,3] call CBA_fnc_waitUntilAndExecute;
						"LAND"
					} else {
						_vehicle engineOn false;
						"LAND_ENG_OFF"
					};

					if (_deletePad) then {
						[{deleteVehicle _this},_pad,5] call CBA_fnc_waitAndExecute;
					};

					["SSS_requestCompleted",[_entity,[_requestName]]] call CBA_fnc_globalEvent;
				},[_entity,_vehicle,_pad,_deletePad,_engineOn]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle,_pad,_deletePad,_engineOn]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_engineOn]] call CBA_fnc_waitUntilAndExecute;
	};

	case "MOVE" : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

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
