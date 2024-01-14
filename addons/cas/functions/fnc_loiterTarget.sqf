#include "script_component.hpp"

params ["_args","_PFHID"];
_args params ["_vehicle","_entity"];

if (!alive _vehicle || isNull _entity) exitWith {
	_PFHID call CBA_fnc_removePerFrameHandler;
};

private _request = _entity getVariable [QPVAR(request),createHashMap];
private _search = _request getOrDefault ["target",""];
(_search splitString ":") params [["_type",""],["_typeDetail",""]];
_request getOrDefault ["weapon",[]] params ["_weapon","_magazine","_turret"];

if (_type in ["","NONE"]) exitWith {
	_vehicle setVariable [QGVAR(loiterTargetTick),-1];

	if (_weapon == "SEARCHLIGHT") then {
		[_vehicle,_turret,objNull,false] call EFUNC(common,searchlight);
	};
};

private _targetTick = _vehicle getVariable [QGVAR(loiterTargetTick),-1];

if (_targetTick < 0 || CBA_missionTime < _targetTick) exitWith {};

_entity getVariable QPVAR(guiLimits) params ["_altitudeMin","_altitudeMax","_radiusMin","_radiusMax"];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];
private _radius = _request getOrDefault ["radius",_radiusMin max LOITER_RADIUS_DEFAULT min _radiusMax];
private _search = _request getOrDefault ["target",""];
private _spread = _request getOrDefault ["spread",0];
private _duration = _request getOrDefault ["duration",3];
private _interval = _request getOrDefault ["interval",-1];

private _target = [
	_posASL,
	side group _vehicle,
	_search,
	_radius * 0.75,
	[_entity getVariable QPVAR(friendlyRange),0] select (_request getOrDefault ["dangerClose",false])
] call EFUNC(common,targetSearch);

if (_target in [objNull,[0,0,0]]) exitWith {};

if (_weapon == "SEARCHLIGHT") exitWith {
	[_vehicle,_turret,_target] call EFUNC(common,searchlight);
};

private _validTurrets = [_vehicle,_target,[_vehicle,[],true,true,[_weapon,_magazine],true] call EFUNC(common,turretWeapons)] call EFUNC(common,turretsInView);

if (_validTurrets isEqualTo []) exitWith {};

// Add an offset to account for angular momentum (without this rounds can go ~5m past target)
private _offsetCoef = linearConversion [0,150,vectorMagnitude velocity _vehicle,0,2,true];
private _offset = _offsetCoef * linearConversion [3000,1000,_radius,0,-3,true];

[_vehicle,_target,[_weapon,_magazine],[_duration,true],0,[_duration,_duration],_spread,_offset,false] call EFUNC(common,fireAtTarget);

// Cycle every X seconds until cancelled by user
if (_interval < 0) then {
	_vehicle setVariable [QGVAR(loiterTargetTick),-1,true];
} else {
	_vehicle setVariable [QGVAR(loiterTargetTick),CBA_missionTime + _duration + (_interval max 3),true];
};
