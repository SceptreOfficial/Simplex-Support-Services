#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_vehicle",objNull,[objNull]]];

if (isNull _entity || isNull _vehicle) exitWith {};

if (!local _vehicle) exitWith {
	_this remoteExecCall [QFUNC(resetOnRTB),_vehicle];
};

if (SSS_setting_resetVehicleOnRTB) then {
	_vehicle setDamage 0;
	_vehicle setFuel 1;
	_vehicle setVehicleAmmo 1;
};

if (SSS_setting_restoreCrewOnRTB) then {
	{_vehicle deleteVehicleCrew _x} forEach (crew _vehicle select {!alive _x});
	{_x setDamage 0} forEach PRIMARY_CREW(_vehicle);
	createVehicleCrew _vehicle;

	[{
		params ["_entity","_vehicle"];

		if (isNull _entity || !alive _vehicle) exitWith {};

		private _crew = PRIMARY_CREW(_vehicle);

		{
			_x setSkill 1;
			_x allowFleeing 0;
			_x disableAI "SUPPRESSION";
			_x disableAI "COVER";
			_x disableAI "AUTOCOMBAT";
			_x disableAI "LIGHTS";
		} forEach _crew;

		if ((_entity getVariable ["SSS_combatMode",1]) isEqualTo 0) then {
			{
				[_x enableAI "TARGET"];
				[_x enableAI "AUTOTARGET"];
			} forEach _crew;
		} else {
			{
				[_x disableAI "TARGET"];
				[_x disableAI "AUTOTARGET"];
			} forEach _crew;
		};
	},[_entity,_vehicle]] call CBA_fnc_execNextFrame;
};
