#include "script_component.hpp"

params ["_vehicle"];

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(respawn),2];
};

private _entity = _vehicle getVariable ["SSS_parentEntity",objNull];
if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable "SSS_vehicle";
if (isNull _vehicle) exitWith {};

private _respawnTime = _entity getVariable ["SSS_respawnTime",-1];
if (_respawnTime < 0) exitWith {
	deleteVehicle _entity;
};

if (_entity getVariable "SSS_respawning") exitWith {};
_entity setVariable ["SSS_respawning",true,true];

_vehicle call FUNC(decommission);
_entity setVariable ["SSS_vehicle",objNull,true];

private _group = group _vehicle;
_group setVariable ["SSS_protectWaypoints",nil,true];

if (SSS_setting_cleanupCrew) then {
	{_vehicle deleteVehicleCrew _x} forEach PRIMARY_CREW(_vehicle);
	{deleteVehicle _x} forEach units _group;
} else {
	[_group,_vehicle] remoteExecCall ["leaveVehicle",_vehicle];
	[PRIMARY_CREW(_vehicle),false] remoteExecCall ["orderGetIn",_vehicle];
};

private _message = format [LLSTRING(VehicleReplacementETA),PROPER_TIME(_respawnTime)];
NOTIFY(_entity,_message);

[{
	params ["_entity"];

	if (isNull _entity) exitWith {};
	
	private _classname = _entity getVariable "SSS_classname";
	private _base = _entity getVariable "SSS_base";

	// Clear obstructions
	{
		private _obj = _x;
		if ((!alive _obj || {alive _x} count crew _obj == 0) && {_obj isKindOf "LandVehicle" || _obj isKindOf "Air" || _obj isKindOf "Ship"}) then {
			{_obj deleteVehicleCrew _x} forEach crew _obj;
			deleteVehicle _obj;
		};
	} forEach (ASLToAGL _base nearObjects ((sizeOf _classname) * 0.7));

	[{
		params ["_entity","_base","_classname"];

		// Create vehicle
		private _group = createGroup [_entity getVariable "SSS_side",true];
		private _vehicle = createVehicle [_classname,ASLToAGL _base,[],0,"NONE"];
		(createVehicleCrew _vehicle) deleteGroupWhenEmpty true;
		crew _vehicle joinSilent _group;
		_group addVehicle _vehicle;
		_vehicle setDir (_entity getVariable "SSS_baseDir");

		// Assign/Commission vehicle
		_vehicle setVariable ["SSS_parentEntity",_entity,true];
		_entity setVariable ["SSS_vehicle",_vehicle,true];
		_group setVariable ["SSS_protectWaypoints",true,true];
		[_vehicle,"Deleted",{_this call FUNC(deletedVehicle)}] call CBA_fnc_addBISEventHandler;
		[_vehicle,"Killed",{(_this # 0) call FUNC(respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
		[_entity,_vehicle] call FUNC(commission);

		switch (_entity getVariable "SSS_supportType") do {
			case "artillery" : {
				[gunner _vehicle,"Killed",{vehicle (_this # 0) call FUNC(respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
				[_vehicle,"GetOut",{
					params ["_vehicle","_role"];

					if (_role == "gunner") then {
						_vehicle removeEventHandler [_thisType,_thisID];
						_vehicle call FUNC(respawn);
					};
				}] call CBA_fnc_addBISEventHandler;
			};

			case "CASHelicopter";
			case "transportHelicopter";
			case "transportLandVehicle";
			case "transportMaritime";
			case "transportVTOL" : {
				_entity setVariable ["SSS_awayFromBase",false,true];
				_entity setVariable ["SSS_onTask",false,true];
				_entity setVariable ["SSS_interrupt",false,true];

				[driver _vehicle,"Killed",{vehicle (_this # 0) call FUNC(respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
				[_vehicle,"GetOut",{
					params ["_vehicle","_role"];

					if (_role == "driver") then {
						_vehicle removeEventHandler [_thisType,_thisID];
						_vehicle call FUNC(respawn);
					};
				}] call CBA_fnc_addBISEventHandler;
			};

			case "transportPlane" : {
				_vehicle setFuel 0;
				_entity setVariable ["SSS_awayFromBase",false,true];
				_entity setVariable ["SSS_onTask",false,true];
				_entity setVariable ["SSS_interrupt",false,true];

				[driver _vehicle,"Killed",{vehicle (_this # 0) call FUNC(respawn)}] remoteExecCall ["CBA_fnc_addBISEventHandler",0];
				[_vehicle,"GetOut",{
					params ["_vehicle","_role"];

					if (_role == "driver") then {
						_vehicle removeEventHandler [_thisType,_thisID];
						_vehicle call FUNC(respawn);
					};
				}] call CBA_fnc_addBISEventHandler;
			};
		};

		_entity setVariable ["SSS_respawning",false,true];
		NOTIFY(_entity,LLSTRING(VehicleReplacementArrived));

		// Execute custom code
		_vehicle call (_entity getVariable "SSS_customInit");
	},[_entity,_base,_classname],1] call CBA_fnc_waitAndExecute;
},[_entity],_respawnTime] call CBA_fnc_waitAndExecute;
