#include "script_component.hpp"

params [
	["_requesters",[],[[]]],
	["_classname","",["",objNull]],
	["_callSign","",[""]],
	["_weaponSet",[],[[]]],
	["_side",sideEmpty,[sideEmpty]],
	["_cooldownDefault",SSS_DEFAULT_COOLDOWN_PLANES,[0]],
	["_customInit","",["",{}]]
];

// Validation
if (_classname isEqualType objNull) then {
	_classname = typeOf _classname;
};

if (_classname isEqualTo "" || !(_classname isKindOf "Plane")) exitWith {
	SSS_ERROR_1("Invalid CAS Plane classname: %1",_classname);
};

if (_callsign isEqualTo "") then {
	_callsign = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
};

if (_customInit isEqualType "") then {
	_customInit = compile _customInit;
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addCASPlane),2];
	nil
};

// Verify and compile weapons
private _weapons = [];
private _weaponTypes = ["machinegun","rocketlauncher","missilelauncher","bomblauncher"];

if (_weaponSet isEqualTo []) then {
	_weaponSet = (_classname call BIS_fnc_weaponsEntityType) select {toLower ((_x call BIS_fnc_itemType) # 1) in _weaponTypes};
};

private _cfgWeapons = configFile >> "CfgWeapons";
private _cfgMagazines = configFile >> "CfgMagazines";

{
	if (_x isEqualType "") then {
		if (!isClass (_cfgWeapons >> _x)) exitWith {
			SSS_ERROR_1("Invalid weapon class: %1",_x);
		};

		_weapons pushBack [_x,(_x call CBA_fnc_compatibleMagazines) # 0];
	};

	if (_x isEqualType []) then {
		_x params [["_weaponClass","",[""]],["_magazineClass","",[""]]];

		if (!isClass (_cfgWeapons >> _weaponClass)) exitWith {
			SSS_ERROR_1("Invalid weapon class: %1",_weaponClass);
		};

		if (!isClass (_cfgMagazines >> _magazineClass)) exitWith {
			SSS_ERROR_1("Invalid magazine class: %1",_magazineClass);
		};

		_weapons pushBack [_weaponClass,_magazineClass];
	};
} forEach _weaponSet;

_weapons = [_weapons,true,{getText (_cfgMagazines >> _this # 1 >> "displayName")}] call FUNC(sortBy);

// Basic setup
private _entity = (createGroup sideLogic) createUnit ["Logic",[-69,-69,0],[],0,"CAN_COLLIDE"];

BASE_TRAITS(_entity,_classname,_callsign,_side,ICON_PLANE,ICON_PLANE_YELLOW,"",_customInit,"CAS","CASPlane");
CREATE_TASK_MARKER(_entity,_callsign,"mil_end","CAS");

// Specifics
_entity setVariable ["SSS_weapons",_weapons,true];
_entity setVariable ["SSS_cooldown",0,true];
_entity setVariable ["SSS_cooldownDefault",_cooldownDefault,true];

// Assignment
[_requesters,[_entity]] call FUNC(assignRequesters);
SSS_entities pushBack _entity;
publicVariable "SSS_entities";

[_entity,"Deleted",{_this call FUNC(deletedEntity)}] call CBA_fnc_addBISEventHandler;

_entity
