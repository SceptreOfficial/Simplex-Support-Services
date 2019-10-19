#include "script_component.hpp"
#define CHANGE_COMBAT_MODE \
		if ((_entity getVariable ["SSS_combatMode",1]) isEqualTo 0) then { \
			_group setCombatMode "YELLOW"; \
			_group enableAttack true; \
			{ \
				_x enableAI "TARGET"; \
				_x enableAI "AUTOTARGET"; \
			} forEach PRIMARY_CREW(_vehicle); \
		} else { \
			_group setCombatMode "BLUE"; \
			_group enableAttack false; \
			{ \
				_x disableAI "TARGET"; \
				_x disableAI "AUTOTARGET"; \
			} forEach PRIMARY_CREW(_vehicle); \
		}

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
	
		CHANGE_COMBAT_MODE;

		// FRIES makes AI pilots a nightmare
		private _fries = _vehicle getVariable ["ace_fastroping_FRIES",objnull];
		if (!isNull _fries) then {
			deleteVehicle _fries;
		};
	};

	case "transportLandVehicle" : {
		{_x disableAI "LIGHTS"} forEach PRIMARY_CREW(_vehicle);

		_vehicle setPilotLight (_entity getVariable ["SSS_lightsOn",true]);

		//_group setBehaviour "SAFE";
		_group setSpeedMode (["LIMITED","NORMAL","FULL"] select (_entity getVariable ["SSS_speedMode",2]));
	
		CHANGE_COMBAT_MODE;
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
	
		CHANGE_COMBAT_MODE;
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
	
		CHANGE_COMBAT_MODE;
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
	
		CHANGE_COMBAT_MODE;
	};
};

if ((_entity getVariable "SSS_service") == "Transport") then {
	private _ID = ["SSS_commissioned",_vehicle] call CBA_fnc_globalEventJIP;
	[_ID,_vehicle] call CBA_fnc_removeGlobalEventJIP;
	_vehicle setVariable ["SSS_commissionedEventID",_ID,true];
};
