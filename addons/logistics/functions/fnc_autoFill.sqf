#include "..\script_component.hpp"

params [
	["_box",objNull,[objNull]],
	["_units",[],[[],objNull,grpNull,sideUnknown,""]],
	"_munitionDefaultsOnly",
	"_medicalDefaultsOnly",
	"_magazineCount",
	"_underbarrelCount",
	"_rocketCount",
	"_throwableCount",
	"_placeableCount",
	"_medicalCount"
];

if (isNull _box) exitWith {};

clearItemCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearBackpackCargoGlobal _box;

[{
	params ["_box","_defaultMax"];
	_box setMaxLoad (_defaultMax max loadAbs _box);
},[_box,maxLoad _box],1] call CBA_fnc_waitAndExecute;

_box setMaxLoad MAX_LOAD;

if (_units isEqualType "") then {
	_units = switch (toLower _units) do {
		case "#side" : {side group (_box getVariable [QPVAR(requester),objNull])};
		case "#group" : {group (_box getVariable [QPVAR(requester),objNull])};
		case "#players" : {allPlayers - entities "HeadlessClient_F"};
		default {[]};
	};
};

{_box addItemCargoGlobal _x} forEach ([
	_units,
	_munitionDefaultsOnly,
	_medicalDefaultsOnly,
	_magazineCount,
	_underbarrelCount,
	_rocketCount,
	_throwableCount,
	_placeableCount,
	_medicalCount
] call FUNC(resupplyAutoFill));
