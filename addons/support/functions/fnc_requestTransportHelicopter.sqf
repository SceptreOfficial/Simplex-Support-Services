#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_request","",[""]],["_position",[],[[]]],["_extraParams",[],[[]]]];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {
	_vehicle call EFUNC(common,respawn);
};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestTransportHelicopter),_vehicle];
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
			[_vehicle,_position,0,"MOVE","CARELESS","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_pad"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
					deleteVehicle _pad;
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				[{_this land "LAND"},_vehicle] call CBA_fnc_execNextFrame;

				// Execute land again if helicopter unresponsive
				[{
					params ["_entity","_vehicle","_landStartPosASL"];

					if (CANCEL_CONDITION) exitWith {};

					if (getPosASLVisual _vehicle distance _landStartPosASL < 8 && getPos _vehicle # 2 > 1) then {
						_vehicle land "LAND";
					};
				},[_entity,_vehicle,getPosASLVisual _vehicle],8] call CBA_fnc_waitAndExecute;

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
					[{deleteVehicle _this},_pad,10] call CBA_fnc_waitAndExecute;

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
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_request"];

			private _nearestPads = nearestObjects [_position,[
				"Land_HelipadSquare_F","Land_HelipadRescue_F",
				"Land_HelipadCivil_F","Land_HelipadCircle_F",
				"Land_HelipadEmpty_F","HeliH",
				"HeliHCivil","HeliHRescue"
			],35];

			private _deletePad = false;
			private _pad = if (_nearestPads isEqualTo []) then {
				_deletePad = true;

				private _intersect = (lineIntersectsSurfaces [[_position # 0,_position # 1,getPosASL _vehicle # 2 + 100],ATLToASL [_position # 0,_position # 1,0],_vehicle]) # 0 # 0;
				private _surfacePositionASL = if (isNil "_intersect") then {
					AGLtoASL _position
				} else {
					_intersect
				};

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
				params ["_entity","_vehicle","_pad","_deletePad","_request"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
					if (_deletePad) then {
						deleteVehicle _pad;
					};
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				
				if (_request == "LAND_ENG_OFF") then {
					[{_this land "LAND"},_vehicle] call CBA_fnc_execNextFrame;
				} else {
					[{_this land "GET IN"},_vehicle] call CBA_fnc_execNextFrame;
				};

				[{WAIT_UNTIL_LAND},{
					params ["_entity","_vehicle","_pad","_deletePad","_request"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity);
						_vehicle doFollow _vehicle;
						_vehicle land "NONE";
						if (_deletePad) then {
							deleteVehicle _pad;
						};
					};

					END_ORDER(_entity,localize LSTRING(LandedAtLocation));

					if (_deletePad) then {
						[{deleteVehicle _this},_pad,60] call CBA_fnc_waitAndExecute;
					};

					["SSS_requestCompleted",[_entity,[_request]]] call CBA_fnc_globalEvent;
				},[_entity,_vehicle,_pad,_deletePad,_request]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle,_pad,_deletePad,_request]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_request]] call CBA_fnc_waitUntilAndExecute;
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
	
	case "HOVER" : {
		_extraParams params ["_hoverHeight","_doFastrope"];

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_hoverHeight","_doFastrope"];

			private _message = if (_doFastrope) then {
				format [localize LSTRING(MovingLocationFastrope),_hoverHeight]
			} else {
				format [localize LSTRING(MovingLocationHover),_hoverHeight]
			};

			BEGIN_ORDER(_entity,_position,_message);

			if (getPos _vehicle # 2 < 2 && !isEngineOn _vehicle) then {
				_vehicle engineOn true;
				_vehicle doMove _position;
			};

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_position","_hoverHeight","_doFastrope"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				// Begin precision hover
				[_entity,_vehicle,_position,_hoverHeight,_doFastrope] call FUNC(transportHover);

				[{
					params ["_entity","_vehicle"];
					_vehicle getVariable ["SSS_hoverDone",false] || CANCEL_CONDITION
				},{
					params ["_entity","_vehicle","_doFastrope"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity);
						_vehicle setVariable ["SSS_hoverDone",true,true];
					};

					// End order without notify (handled in fnc_transportHover)
					_entity setVariable ["SSS_onTask",false,true];
					[_entity,false] call EFUNC(common,updateMarker);

				},[_entity,_vehicle,_doFastrope]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle,_position,_hoverHeight,_doFastrope]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_hoverHeight,_doFastrope]] call CBA_fnc_waitUntilAndExecute;
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

	case "SLINGLOAD" : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			BEGIN_ORDER(_entity,_position,localize LSTRING(MovingToSlingLoadingArea));
			_entity setVariable ["SSS_slingLoadPosition",_position,true];

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
					_entity setVariable ["SSS_slingLoadPosition",nil,true];
				};

				NOTIFY(_entity,localize LSTRING(ArrivedAtSlingLoadLocation));
				_entity setVariable ["SSS_slingLoadReady",true,true];

				[{
					params ["_entity","_vehicle"];

					isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || !(_entity getVariable "SSS_slingLoadReady")}}
				},{
					params ["_entity","_vehicle"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity);
						_entity setVariable ["SSS_slingLoadPosition",nil,true];
						_entity setVariable ["SSS_slingLoadReady",false,true];
					};

					private _object = _entity getVariable ["SSS_slingLoadObject",objNull];
					_entity setVariable ["SSS_slingLoadObject",objNull,true];
					_entity setVariable ["SSS_slingLoadPosition",nil,true];

					if (isNull _object) then {
						END_ORDER(_entity,localize LSTRING(SlingLoadCancelled));
						["SSS_requestCompleted",[_entity,["SLINGLOAD",objNull]]] call CBA_fnc_globalEvent;
					} else {
						if (!local _object) then {
							[[_object,_vehicle],{
								params ["_object","_vehicle"];
								_object setOwner owner _vehicle;
							}] remoteExecCall ["call",2];
						};

						private _WP = (group _vehicle) addWaypoint [getPos _object,0];
						_WP setWaypointType "HOOK";

						NOTIFY(_entity,localize LSTRING(SlingLoadingObject));

						[{
							params ["_entity","_vehicle"];

							isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || !isNull getSlingLoad _vehicle}}
						},{
							params ["_entity","_vehicle"];

							if (CANCEL_CONDITION) exitWith {
								CANCEL_ORDER(_entity);
							};

							END_ORDER(_entity,localize LSTRING(ObjectSlingLoaded));
							["SSS_requestCompleted",[_entity,["SLINGLOAD",getSlingLoad _vehicle]]] call CBA_fnc_globalEvent;
						},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
					};
				},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};

	case "UNHOOK" : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			BEGIN_ORDER(_entity,_position,localize LSTRING(MovingToPositionToDetach));

			private _pad = "Land_HelipadEmpty_F" createVehicle _position;

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"UNHOOK","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_pad"];

				deleteVehicle _pad;

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				END_ORDER(_entity,localize LSTRING(LoadDetached));

				["SSS_requestCompleted",[_entity,["UNHOOK"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;
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
			(group _vehicle) addWaypoint [_position getPos [5000,_vehicle getDir _position],0];
			(group _vehicle) addWaypoint [_position,100];
			
			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_position","_jumpDelay","_AIOpeningHeight"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				[_entity,_vehicle,_jumpDelay,_AIOpeningHeight] call FUNC(transportParadrop);

				END_ORDER(_entity,localize LSTRING(GoGoGo));

				["SSS_requestCompleted",[_entity,["PARADROP"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle,_position,_jumpDelay,_AIOpeningHeight]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_jumpDelay,_AIOpeningHeight]] call CBA_fnc_waitUntilAndExecute;
	};
};
