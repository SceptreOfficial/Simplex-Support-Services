#include "script_component.hpp"

params ["_vehicle","_targetASL",["_turrets",[]]];

if (_targetASL isEqualType objNull) then {
	_targetASL = getPosASL _targetASL;
};

if (_turrets isEqualTo []) then {
	_turrets = [[-1]] + allTurrets _vehicle;
};

if (isNil QGVAR(turretLimitsCompatibility)) then {
	GVAR(turretLimitsCompatibility) = createHashMapFromArray [
		["USAF_AC130U",createHashMapFromArray [
			[[2],[80,100,-18,8]],
			[[3],[80,100,-18,8]]
		]]
	];
};

private _compat = createHashMap;
{if (_vehicle isKindOf _x) exitWith {_compat = _y}} forEach GVAR(turretLimitsCompatibility);

_turrets select {
	_compat getOrDefault [_x,_vehicle getTurretLimits _x] params ["_minTurn","_maxTurn","_minElev","_maxElev"];

	_minTurn = -_minTurn;
	_maxTurn = -_maxTurn;
	private _source = [_vehicle,_x,false] call FUNC(turretSource);
	private _elevation = asin ((_vehicle vectorWorldToModelVisual ((_vehicle modelToWorldVisualWorld _source) vectorFromTo _targetASL)) # 2);

	private _inView = _minElev <= _elevation && _maxElev >= _elevation && {abs _minTurn >= 360 || abs _maxTurn >= 360 || {
		private _relDir = ((_source getDir (_vehicle worldToModelVisual ASLtoAGL _targetASL)) - ((_minTurn + _maxTurn) / 2 call CBA_fnc_simplifyAngle)) call CBA_fnc_simplifyAngle;
		_relDir = [_relDir,_relDir - 360] select (_relDir > 180);

		abs _relDir <= abs (_minTurn - _maxTurn) / 2
	}};

	if (OPTION(debugDraw)) then {
		private _p1 = _vehicle modelToWorldVisualWorld (_source vectorAdd ([sin _minTurn,cos _minTurn,tan _minElev] vectorMultiply 1000));
		private _p2 = _vehicle modelToWorldVisualWorld (_source vectorAdd ([sin _minTurn,cos _minTurn,tan _maxElev] vectorMultiply 1000));
		private _p3 = _vehicle modelToWorldVisualWorld (_source vectorAdd ([sin _maxTurn,cos _maxTurn,tan _minElev] vectorMultiply 1000));
		private _p4 = _vehicle modelToWorldVisualWorld (_source vectorAdd ([sin _maxTurn,cos _maxTurn,tan _maxElev] vectorMultiply 1000));
		private _sourceAGL = ASLtoAGL (_vehicle modelToWorldVisualWorld _source);
		[{drawLine3D _this},{},[_sourceAGL,ASLToAGL _p1,[0,0,1,1]],3] call CBA_fnc_waitUntilAndExecute;
		[{drawLine3D _this},{},[_sourceAGL,ASLToAGL _p2,[0,0,1,1]],3] call CBA_fnc_waitUntilAndExecute;
		[{drawLine3D _this},{},[_sourceAGL,ASLToAGL _p3,[0,0,1,1]],3] call CBA_fnc_waitUntilAndExecute;
		[{drawLine3D _this},{},[_sourceAGL,ASLToAGL _p4,[0,0,1,1]],3] call CBA_fnc_waitUntilAndExecute;
		[{drawLine3D _this},{},[_sourceAGL,ASLToAGL _targetASL,[[1,0,0,1],[0,1,0,1]] select _inView],3] call CBA_fnc_waitUntilAndExecute;
	};

	_inView
}
