#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_position",[],[[]]],["_player",objNull,[objNull]],["_objectData",[],[[]]],["_amount",1,[0]]];
_objectData params ["_objClass","_objText","_objInitFnc"];

if (isNull _entity) exitWith {};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(logisticsStartAirdrop),2];
};

if ((_entity getVariable "SSS_cooldown") > 0) exitWith {
	NOTIFY_NOT_READY_COOLDOWN(_entity);
};

["SSS_requestSubmitted",[_entity,[_position,_objectData,_amount]]] call CBA_fnc_globalEvent;

[_entity,_entity getVariable "SSS_cooldownDefault",localize LSTRING(ReadyForNewRequests)] call EFUNC(common,cooldown);

private _classname = _entity getVariable "SSS_classname";
private _flyingHeight = _entity getVariable "SSS_flyingHeight";
private _spawnDelay = _entity getVariable "SSS_spawnDelay";
private _spawnPosition = _entity getVariable "SSS_spawnPosition";

if (_spawnPosition isEqualTo []) then {
	_spawnPosition = _position getPos [6000,floor random 360];
};

_spawnPosition set [2,_position # 2 + _flyingHeight];

private _ETA = [_spawnDelay + ((_spawnPosition distance2D _position) / (getNumber (configFile >> "CfgVehicles" >> _classname >> "maxSpeed") / 3.6)),true] call EFUNC(common,properTime);
NOTIFY(_entity,FORMAT_2(localize LSTRING(AirdropInboundETA),_objText,_ETA));

// Update task marker
[_entity,true,_position] call EFUNC(common,updateMarker);

[{
	params ["_entity","_position","_player","_objectData","_amount","_classname","_flyingHeight","_spawnPosition"];

	private _vehicle = createVehicle [_classname,_spawnPosition,[],0,"FLY"];
	(createVehicleCrew _vehicle) deleteGroupWhenEmpty true;
	private _group = createGroup [_entity getVariable "SSS_side",true];
	crew _vehicle joinSilent _group;
	_vehicle setDir (_spawnPosition getDir _position);
	_vehicle setPos _spawnPosition;
	_vehicle setVelocityModelSpace [0,150,0];
	_vehicle allowFleeing 0;
	_vehicle setBehaviour "CARELESS";
	_vehicle setCombatMode "BLUE";
	{
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
	} forEach crew _vehicle;
	_vehicle lockDriver true;
	_vehicle setVariable ["SSS_parentEntity",_entity,true];
	_entity setVariable ["SSS_vehicle",_vehicle,true];
	_group setVariable ["SSS_protectWaypoints",true,true];

	_vehicle setVariable ["SSS_WPDone",false];
	private _WP = _group addWaypoint [_position,0];
	_WP setWaypointType "MOVE";
	_WP setWaypointSpeed "FULL";
	_WP setWaypointStatements ["true","(vehicle this) setVariable ['SSS_WPDone',true];"];
	_vehicle flyInHeight _flyingHeight;

	[{
		params ["_entity","_vehicle"];

		isNull _entity || !alive _vehicle || {_vehicle getVariable "SSS_WPDone"}
	},{
		params ["_entity","_vehicle","_player","_spawnPosition","_objectData","_amount"];
		_objectData params ["_objClass","_objText","_objInitFnc"];

		// Remove marker
		[_entity,false] call EFUNC(common,updateMarker);

		if (!alive _vehicle) exitWith {};

		private _WP = group _vehicle addWaypoint [_vehicle getRelPos [600 + (_amount * 200),0],0];
		_WP setWaypointType "MOVE";
		_WP setWaypointSpeed "FULL";
		private _returnWP = group _vehicle addWaypoint [_spawnPosition,0];
		_returnWP setWaypointType "MOVE";
		_returnWP setWaypointSpeed "FULL";
		_returnWP setWaypointStatements ["true","
			private _vehicle = vehicle this;
			{_vehicle deleteVehicleCrew _x} forEach crew _vehicle;
			deleteVehicle _vehicle;
		"];
		
		_vehicle setVariable ["SSS_amountLeft",_amount];

		[{
			params ["_args","_PFHID"];
			_args params ["_entity","_vehicle","_player","_objClass","_objText","_objInitFnc"];

			if (isNull _entity || !alive _vehicle) exitWith {};

			private _amountLeft = _vehicle getVariable "SSS_amountLeft";
			private _objects = _vehicle getVariable "SSS_objects";

			if (_amountLeft <= 0) exitWith {
				_PFHID call CBA_fnc_removePerFrameHandler;

				_vehicle flyInHeight ((_entity getVariable "SSS_flyingHeight") * 2);

				NOTIFY(_entity,FORMAT_1(localize LSTRING(ObjectDropped),_objText);
				["SSS_requestCompleted",[_entity,[_objects]]] call CBA_fnc_globalEvent;
			};

			private _dropPos = _vehicle getRelPos [10,180];
			_dropPos set [2,getPos _vehicle # 2];

			private _object = if (_objClass isKindOf "CAManBase") then {
				private _parachute = createVehicle ["NonSteerable_Parachute_F",_dropPos,[],0,"NONE"];
				_parachute allowDamage false;
				_parachute setDir getDir _vehicle;

				private _group = _vehicle getVariable ["SSS_objectsGroup",grpNull];
				
				if (isNull _group) then {
					private _side = [east,west,independent,civilian] # (getNumber (configFile >> "CfgVehicles" >> _objClass >> "side"));
					_group = createGroup [_side,true];
					_vehicle setVariable ["SSS_objectsGroup",_group];
				};
				
				private _object = _group createUnit [_objClass,_dropPos,[],0,"NONE"];
				_object allowDamage false;
				_object setDir getDir _vehicle;
				_object moveInDriver _parachute;

				[{{_x allowDamage true} forEach _this},[_object,_parachute],2] call CBA_fnc_waitAndExecute;
				[{{isNull _x} count _this > 0},{deleteVehicle (_this # 1)},[_object,_parachute]] call CBA_fnc_waitUntilAndExecute;
				[{
					if (isNull _this) exitWith {};

					_this setVelocityModelSpace [0,30,0];
				},_parachute] call CBA_fnc_execNextFrame;

				_object
			} else {
				private _parachute = createVehicle ["B_Parachute_02_F",_dropPos,[],0,"NONE"];
				_parachute allowDamage false;
				_parachute setDir getDir _vehicle;

				private _object = createVehicle [_objClass,_dropPos,[],0,"NONE"];
				_object allowDamage false;
				_object setDir getDir _vehicle;
				_object attachTo [_parachute,[0,0,abs ((0 boundingBoxReal _object) # 0 # 2)]];

				[{{_x allowDamage true} forEach _this},[_object,_parachute],2] call CBA_fnc_waitAndExecute;
				[{!alive _this || {getPos _this # 2 < 2}},{
					if (!alive _this) exitWith {};
					_this allowDamage false;
					[{_this allowDamage true},_this,3.5] call CBA_fnc_waitAndExecute;
				},_object] call CBA_fnc_waitUntilAndExecute;
				
				[{{isNull _x} count _this > 0},{deleteVehicle (_this # 1)},[_object,_parachute]] call CBA_fnc_waitUntilAndExecute;
				[{
					if (isNull _this) exitWith {};
					_this setVelocityModelSpace [0,30,0];

					[{
						_this setVectorUp [0,0,1];
						isNull _this || {getPos _this # 2 < 2}
					},{},_this] call CBA_fnc_waitUntilAndExecute;
				},_parachute] call CBA_fnc_execNextFrame;

				// Landing signal
				private _signalColor = [0,"yellow","green","red","blue"] # (_entity getVariable "SSS_landingSignal");

				if (_signalColor isEqualType "") then {
					[{
						params ["_object","_signalColor"];

						isNull _object || {getPos _object # 2 < 1}
					},{
						params ["_object","_signalColor"];

						if (isNull _object) exitWith {};
						
						(date call BIS_fnc_sunriseSunsetTime) params ["_sunrise","_sunset"];
						
						if (daytime > _sunrise && daytime < _sunset) then {
							("SmokeShell" + _signalColor) createVehicle getPos _object;
						} else {
							("ACE_G_Chemlight_Hi" + _signalColor) createVehicle getPos _object;
						};
					},[_object,_signalColor]] call CBA_fnc_waitUntilAndExecute;
				};

				_object
			};

			_objects pushBack _object;
			_vehicle setVariable ["SSS_objects",_objects];
			_vehicle setVariable ["SSS_amountLeft",_amountLeft - 1];

			_object setVariable ["SSS_requester",_player,true];

			// Custom inits
			_object call _objInitFnc;
			_object call (_entity getVariable ["SSS_universalInitFnc",{}]);
		},0.6,[_entity,_vehicle,_player,_objClass,_objText,_objInitFnc]] call CBA_fnc_addPerFrameHandler;
	},[_entity,_vehicle,_player,_spawnPosition,_objectData,_amount]] call CBA_fnc_waitUntilAndExecute;

	_vehicle call (_entity getVariable "SSS_customInit");
},[_entity,_position,_player,_objectData,_amount,_classname,_flyingHeight,_spawnPosition],_spawnDelay] call CBA_fnc_waitAndExecute;
