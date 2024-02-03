#include "..\script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#define LVAR(N) _logic getVariable QUOTE(N)

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _vehicle = synchronizedObjects _logic select {_x isKindOf "Air"} param [0,objNull];
		private _class = LVAR(AircraftClass);
		private _pylons = [LVAR(Pylons)] call EFUNC(common,parseArray);

		if (!isNull _vehicle) then {
			if (_class isEqualTo "") then {_class = typeOf _vehicle};
			if (_pylons isEqualTo []) then {_pylons = [_vehicle,{_turret isNotEqualTo [-1]}] call EFUNC(common,getPylons)};
		};

		private _entity = [
			_class,
			LVAR(Callsign),
			[LVAR(Cooldown),0],
			LVAR(VirtualRunway),
			LVAR(SpawnDistance),
			LVAR(SpawnDelay),
			LVAR(AltitudeLimits),
			LVAR(RadiusLimits),
			LVAR(Duration),
			LVAR(Repositioning) == 0,
			_pylons,
			LVAR(InfiniteAmmo) == 0,
			[LOITER_TARGETS,LVAR(TargetTypes)] call EFUNC(common,parseCheckboxes),
			LVAR(FriendlyRange),
			LVAR(VehicleInit),
			LVAR(RemoteControl) == 0,
			[west,east,independent,civilian] param [LVAR(Side),west],
			LVAR(RemoteAccess),
			[LVAR(AccessItems)] call EFUNC(common,parseList),
			LVAR(AccessItemsLogic) == 1,
			LVAR(AccessCondition),
			LVAR(RequestCondition),
			[_logic getVariable QPVAR(auth)] call EFUNC(common,parseArray)
		] call FUNC(addLoiter);

		[_logic,_entity] call EFUNC(common,addTerminals);
	} else {
		(attachedTo _logic) call FUNC(moduleAddLoiter_zeus);
	};

	deleteVehicle _logic;
},_this,2] call CBA_fnc_execAfterNFrames;
