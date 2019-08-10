#include "script_component.hpp"

params [
	["_classname","",[""]],
	["_callSign","",[""]],
	["_weaponSet",[],[[]]],
	["_side",sideEmpty,[sideEmpty]],
	["_cooldownDefault",SSS_CASPlanesCooldownDefault,[0]]
];

if (!isServer) exitWith {
	["SSS_addCASPlane",_this] call CBA_fnc_serverEvent;
};

// Validation
if (_callsign isEqualTo "") then {_callsign = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");};
if (_classname isEqualTo "" || !(_classname isKindOf "Plane")) exitWith {SSS_ERROR_1("Invalid CAS Plane class: %1",_classname)};
if (_side isEqualTo sideEmpty) exitWith {SSS_ERROR_1("No side defined for %1 (%2)",_callsign,_classname)};

// Verify and compile weapons and countermeasures
private _entityWeapons = _classname call BIS_fnc_weaponsEntityType;
private _weapons = [];

if (_weaponSet isEqualTo []) then {
	_weaponSet = _entityWeapons select {
		(toLower ((_x call BIS_fnc_itemType) # 1)) in ["machinegun","rocketlauncher","missilelauncher","bomblauncher"]
	};
};

{
	if (_x isEqualType "") then {
		if (!isClass (configFile >> "CfgWeapons" >> _x)) exitWith {};
		private _magazineClass = (_x call CBA_fnc_compatibleMagazines) # 0;
		_weapons pushBack [_x,_magazineClass];
	};
	if (_x isEqualType []) then {
		_x params [["_weaponClass","",[""]],["_magazineClass","",[""]]];

		if (!isClass (configFile >> "CfgWeapons" >> _weaponClass) || !isClass (configFile >> "CfgMagazines" >> _magazineClass)) exitWith {};
		_weapons pushBack [_weaponClass,_magazineClass];
	};
	false
} count _weaponSet;

_weapons = [_weapons,true,{getText (configFile >> "CfgMagazines" >> _this # 1 >> "displayName")}] call SSS_fnc_sortBy;

// Basic setup
private _plane = (createGroup sideLogic) createUnit ["logic",[0,0,0],[],0,"CAN_COLLIDE"];
SET_VEHICLE_TRAITS(_plane,_classname,_side,"CASPlane",_callsign)
CREATE_TASK_MARKER(_plane,"mil_end","CAS",_callsign)

// Support specific setup
_plane setVariable ["SSS_weapons",_weapons,true];
_plane setVariable ["SSS_cooldown",0,true];
_plane setVariable ["SSS_cooldownDefault",_cooldownDefault,true];

// Assignment
ADD_SUPPORT_VEHICLE(_plane,_side,"CASPlanes")
