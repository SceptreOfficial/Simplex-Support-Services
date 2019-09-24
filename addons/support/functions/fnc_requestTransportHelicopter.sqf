#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_request",0,[0]],["_position",[],[[]]],["_extraParams",[],[[]]]];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {
	_vehicle call EFUNC(common,respawn);
};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestTransportHelicopter),_vehicle];
};

switch (_request) do {
	// RTB
	case 0 : {
		if !(_entity getVariable "SSS_awayFromBase") exitWith {};

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle"];

			private _position = getPos (_entity getVariable "SSS_base");

			// Begin order
			_entity setVariable ["SSS_onTask",true,true];
			[_entity,true,_position] call EFUNC(common,updateMarker);
			NOTIFY(_entity,"Returning to base.");

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","CARELESS","YELLOW","NORMAL","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity,"RTB");
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				_vehicle land "LAND";

				[{WAIT_UNTIL_LAND},{
					params ["_entity","_vehicle"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity,"RTB");
						_vehicle doFollow _vehicle;
						_vehicle land "NONE";
					};

					END_ORDER(_entity,"Arrived at base. Ready for further tasking.");
					_entity setVariable ["SSS_awayFromBase",false,true];
					_vehicle setFuel 1;
					_vehicle setVehicleAmmo 1;
					_vehicle setDamage 0;
					_vehicle engineOn false;
					_vehicle doFollow _vehicle;

				},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
	};
	// Pickup
	case 1 : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			BEGIN_ORDER(_entity,_position,"Heading to pickup location. Prepare to signal on arrival.");

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			private _prepDist = [100,300] select (_vehicle distance2D _position > 300);
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_position"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity,"Pickup");
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
	// Land / Land (eng off)
	case 2;
	case 3 : {
		private _engineOn = _request isEqualTo 2;

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_engineOn"];

			private _nearestPads = nearestObjects [_position,[
				"Land_HelipadSquare_F","Land_HelipadRescue_F",
				"Land_HelipadCivil_F","Land_HelipadCircle_F",
				"Land_HelipadEmpty_F","HeliH",
				"HeliHCivil","HeliHRescue"
			],35];

			private _pad = if (_nearestPads isEqualTo []) then {
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
			
			BEGIN_ORDER(_entity,_position,"Heading to the LZ.");

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,getPos _pad,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_pad","_engineOn"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity,"Landing");
					deleteVehicle _pad;
				};

				// Begin landing
				(group _vehicle) setSpeedMode "LIMITED";
				doStop _vehicle;
				_vehicle land "GET IN";

				[{WAIT_UNTIL_LAND},{
					params ["_entity","_vehicle","_pad","_engineOn"];

					if (CANCEL_CONDITION) exitWith {
						CANCEL_ORDER(_entity,"Landing");
						_vehicle doFollow _vehicle;
						_vehicle land "NONE";
						deleteVehicle _pad;
					};

					END_ORDER(_entity,"Landed at location. Ready for further tasking.");

					if (!_engineOn) then {
						_vehicle engineOn false;
					};

					[{
						params ["_entity","_vehicle"];
						isNull _entity || !alive _vehicle || !alive driver _vehicle || _entity getVariable "SSS_onTask"
					},{
						deleteVehicle (_this # 2);
					},[_entity,_vehicle,_pad]] call CBA_fnc_waitUntilAndExecute;

				},[_entity,_vehicle,_pad,_engineOn]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle,_pad,_engineOn]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_engineOn]] call CBA_fnc_waitUntilAndExecute;
	};
	// Move
	case 4 : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			BEGIN_ORDER(_entity,_position,"Moving to requested location.");

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity,"Move");
				};

				END_ORDER(_entity,"Destination reached. Ready for further tasking.");

			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};
	// Hover / Fastrope
	case 5 : {
		_extraParams params ["_hoverHeight","_doFastrope"];

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_hoverHeight","_doFastrope"];

			private _message = if (_doFastrope) then {
				format ["Moving to location to fastrope from %1m.",_hoverHeight]
			} else {
				format ["Moving to location to hover at %1m.",_hoverHeight]
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
					private _task = ["Hover","Fastope"] select _doFastrope;
					CANCEL_ORDER(_entity,_task);
				};

				// Begin precision hover
				[_entity,_vehicle,_position,_hoverHeight,_doFastrope] call FUNC(transportHover);

				[{
					params ["_entity","_vehicle"];
					_vehicle getVariable ["SSS_hoverDone",false] || CANCEL_CONDITION
				},{
					params ["_entity","_vehicle","_doFastrope"];

					if (CANCEL_CONDITION) exitWith {
						private _task = ["Hover","Fastope"] select _doFastrope;
						CANCEL_ORDER(_entity,_task);
						_vehicle setVariable ["SSS_hoverDone",true,true];
					};

					// End order without notify (handled in fnc_transportHover)
					_entity setVariable ["SSS_onTask",false,true];
					[_entity,false] call EFUNC(common,updateMarker);

				},[_entity,_vehicle,_doFastrope]] call CBA_fnc_waitUntilAndExecute;
			},[_entity,_vehicle,_position,_hoverHeight,_doFastrope]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_hoverHeight,_doFastrope]] call CBA_fnc_waitUntilAndExecute;
	};
	// Loiter
	case 6 : {
		_extraParams params ["_loiterRadius","_loiterDirection"];

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_loiterRadius","_loiterDirection"];

			BEGIN_ORDER(_entity,_position,"Moving to requested location to loiter.");

			private _prepDist = [100,_loiterRadius + 100] select (_vehicle distance2D _position > (_loiterRadius + 100));
			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","","","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle","_position","_loiterRadius","_loiterDirection"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity,"Loiter");
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
				NOTIFY(_entity,"Destination reached. Loitering until further tasking.");

			},[_entity,_vehicle,_position,_loiterRadius,_loiterDirection]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position,_loiterRadius,_loiterDirection]] call CBA_fnc_waitUntilAndExecute;
	};
};
