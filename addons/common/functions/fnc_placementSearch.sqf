#include "script_component.hpp"
#define ANGLE_STEP_SIZE_COEF 20
#define RADIUS_ANGLE_COEF 60
#define TOLERATION_HEIGHT 0.25
#define TOLERATION_ANGLE 20
#define SURFACE_SIZE_COEF 0.6

if (canSuspend) exitWith {[FUNC(placementSearch),_this] call CBA_fnc_directCall};

params [
	["_object",objNull,[objNull,""]],
	["_posASL",[0,0,0],[[]],3],
	["_maxSearchRadius",25,[0]],
	["_maxSurfaceAngle",45,[0]],
	["_dropLimit",5,[0]],
	["_checkSurface",true,[false]],
	["_searchRadiusCoef",0.4,[0]]
];

if (_object isEqualType "") then {
	if (!isClass (configFile >> "CfgVehicles" >> _object)) exitWith {};

	if (isNil QGVAR(boundingCache)) then {
		GVAR(boundingCache) = true call CBA_fnc_createNamespace;
	};
	
	private _bounding = GVAR(boundingCache) getVariable _object;

	if (isNil "_bounding") then {
		private _dummy = _object createVehicleLocal [0,0,0];
		_bounding = 0 boundingBoxReal _dummy;
		GVAR(boundingCache) setVariable [_object,_bounding];
		deleteVehicle _dummy;
	};

	_bounding
} else {
	0 boundingBoxReal _object
} params ["_min","_max"];

if (isNil "_min") exitWith {[[],[]]};

private _objectRadius = ((_min distance2D [0,0,0]) + (_max distance2D [0,0,0])) / 2;
private _objectHeight = abs (_max # 2 - _min # 2);
private _angleStep = ANGLE_STEP_SIZE_COEF / _objectRadius;
private _searchRadius = 0.01;
private _searchAngle = 360;
private _safePos = [];
private _safeUp = [0,0,1];
private _surfaceSize = _objectRadius * SURFACE_SIZE_COEF;
private _surfaceChecks = [0,60,120,180,240,300];
private _drop = [0,0,-(0 max _dropLimit max 10)];
private _raise = [0,0,1];
private ["_safe","_searchPos","_ix","_surfPos","_angle","_center"];

while {
	scopeName "search";
	_safe = true;
	_searchPos = _posASL vectorAdd [_searchRadius * cos _searchAngle,_searchRadius * sin _searchAngle,0];
	
	if (_checkSurface) then {
		_ix = lineIntersectsSurfaces [_searchPos vectorAdd _raise,_searchPos vectorAdd _drop,objNull,objNull,true,1,"GEOM","FIRE"];

		if (_ix isNotEqualTo [] && {acos ([0,0,1] vectorCos (_ix # 0 # 1)) < _maxSurfaceAngle}) then {
			if (_ix # 0 # 0 # 2 - _searchPos # 2 > _dropLimit) exitWith {_safe = false};
			
			_safeUp = _ix # 0 # 1;
			_searchPos = _ix # 0 # 0;

			{
				_surfPos = _searchPos vectorAdd [_surfaceSize * cos _x,_surfaceSize * sin _x,0];
				_ix = lineIntersectsSurfaces [_surfPos vectorAdd _raise,_surfPos vectorAdd _drop,objNull,objNull,true,1,"GEOM","FIRE"];

				if (_ix isEqualTo [] || {
					abs ((_ix # 0 # 0 # 2 - _searchPos # 2) atan2 _surfaceSize) > _maxSurfaceAngle	
				}) exitWith {_safe = false};
			} forEach _surfaceChecks;
		} else {
			_safe = _searchPos # 2 <= 0;
		};
	};
	
	if (_safe && {(ASLtoAGL _searchPos) nearEntities _objectRadius isEqualTo []}) then {
		_angle = 0;
		
		for "_height" from 0.05 to _objectHeight step 0.005 do {
			_center = _searchPos vectorAdd (_safeUp vectorMultiply _height);
			_ix = lineIntersectsSurfaces [_center,_center vectorAdd ([_objectRadius * cos _angle,_objectRadius * sin _angle,0] vectorCrossProduct _safeUp),objNull,objNull,true,1,"GEOM","FIRE"];

			//[{drawLine3D _this},{},[
			//	ASLtoAGL (_center),
			//	ASLtoAGL (_center vectorAdd ([_objectRadius * cos _angle,_objectRadius * sin _angle,0] vectorCrossProduct _safeUp)),
			//	[1,0,0,0.5]
			//],10] call CBA_fnc_waitUntilAndExecute;

			if (_ix isNotEqualTo []) then {	
				_safe = _height < TOLERATION_HEIGHT && {acos (_safeUp vectorCos (_ix # 0 # 1)) < TOLERATION_ANGLE};
				if (!_safe) then {breakTo "search"};
			};

			_angle = (_angle + _angleStep + 180) % 360;
		};
	} else {
		_safe = false;
	};

	if (_safe) exitWith {
		_safePos = _searchPos vectorAdd (_safeUp vectorMultiply 0.1);
		false
	};

	_searchAngle = _searchAngle + (RADIUS_ANGLE_COEF / _searchRadius);

	if (_searchAngle >= 360) then {	
		_searchAngle = 0;
		_searchRadius = _searchRadius + (_objectRadius * _searchRadiusCoef);
	};

	_searchRadius < _maxSearchRadius
} do {};

if (_safePos isNotEqualTo []) then {
	DEBUG("Placement search successful");
	[_safePos,_safeUp]
} else {
	DEBUG("Placement search failed");
	[]
};
