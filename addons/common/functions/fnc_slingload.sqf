#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(slingload),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_cargo",objNull,[objNull]],
	["_moveCargo",false,[false]],
	["_massOverride",false,[false]]
];

{ropeDestroy _x} forEach (_vehicle getVariable [QGVAR(slingloadRopes),[]]);

if !([_vehicle,_cargo,_massOverride] call FUNC(canSlingLoad)) exitWith {
	_vehicle setVariable [QGVAR(slingloadCargo),nil,true];
	false
};

// Run locally
if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(slingload)],_vehicle] call CBA_fnc_targetEvent;
	false
};

private _maxMass = getNumber (configOf _vehicle >> "slingLoadMaxCargoMass") max 1;
private _cargoMass = getMass _cargo;

if (isNil {_cargo getVariable QGVAR(defaultMass)}) then {
	_cargo setVariable [QGVAR(defaultMass),getMass _cargo,true];
};

if (_massOverride && _cargoMass > _maxMass * 0.75) then {
	// Attempt to override mass
	[QGVAR(execute),[[_cargo,_maxMass * 0.75],{
		params ["_cargo","_mass"];
		_cargo setMass _mass;
	}],_cargo] call CBA_fnc_targetEvent;

	[{
		params ["_tick","_cargo"];
		CBA_missionTime > _tick && local _cargo
	},{
		params ["","_cargo","_mass","_vehicle"];
		if (_vehicle getVariable QGVAR(slingloadCargo) isNotEqualTo _cargo) exitWith {};
		_cargo setMass _mass;
	},[CBA_missionTime + 10,_cargo,_maxMass * 0.75,_vehicle],60] call CBA_fnc_waitUntilAndExecute;

	// Reset mass to original value after detachment
	[QGVAR(execute),[[_vehicle,_cargo],{
		params ["_vehicle","_cargo"];

		[_vehicle,"RopeBreak",{
			params ["_vehicle","","_object"];

			if (_object == _thisArgs) then {
				_vehicle removeEventHandler [_thisType,_thisID];	
				[QGVAR(execute),[_thisArgs,{
					_this setMass (_this getVariable [QGVAR(defaultMass),getMass _this]);
				}],_thisArgs] call CBA_fnc_targetEvent;
			};
		},_cargo] call CBA_fnc_addBISEventHandler;
	}]] call CBA_fnc_serverEvent;
};

_vehicle enableRopeAttach true;
_cargo enableRopeAttach true;

private _source = _vehicle getVariable QGVAR(slingloadSource);

if (isNil "_source") then {
	_source = getCenterOfMass _vehicle;
	(boundingBoxReal _vehicle) params ["_vehicleBoundingMin","_vehicleBoundingMax"];
	private _ixStart = _vehicle modelToWorldVisualWorld [_source # 0,_source # 1,_vehicleBoundingMin # 2];
	private _ixEnd = _vehicle modelToWorldVisualWorld _source;
	private _ix = lineIntersectsSurfaces [_ixStart,_ixEnd,objNull,objNull,true,-1,"GEOM","FIRE",false];
	private _index = _ix findIf {_x # 2 == _vehicle};

	if (_index > -1) then {
		_source set [2,_source # 2 - (_ix # _index # 0 # 2 - _ixStart # 2)];
	} else {
		_source set [2,_vehicleBoundingMin # 2];
	};

	_vehicle setVariable [QGVAR(slingloadSource),_source,true];
};

(boundingBoxReal _cargo) params ["_cargoBoundingMin","_cargoBoundingMax"];
private _centerOfMass = getCenterOfMass _cargo;
private _cargoWidth = (abs (_cargoBoundingMin # 0 - _cargoBoundingMax # 0)) / 2;
private _cargoLength = (abs (_cargoBoundingMin # 1 - _cargoBoundingMax # 1)) / 2;
private _cargoHeight = abs (_cargoBoundingMin # 2 - _cargoBoundingMax # 2);
private _targetHeight = (_centerOfMass # 2 + _cargoHeight * 0.2) min (_cargoBoundingMax # 2);

if (_moveCargo) then {
	_cargo setDir getDirVisual _vehicle;
	_cargo setPosWorld (_vehicle modelToWorldVisualWorld (_source vectorAdd [0,0,-12 - _targetHeight]));
};

private _length = (_vehicle modelToWorldVisualWorld _source) distance (_cargo modelToWorldVisualWorld [0,0,_centerOfMass # 2]);

private _ropes = [
	[_cargoWidth,_cargoLength,0],
	[_cargoWidth,-_cargoLength,0],
	[-_cargoWidth,-_cargoLength,0],
	[-_cargoWidth,_cargoLength,0]
] apply {
	private _target = _centerOfMass vectorAdd _x;
	_target set [2,_targetHeight];

	private _ixStart = _cargo modelToWorldVisualWorld _target;
	private _ixEnd = _cargo modelToWorldVisualWorld _centerOfMass;
	private _ix = lineIntersectsSurfaces [_ixStart,_ixEnd,objNull,objNull,true,-1,"GEOM","FIRE",false];
	private _index = _ix findIf {_x # 2 == _cargo};

	if (_index > -1) then {
		_target = _cargo worldToModelVisual ASLToAGL (_ix # _index # 0);
	};

	ropeCreate [_vehicle,_source,_cargo,_target,_length];
};

_vehicle setVariable [QGVAR(slingloadRopeLength),_length,true];
_vehicle setVariable [QGVAR(slingloadRopes),_ropes,true];
_vehicle setVariable [QGVAR(slingloadCargo),_cargo,true];

if (_moveCargo) then {
	_cargo setVelocity velocity _vehicle;
	{{_x setVelocity velocity _vehicle} forEach (ropeSegments _x)} forEach _ropes;
};

[QGVAR(execute),[[_vehicle,_cargo],{
	params ["_vehicle","_cargo"];

	[_vehicle,"RopeBreak",{
		params ["_vehicle","","_object"];

		if (_object == _thisArgs) then {
			_vehicle removeEventHandler [_thisType,_thisID];

			if (_vehicle getVariable [QGVAR(frameDrop),false]) exitWith {
				[{_this setVariable [QGVAR(frameDrop),nil,true]},_vehicle] call CBA_fnc_execNextFrame;
			};

			_vehicle setVariable [QGVAR(slingloadCargo),nil,true];
		};
	},_cargo] call CBA_fnc_addBISEventHandler;
}]] call CBA_fnc_serverEvent;

[QGVAR(slingload),[_vehicle,_cargo,_ropes]] call CBA_fnc_globalEvent;

true
