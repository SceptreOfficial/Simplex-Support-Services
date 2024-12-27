#include "..\script_component.hpp"
/* ----------------------------------------------------------------------------
(Adapted from CBA_A3: https://github.com/CBATeam/CBA_A3/blob/master/addons/common/fnc_turretDir.sqf)

Description:
    Reports azimuth and inclination of a vehicles turret.

Parameters:
    _vehicle         - The Vehicle. <OBJECT>
    _turret          - A Turret. (e.g. [0] for "main turret") <ARRAY>
    _relativeToModel - false (default): report directions relative to world, true: relative to model <BOOLEAN>

Returns:
    Azimuth + Inclination <ARRAY>
        0: _azimuth (0-360 degree) <NUMBER>
        1: _inclination (90 to -90 degree, 0: forward) <NUMBER>

Examples:
    (begin example)
        [vehicle player, [0], true] call CBA_fnc_turretDir
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
params [["_vehicle", objNull, [objNull]], ["_turret", [-1], [[]]], ["_relativeToModel", false, [false]],["_useAnimPhase",true,[false]]];

private _turretConfig = [_vehicle, _turret] call CBA_fnc_getTurret;

if (_useAnimPhase) exitWith {
    private _gun = getText (_turretConfig >> "animationSourceGun");
    private _body = getText (_turretConfig >> "animationSourceBody");

    private _elev = _vehicle animationSourcePhase _gun;
    if (isNil "_elev") then {_elev = _vehicle animationPhase _gun};
    private _dir = _vehicle animationSourcePhase _body;
    if (isNil "_dir") then {_dir = _vehicle animationPhase _body};

    if (_relativeToModel) then {
        [[0,cos deg _elev,sin deg _elev],deg _dir] call FUNC(rotateVector2D)
    } else {
        _vehicle vectorModelToWorldVisual ([[0,cos deg _elev,sin deg _elev],deg _dir] call FUNC(rotateVector2D))
    };
};

private _weaponDirection = _vehicle weaponDirection (_vehicle currentWeaponTurret _turret);
if (_weaponDirection isNotEqualTo [0,0,0]) exitWith {_weaponDirection};

private _gunBeg = _vehicle selectionPosition getText (_turretConfig >> "gunBeg");
private _gunEnd = _vehicle selectionPosition getText (_turretConfig >> "gunEnd");

if (_gunEnd isEqualTo _gunBeg) then {
    if ((getNumber (_turretConfig >> "primaryObserver")) == 1) exitWith {
        _gunBeg = _gunEnd vectorAdd (_vehicle vectorWorldToModelVisual eyeDirection _vehicle);
    };
    private _vehicleConfig = configOf _vehicle;
    if (((getNumber (_vehicleConfig >> "isUAV")) == 1) && {_turret isEqualTo [0]}) then {
        _gunBeg = _vehicle selectionPosition getText (_vehicleConfig >> "uavCameraGunnerDir");
        _gunEnd = _vehicle selectionPosition getText (_vehicleConfig >> "uavCameraGunnerPos");
    } else {
        LOG_WARNING_2("Vehicle %1 has invalid gun configs on turret %2",configName _vehicleConfig,_turret);
    };
};

if !(_relativeToModel) then {
    _gunBeg = _vehicle modelToWorldVisualWorld _gunBeg;
    _gunEnd = _vehicle modelToWorldVisualWorld _gunEnd;
};

//private _turretDir = _gunEnd vectorFromTo _gunBeg;
//
//_turretDir params ["_dirX", "_dirY", "_dirZ"];
//
//private _azimuth = _dirX atan2 _dirY;
//
//if (_azimuth < 0) then {
//    ADD(_azimuth,360);
//};
//
//private _inclination = asin _dirZ;
//
//[_azimuth, _inclination]

_gunEnd vectorFromTo _gunBeg
