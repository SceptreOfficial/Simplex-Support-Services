#include "..\script_component.hpp"
#define MVAR(N,D) missionNamespace getVariable [N,D]

params [
	["_units",[],[[],objNull,grpNull,sideUnknown]],
	["_munitionDefaultsOnly",false,[false]],
	["_medicalDefaultsOnly",true,[false]],
	["_magazineCount",[]],
	["_underbarrelCount",[]],
	["_rocketCount",[]],
	["_throwableCount",[]],
	["_placeableCount",[]],
	["_medicalCount",[]]
];

_magazineCount params [
	["_magazineCount",MVAR(QGVAR(autoFillMagazineCount),20),[0]],
	["_magazinesMultiply",MVAR(QGVAR(autoFillMagazineMultiply),false),[false]]
];
_underbarrelCount params [
	["_underbarrelCount",MVAR(QGVAR(autoFillUnderbarrelCount),10),[0]],
	["_underbarrelMultiply",MVAR(QGVAR(autoFillUnderbarrelMultiply),false),[false]]
];
_rocketCount params [
	["_rocketCount",MVAR(QGVAR(autoFillRocketCount),10),[0]],
	["_rocketsMultiply",MVAR(QGVAR(autoFillRocketMultiply),false),[false]]
];
_throwableCount params [
	["_throwableCount",MVAR(QGVAR(autoFillThrowableCount),10),[0]],
	["_throwablesMultiply",MVAR(QGVAR(autoFillThrowableMultiply),false),[false]]
];
_placeableCount params [
	["_placeableCount",MVAR(QGVAR(autoFillPlaceableCount),10),[0]],
	["_placeablesMultiply",MVAR(QGVAR(autoFillPlaceableMultiply),false),[false]]
];
_medicalCount params [
	["_medicalCount",MVAR(QGVAR(autoFillMedicalCount),20),[0]],
	["_medicalMultiply",MVAR(QGVAR(autoFillMedicalMultiply),false),[false]]
];

if (isNil QGVAR(medicalDefaults)) then {
	GVAR(medicalDefaults) = [
		"ACE_fieldDressing",
		"ACE_packingBandage",
		"ACE_elasticBandage",
		"ACE_tourniquet",
		"ACE_splint",
		"ACE_morphine",
		"ACE_adenosine",
		"ACE_epinephrine",
		"ACE_bloodIV",
		"ACE_bloodIV_500",
		"ACE_bloodIV_250",
		"ACE_surgicalKit",
		"ACE_bodyBag"
	];
};

if (isNil QGVAR(medicalClasses)) then {
	GVAR(medicalClasses) = [
		"FirstAidKit",
		"Medikit",
		"ACE_fieldDressing",
		"ACE_packingBandage",
		"ACE_elasticBandage",
		"ACE_tourniquet",
		"ACE_splint",
		"ACE_morphine",
		"ACE_adenosine",
		//"ACE_atropine",
		"ACE_epinephrine",
		"ACE_plasmaIV",
		"ACE_plasmaIV_500",
		"ACE_plasmaIV_250",
		"ACE_bloodIV",
		"ACE_bloodIV_500",
		"ACE_bloodIV_250",
		"ACE_salineIV",
		"ACE_salineIV_500",
		"ACE_salineIV_250",
		"ACE_quikclot",
		"ACE_personalAidKit",
		"ACE_surgicalKit",
		"ACE_bodyBag"
	];
};

private _magazines = createHashMap;
private _underbarrel = createHashMap;
private _rockets = createHashMap;
private _throwables = createHashMap;
private _placeables = createHashMap;
private _medical = [[],+GVAR(medicalDefaults)] select (_medicalDefaultsOnly);
private _medicalClasses = +GVAR(medicalClasses);
private _throwableTypes = compatibleMagazines "Throw";
private _placeableTypes = compatibleMagazines "Put";
private _cfgMagazines = configFile >> "CfgMagazines";
private _cfgAmmo = configFile >> "CfgAmmo";

