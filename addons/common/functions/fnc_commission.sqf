#include "script_component.hpp"
#define VEHICLE_ACTION_CONDITION \
	params ["_target","_player","_entity"]; \
	if (!alive _target || !alive driver _target || isNull _entity) exitWith {false}; \
	if (ADMIN_ACCESS_CONDITION) then { \
		if (SSS_setting_adminLimitSide) then { \
			side _target == side _player \
		} else { \
			true \
		}; \
	} else { \
		_entity in (_player getVariable ["SSS_assignedEntities",[]]) \
	};

params [["_entity",objNull,[objNull]],["_vehicle",objNull,[objNull]]];

if (isNull _entity || isNull _vehicle) exitWith {};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(commission),_vehicle];
};

_vehicle setDamage 0;
_vehicle setFuel 1;
_vehicle setVehicleAmmo 1;
_vehicle lockDriver true;
_vehicle allowFleeing 0;

{
	_x setSkill 1;
	_x allowFleeing 0;
	_x disableAI "SUPPRESSION";
	_x disableAI "COVER";
} forEach PRIMARY_CREW(_vehicle);

private _group = group _vehicle;

switch (_entity getVariable "SSS_supportType") do {
	case "artillery" : {
		{_x disableAI "PATH"} forEach PRIMARY_CREW(_vehicle);
		_vehicle lockTurret [[0],true];
		_vehicle lockCargo true;

		_group enableAttack true;
		_group setBehaviour "COMBAT";
	};

	case "CASHelicopter" : {
		{
			_x disableAI "LIGHTS";
			_x disableAI "AUTOCOMBAT";
		} forEach PRIMARY_CREW(_vehicle);
		_vehicle lockTurret [[0],true];
		_vehicle lockCargo true;
		_vehicle lock true;

		_vehicle flyInHeight (_entity getVariable ["SSS_flyingHeight",180]);
		_vehicle setPilotLight (_entity getVariable ["SSS_lightsOn",true]);
		_vehicle setCollisionLight (_entity getVariable ["SSS_collisionLightsOn",true]);

		_group enableAttack true;

		// FRIES makes AI pilots a nightmare
		private _fries = _vehicle getVariable ["ace_fastroping_FRIES",objnull];
		if (!isNull _fries) then {
			deleteVehicle _fries;
		};
	};

	case "transportHelicopter" : {
		{
			_x disableAI "LIGHTS";
			_x disableAI "AUTOCOMBAT";
		} forEach PRIMARY_CREW(_vehicle);

		_vehicle flyInHeight (_entity getVariable ["SSS_flyingHeight",180]);
		_vehicle setPilotLight (_entity getVariable ["SSS_lightsOn",true]);
		_vehicle setCollisionLight (_entity getVariable ["SSS_collisionLightsOn",true]);

		_group setBehaviour "CARELESS";
		_group setSpeedMode (["LIMITED","NORMAL","FULL"] select (_entity getVariable ["SSS_speedMode",1]));
	
		if ((_entity getVariable ["SSS_combatMode",1]) isEqualTo 0) then {
			_group setCombatMode "YELLOW";
			_group enableAttack true;
			{
				_x enableAI "TARGET";
				_x enableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		} else {
			_group setCombatMode "BLUE";
			_group enableAttack false;
			{
				_x disableAI "TARGET";
				_x disableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		};

		private _action = ["SSS_transport","Transport",ICON_TRANSPORT,{},{VEHICLE_ACTION_CONDITION},{
			_this call EFUNC(interaction,childActionsTransportHelicopter)
		},_entity] call ace_interact_menu_fnc_createAction;

		[_vehicle,1,["ACE_SelfActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
		[_vehicle,0,["ACE_MainActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];

		// FRIES makes AI pilots a nightmare
		private _fries = _vehicle getVariable ["ace_fastroping_FRIES",objnull];
		if (!isNull _fries) then {
			deleteVehicle _fries;
		};
	};

	case "transportLandVehicle" : {
		{
			_x disableAI "LIGHTS";
		} forEach PRIMARY_CREW(_vehicle);

		_vehicle setPilotLight (_entity getVariable ["SSS_lightsOn",true]);

		//_group setBehaviour "SAFE";
		_group setSpeedMode (["LIMITED","NORMAL","FULL"] select (_entity getVariable ["SSS_speedMode",2]));
	
		if ((_entity getVariable ["SSS_combatMode",1]) isEqualTo 0) then {
			_group setCombatMode "YELLOW";
			_group enableAttack true;
			{
				_x enableAI "TARGET";
				_x enableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		} else {
			_group setCombatMode "BLUE";
			_group enableAttack false;
			{
				_x disableAI "TARGET";
				_x disableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		};

		private _action = ["SSS_transport","Transport",ICON_TRANSPORT,{},{VEHICLE_ACTION_CONDITION},{
			_this call EFUNC(interaction,childActionsTransportLandVehicle)
		},_entity] call ace_interact_menu_fnc_createAction;

		[_vehicle,1,["ACE_SelfActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
		[_vehicle,0,["ACE_MainActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
	};

	case "transportMaritime" : {
		{
			_x disableAI "LIGHTS";
			_x disableAI "AUTOCOMBAT";
		} forEach PRIMARY_CREW(_vehicle);

		_vehicle setPilotLight (_entity getVariable ["SSS_lightsOn",true]);
		_vehicle setCollisionLight (_entity getVariable ["SSS_collisionLightsOn",true]);

		_group setBehaviour "CARELESS";
		_group setSpeedMode (["LIMITED","NORMAL","FULL"] select (_entity getVariable ["SSS_speedMode",2]));
	
		if ((_entity getVariable ["SSS_combatMode",1]) isEqualTo 0) then {
			_group setCombatMode "YELLOW";
			_group enableAttack true;
			{
				_x enableAI "TARGET";
				_x enableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		} else {
			_group setCombatMode "BLUE";
			_group enableAttack false;
			{
				_x disableAI "TARGET";
				_x disableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		};

		private _action = ["SSS_transport","Transport",ICON_TRANSPORT,{},{VEHICLE_ACTION_CONDITION},{
			_this call EFUNC(interaction,childActionsTransportMaritime)
		},_entity] call ace_interact_menu_fnc_createAction;

		[_vehicle,1,["ACE_SelfActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
		[_vehicle,0,["ACE_MainActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
	};

	case "transportPlane" : {
		{
			_x disableAI "LIGHTS";
			_x disableAI "AUTOCOMBAT";
		} forEach PRIMARY_CREW(_vehicle);

		_vehicle flyInHeight (_entity getVariable ["SSS_flyingHeight",500]);
		_vehicle setPilotLight (_entity getVariable ["SSS_lightsOn",true]);
		_vehicle setCollisionLight (_entity getVariable ["SSS_collisionLightsOn",true]);

		_group setBehaviour "CARELESS";
		_group setSpeedMode (["LIMITED","NORMAL","FULL"] select (_entity getVariable ["SSS_speedMode",1]));
	
		if ((_entity getVariable ["SSS_combatMode",1]) isEqualTo 0) then {
			_group setCombatMode "YELLOW";
			_group enableAttack true;
			{
				_x enableAI "TARGET";
				_x enableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		} else {
			_group setCombatMode "BLUE";
			_group enableAttack false;
			{
				_x disableAI "TARGET";
				_x disableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		};

		private _action = ["SSS_transport","Transport",ICON_TRANSPORT,{},{VEHICLE_ACTION_CONDITION},{
			_this call EFUNC(interaction,childActionsTransportPlane)
		},_entity] call ace_interact_menu_fnc_createAction;

		[_vehicle,1,["ACE_SelfActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
		[_vehicle,0,["ACE_MainActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
	};

	case "transportVTOL" : {
		{
			_x disableAI "LIGHTS";
			_x disableAI "AUTOCOMBAT";
		} forEach PRIMARY_CREW(_vehicle);

		_vehicle flyInHeight (_entity getVariable ["SSS_flyingHeight",250]);
		_vehicle setPilotLight (_entity getVariable ["SSS_lightsOn",true]);
		_vehicle setCollisionLight (_entity getVariable ["SSS_collisionLightsOn",true]);

		_group setBehaviour "CARELESS";
		_group setSpeedMode (["LIMITED","NORMAL","FULL"] select (_entity getVariable ["SSS_speedMode",1]));
	
		if ((_entity getVariable ["SSS_combatMode",1]) isEqualTo 0) then {
			_group setCombatMode "YELLOW";
			_group enableAttack true;
			{
				_x enableAI "TARGET";
				_x enableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		} else {
			_group setCombatMode "BLUE";
			_group enableAttack false;
			{
				_x disableAI "TARGET";
				_x disableAI "AUTOTARGET";
			} forEach PRIMARY_CREW(_vehicle);
		};

		private _action = ["SSS_transport","Transport",ICON_TRANSPORT,{},{VEHICLE_ACTION_CONDITION},{
			_this call EFUNC(interaction,childActionsTransportVTOL)
		},_entity] call ace_interact_menu_fnc_createAction;

		[_vehicle,1,["ACE_SelfActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
		[_vehicle,0,["ACE_MainActions"],_action] remoteExecCall ["ace_interact_menu_fnc_addActionToObject",0];
	};
};
