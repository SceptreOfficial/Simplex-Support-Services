#include "script_component.hpp"

params ["_entity","_vehicle"];

if (isNull _entity || isNull _vehicle) exitWith {};

private _group = _entity getVariable [QPVAR(group),grpNull];

if (isNull _group) then {
	_group = createGroup [_entity getVariable QPVAR(side),false];
	_entity setVariable [QPVAR(group),_group,true];
};

_group addVehicle _vehicle;

private _turrets = [];
private _cargoIndexes = [];

{if (!alive _x) then {_vehicle deleteVehicleCrew _x}} forEach crew _vehicle;

{
	_turrets pushBack (_vehicle unitTurret _x);
	_cargoIndexes pushBack (_vehicle getCargoIndex _x);
	_x setDamage 0;
} forEach PRIMARY_CREW(_vehicle);

private _crewConfig = _entity getVariable QPVAR(crewConfig);
private _newUnits = [];

if (isNil "_crewConfig") then {
	private _oldUnits = units _group;
	_group createVehicleCrew _vehicle;
	_newUnits = units _group - _oldUnits;
} else {
	{
		_x params ["_turret","_cargoIndex","_class","_loadout"];

		private _unit = if (_turret isNotEqualTo []) then {
			if (_turret in _turrets) then {continue};

			private _unit = _group createUnit [_class,[0,0,0],[],0,"CAN_COLLIDE"];
			_unit setUnitLoadout _loadout;

			if (_turret isEqualTo [-1]) then {
				_unit moveInDriver _vehicle;
			} else {
				_unit moveInTurret [_vehicle,_turret];
			};

			_unit
		} else {
			if (_cargoIndex in _cargoIndexes) then {continue};

			private _unit = _group createUnit [_class,[0,0,0],[],0,"CAN_COLLIDE"];
			_unit setUnitLoadout _loadout;
			_unit moveInCargo [_vehicle,_cargoIndex,false];
			_unit
		};

		if (_unit in _vehicle) then {
			_newUnits pushBack _unit;
		} else {
			deleteVehicle _unit;
		};
	} forEach _crewConfig;
};

private _canTarget = _entity getVariable [QPVAR(combatMode),"YELLOW"] != "BLUE";
private _isArtillery = _entity getVariable [QPVAR(supportType),""] == "ARTILLERY";

{
	_x setSkill 1;
	_x allowFleeing 0;
	_x disableAI "SUPPRESSION";
	//_x disableAI "FSM";
	_x disableAI "COVER";
	_x disableAI "LIGHTS";
	_x enableAIFeature ["TARGET",_canTarget];
	_x enableAIFeature ["AUTOTARGET",_canTarget];

	if (_isArtillery) then {_x disableAI "AUTOCOMBAT"};

	// AI mod compat
	_x setVariable ["lambs_danger_disableAI",true,true];
} forEach _newUnits;

_newUnits joinSilent _group;

private _primaryCrew = PRIMARY_CREW(_vehicle);

_vehicle setVariable [QPVAR(crew),_primaryCrew,true];
_vehicle setVariable [QPVAR(crewCache),createHashMapFromArray (_primaryCrew apply {[
	[assignedVehicleRole _x param [0,""],_vehicle unitTurret _x],
	_x
]}),true];
