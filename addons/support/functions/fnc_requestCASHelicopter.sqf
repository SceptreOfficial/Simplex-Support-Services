#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_request","",[""]],["_position",[],[[]]],["_extraParams",[],[[]]]];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

if (isNil {(group _vehicle) getVariable "SSS_protectWaypoints"}) exitWith {
	_vehicle call EFUNC(common,respawn);
};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(requestCASHelicopter),_vehicle];
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
			[_vehicle,_position,0,"MOVE","CARELESS","YELLOW","FULL","",WP_DONE] call EFUNC(common,addWaypoint);

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
	
	case "SAD" : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			BEGIN_ORDER(_entity,_position,localize LSTRING(HeadingToLocationToProvideCAS));

			private _group = group _vehicle;
			_group allowFleeing 0;

			// Reveal area
			{_group reveal _x} forEach (_position nearEntities 500);

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"SAD","COMBAT","RED","","",WP_DONE] call EFUNC(common,addWaypoint);

			[{
				params ["_entity","_vehicle","_position"];
				isNull _entity || {_entity getVariable "SSS_interrupt" || {!alive _vehicle || !alive driver _vehicle || _vehicle distance2D _position < 500}}
			},{
				params ["_entity","_vehicle","_position"];

				if (CANCEL_CONDITION) exitWith {};

				// Reveal area again
				private _group = group _vehicle;
				{_group reveal _x} forEach (_position nearEntities 500);

				_vehicle flyInHeight (_entity getVariable "SSS_flyingHeight");
			},[_entity,_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;

			[{WAIT_UNTIL_WPDONE},{
				params ["_entity","_vehicle"];

				if (CANCEL_CONDITION) exitWith {
					CANCEL_ORDER(_entity);
				};

				END_ORDER(_entity,localize LSTRING(SearchAndDestroyComplete));

				// RTB
				[_entity,"RTB"] call FUNC(requestCASHelicopter);

				["SSS_requestCompleted",[_entity,["SAD"]]] call CBA_fnc_globalEvent;
			},[_entity,_vehicle]] call CBA_fnc_waitUntilAndExecute;
		},[_entity,_vehicle,_position]] call CBA_fnc_waitUntilAndExecute;
	};
	
	case "MOVE" : {
		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position"];

			BEGIN_ORDER(_entity,_position,localize LSTRING(MovingToRequestLocation));

			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position,0,"MOVE","CARELESS","YELLOW","NORMAL","",WP_DONE] call EFUNC(common,addWaypoint);

			// Reveal area
			private _group = group _vehicle;
			{_group reveal _x} forEach (_position nearEntities 500);

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
	
	case "LOITER" : {
		_extraParams params ["_loiterRadius","_loiterDirection"];

		INTERRUPT(_entity,_vehicle);

		[{!((_this # 0) getVariable "SSS_onTask")},{
			params ["_entity","_vehicle","_position","_loiterRadius","_loiterDirection"];

			BEGIN_ORDER(_entity,_position,localize LSTRING(MovingToRequestLocationLoiter));

			private _prepDist = [100,_loiterRadius + 100] select (_vehicle distance2D _position > (_loiterRadius + 100));
			_vehicle setVariable ["SSS_WPDone",false];
			[_entity,_vehicle] call EFUNC(common,clearWaypoints);
			[_vehicle,_position getPos [_prepDist,_position getDir _vehicle],0,"MOVE","CARELESS","YELLOW","NORMAL","",WP_DONE] call EFUNC(common,addWaypoint);

			// Reveal area
			private _group = group _vehicle;
			{_group reveal _x} forEach (_position nearEntities 500);

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
	
	case "GUN_RUN" : {};
};
