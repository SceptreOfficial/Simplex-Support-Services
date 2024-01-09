#include "script_component.hpp"

params [["_vehicle",objNull,[objNull]],["_entity",objNull,[objNull]],["_respawnable",true,[false]]];

if (isNull _entity || isNull _vehicle) exitWith {
	LOG_ERROR("Null commission");
};

if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(commission)],_vehicle] call CBA_fnc_targetEvent;
};

_vehicle setDamage 0;
_vehicle setFuel 1;
_vehicle lockDriver true;
_vehicle allowFleeing 0;

[{
	{
		_x setSkill 1;
		_x allowFleeing 0;
		_x disableAI "COVER";
		_x disableAI "SUPPRESSION";
		//_x disableAI "FSM";
		//_x disableAI "LIGHTS";
		//_x disableAI "AUTOCOMBAT";

		// AI mod compat
		_x setVariable ["lambs_danger_disableAI",true,true];
	} forEach PRIMARY_CREW(_this);
},_vehicle,3] call CBA_fnc_waitAndExecute;

private _group = _entity getVariable [QPVAR(group),grpNull];

if (isNull _group) then {
	_group = group _vehicle;
} else {
	if !(_vehicle in assignedVehicles _group) then {
		_group addVehicle _vehicle;
	};
	
	PRIMARY_CREW(_vehicle) joinSilent _group;
};

_vehicle setVariable [QPVAR(entity),_entity,true];

// ACEX headless compat
_group setVariable ["acex_headless_blacklist",true,true];

// ALIVE headless compat
{_x setVariable ["alive_ignore_hc",true,true]} forEach PRIMARY_CREW(_vehicle);

// ZHC headless compat
_group setVariable ["zhc_offload_blacklisted",true,true];

// AI mod compat
_group setVariable ["Vcm_Disable",true,true];
_group setVariable ["lambs_danger_disableGroupAI",true,true];

_vehicle call (_entity getVariable QPVAR(vehicleInit));

if (_respawnable) then {
	[QEGVAR(common,addEventHandler),[_vehicle,"GetOut",FUNC(reentry)]] call CBA_fnc_serverEvent;
	[QEGVAR(common,addEventHandler),[_vehicle,"SeatSwitched",FUNC(reentry)]] call CBA_fnc_serverEvent;

	private _primaryCrew = PRIMARY_CREW(_vehicle);
	
	_vehicle setVariable [QPVAR(crew),_primaryCrew,true];
	_vehicle setVariable [QPVAR(crewCache),createHashMapFromArray (_primaryCrew apply {[
		[assignedVehicleRole _x param [0,""],_vehicle unitTurret _x],
		_x
	]}),true];

	_entity setVariable [QPVAR(vehicleCustomization),_vehicle call BIS_fnc_getVehicleCustomization,true];
	_entity setVariable [QPVAR(crewConfig),_primaryCrew apply {[
		_vehicle unitTurret _x,
		_vehicle getCargoIndex _x,
		typeOf _x,
		getUnitLoadout _x
	]},true];
};

[QPVAR(vehicleCommissioned),[_entity,_vehicle]] call CBA_fnc_globalEvent;
