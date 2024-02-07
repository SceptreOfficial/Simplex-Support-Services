#include "..\script_component.hpp"

params ["_sourceASL","_target","_ammoSpeed"];

if (_target isEqualType objNull) then {
	if (vectorMagnitude velocity _target <= 2) then {
		getPosASL _target vectorAdd [0,0,1]
		//AGLtoASL unitAimPositionVisual _target;
	} else {
		private _targetASL = getPosASL _target vectorAdd [0,0,1];
		//private _targetASL = AGLtoASL unitAimPositionVisual _target;
		private _targetZ = _targetASL # 2 - getTerrainHeightASL _targetASL;
		private _G = GRAVITY;
		private _distance = _sourceASL distance2D _targetASL;
		private _elevation = (_ammoSpeed^2 - sqrt (_ammoSpeed^4 - _G * (_G * _distance^2 + 2 * (_targetASL # 2 - _sourceASL # 2) * _ammoSpeed^2))) atan2 (_G * _distance);
		private _timeOfFlight = ((_ammoSpeed * sin _elevation) + sqrt ((_ammoSpeed * sin _elevation) ^ 2 - 2 * _G * (_targetASL # 2 - _sourceASL # 2))) / _G;
		if (!finite _timeOfFlight) then {_timeOfFlight = 0};
		
		_targetASL = velocity _target vectorMultiply _timeOfFlight * linearConversion [100,1200,_ammoSpeed,6,2,true] vectorAdd _targetASL;
		
		//[_targetASL # 0,_targetASL # 1,getTerrainHeightASL _targetASL]
		[_targetASL # 0,_targetASL # 1,getTerrainHeightASL _targetASL + _targetZ]
	};
} else {
	_target
};