if !(_units isEqualType []) then {
	_units = switch true do {
		case (_units isEqualType objNull) : {[_units]};
		case (_units isEqualType grpNull) : {units _units};
		case (_units isEqualType sideUnknown) : {allPlayers select {side group _x == _units}};
		default {[]};
	};
};

if !(_units isEqualTypeAll objNull) then {
	_units = flatten (_units apply {
		switch true do {
			case (_x isEqualType objNull) : {continueWith _x};
			case (_x isEqualType grpNull) : {continueWith units _x};
			case (_x isEqualType sideUnknown) : {
				private _side = side group _x;
				continueWith (allPlayers select {side group _x == _side})	
			};
			default {objNull};
		};

		objNull
	});
};

_units = _units arrayIntersect _units;

private _fnc_sortMag = {
	switch true do {
		case (_this in _throwableTypes) : {
			_throwables set [_this,(_throwables getOrDefault [_this,0]) + 1];
		};
		case (_this in _placeableTypes) : {
			_placeables set [_this,(_placeables getOrDefault [_this,0]) + 1];
		};
		default {
			switch (toLower getText (_cfgAmmo >> getText (_cfgMagazines >> _this >> "ammo") >> "simulation")) do {
				case "shotbullet";
				case "shotspread" : {
					_magazines set [_this,(_magazines getOrDefault [_this,0]) + 1];
				};
				case "shotmissile";
				case "shotrocket" : {
					_rockets set [_this,(_rockets getOrDefault [_this,0]) + 1];	
				};
				default {
					_underbarrel set [_this,(_underbarrel getOrDefault [_this,0]) + 1];	
				};
			};
		};
	};
};

{
	if (isNull _x) then {continue};

	private _unitMagazines = primaryWeaponMagazine _x + secondaryWeaponMagazine _x + handgunMagazine _x + magazines _x;
	_unitMagazines = _unitMagazines arrayIntersect _unitMagazines;

	if (_munitionDefaultsOnly) then {
		{
			private _compatMags = compatibleMagazines (_x call BIS_fnc_baseWeapon);
			if (_compatMags isEqualTo []) then {continue};
			_compatMags # 0 call _fnc_sortMag;
		} forEach (weapons _x arrayIntersect weapons _x);
	} else {
		{
			private _compatMags = compatibleMagazines (_x call BIS_fnc_baseWeapon);
			if (_compatMags isEqualTo []) then {continue};

			private _defaultMag = _compatMags # 0;
			_defaultMag call _fnc_sortMag;
			_unitMagazines deleteAt (_unitMagazines find _defaultMag);
		} forEach (weapons _x arrayIntersect weapons _x);

		{_x call _fnc_sortMag} forEach _unitMagazines;
	};

	if (!_medicalDefaultsOnly) then {
		{
			if (_x in _medicalClasses) then {
				_medical pushBackUnique _x;
			};
		} forEach (items _x arrayIntersect items _x);
	};
} forEach _units;

private _cargo = [];

{_cargo pushBack [_x,[_magazineCount,_magazineCount * _y] select _magazinesMultiply]} forEach _magazines;
{_cargo pushBack [_x,[_underbarrelCount,_underbarrelCount * _y] select _underbarrelMultiply]} forEach _underbarrel;
{_cargo pushBack [_x,[_rocketCount,_rocketCount * _y] select _rocketsMultiply]} forEach _rockets;
{_cargo pushBack [_x,[_throwableCount,_throwableCount * _y] select _throwablesMultiply]} forEach _throwables;
{_cargo pushBack [_x,[_placeableCount,_placeableCount * _y] select _placeablesMultiply]} forEach _placeables;

private _unitCount = count _units;

{_cargo pushBack [_x,[_medicalCount,_medicalCount * _unitCount] select _medicalMultiply]} forEach _medical;

//[_magazines,_underbarrel,_rockets,_throwables,_placeables,_medical]
_cargo
