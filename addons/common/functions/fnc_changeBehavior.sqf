#include "script_component.hpp"

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(changeBehavior),2];
};

params ["_values","_entity"];

if (isNull _entity) exitWith {};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

switch (_entity getVariable "SSS_supportType") do {
	case "CASHelicopter" : {
		_values params ["_flyingHeight","_lightsOn","_collisionLightsOn"];

		_entity setVariable ["SSS_flyingHeight",_flyingHeight,true];
		_entity setVariable ["SSS_lightsOn",_lightsOn,true];
		_entity setVariable ["SSS_collisionLightsOn",_collisionLightsOn,true];

		if (alive _vehicle) then {
			[_vehicle,_flyingHeight] remoteExecCall ["flyInHeight",_vehicle];
			[_vehicle,_lightsOn] remoteExecCall ["setPilotLight",_vehicle];
			[_vehicle,_collisionLightsOn] remoteExecCall ["setCollisionLight",_vehicle];

			NOTIFY(_entity,LLSTRING(RogerThat));
		};
	};

	case "transportHelicopter" : {
		_values params ["_flyingHeight","_speedMode","_combatMode","_lightsOn","_collisionLightsOn"];

		_entity setVariable ["SSS_flyingHeight",_flyingHeight,true];
		_entity setVariable ["SSS_speedMode",_speedMode,true];
		_entity setVariable ["SSS_combatMode",_combatMode,true];
		_entity setVariable ["SSS_lightsOn",_lightsOn,true];
		_entity setVariable ["SSS_collisionLightsOn",_collisionLightsOn,true];

		if (alive _vehicle) then {
			[_vehicle,_flyingHeight] remoteExecCall ["flyInHeight",_vehicle];
			[_vehicle,_lightsOn] remoteExecCall ["setPilotLight",_vehicle];
			[_vehicle,_collisionLightsOn] remoteExecCall ["setCollisionLight",_vehicle];

			private _group = group _vehicle;
			private _groupOwner = groupOwner _group;

			[_group,["LIMITED","NORMAL","FULL"] select _speedMode] remoteExecCall ["setSpeedMode",_groupOwner];

			if (_combatMode isEqualTo 0) then {
				[_group,"YELLOW"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,true] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["enableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["enableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			} else {
				[_group,"BLUE"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,false] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["disableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["disableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			};

			NOTIFY(_entity,LLSTRING(RogerThat));
		};
	};

	case "transportLandVehicle" : {
		_values params ["_speedMode","_combatMode","_lightsOn"];

		_entity setVariable ["SSS_speedMode",_speedMode,true];
		_entity setVariable ["SSS_combatMode",_combatMode,true];
		_entity setVariable ["SSS_lightsOn",_lightsOn,true];

		if (alive _vehicle) then {
			[_vehicle,_lightsOn] remoteExecCall ["setPilotLight",_vehicle];

			private _group = group _vehicle;
			private _groupOwner = groupOwner _group;

			[_group,"SAFE"] remoteExecCall ["setBehaviour",_groupOwner];
			[_group,["LIMITED","NORMAL","FULL"] select _speedMode] remoteExecCall ["setSpeedMode",_groupOwner];

			if (_combatMode isEqualTo 0) then {
				[_group,"YELLOW"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,true] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["enableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["enableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			} else {
				[_group,"BLUE"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,false] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["disableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["disableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			};

			NOTIFY(_entity,LLSTRING(RogerThat));
		};
	};

	case "transportMaritime" : {
		_values params ["_speedMode","_combatMode","_lightsOn","_collisionLightsOn"];

		_entity setVariable ["SSS_speedMode",_speedMode,true];
		_entity setVariable ["SSS_combatMode",_combatMode,true];
		_entity setVariable ["SSS_lightsOn",_lightsOn,true];
		_entity setVariable ["SSS_collisionLightsOn",_collisionLightsOn,true];

		if (alive _vehicle) then {
			[_vehicle,_lightsOn] remoteExecCall ["setPilotLight",_vehicle];
			[_vehicle,_collisionLightsOn] remoteExecCall ["setCollisionLight",_vehicle];

			private _group = group _vehicle;
			private _groupOwner = groupOwner _group;

			[_group,["LIMITED","NORMAL","FULL"] select _speedMode] remoteExecCall ["setSpeedMode",_groupOwner];

			if (_combatMode isEqualTo 0) then {
				[_group,"YELLOW"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,true] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["enableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["enableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			} else {
				[_group,"BLUE"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,false] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["disableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["disableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			};

			NOTIFY(_entity,LLSTRING(RogerThat));
		};
	};

	case "transportPlane";
	case "transportVTOL" : {
		_values params ["_flyingHeight","_speedMode","_combatMode","_lightsOn","_collisionLightsOn"];

		_entity setVariable ["SSS_flyingHeight",_flyingHeight,true];
		_entity setVariable ["SSS_speedMode",_speedMode,true];
		_entity setVariable ["SSS_combatMode",_combatMode,true];
		_entity setVariable ["SSS_lightsOn",_lightsOn,true];
		_entity setVariable ["SSS_collisionLightsOn",_collisionLightsOn,true];

		if (alive _vehicle) then {
			[_vehicle,_flyingHeight] remoteExecCall ["flyInHeight",_vehicle];
			[_vehicle,_lightsOn] remoteExecCall ["setPilotLight",_vehicle];
			[_vehicle,_collisionLightsOn] remoteExecCall ["setCollisionLight",_vehicle];

			private _group = group _vehicle;
			private _groupOwner = groupOwner _group;

			[_group,["LIMITED","NORMAL","FULL"] select _speedMode] remoteExecCall ["setSpeedMode",_groupOwner];

			if (_combatMode isEqualTo 0) then {
				[_group,"YELLOW"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,true] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["enableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["enableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			} else {
				[_group,"BLUE"] remoteExecCall ["setCombatMode",_groupOwner];
				[_group,false] remoteExecCall ["enableAttack",_groupOwner];
				{
					[_x,"TARGET"] remoteExecCall ["disableAI",_x];
					[_x,"AUTOTARGET"] remoteExecCall ["disableAI",_x];
				} forEach PRIMARY_CREW(_vehicle);
			};

			NOTIFY(_entity,LLSTRING(RogerThat));
		};
	};
};
