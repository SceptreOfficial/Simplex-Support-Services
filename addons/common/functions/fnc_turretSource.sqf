#include "script_component.hpp"

params ["_vehicle","_turret",["_returnWorld",true]];

private _cache = _vehicle getVariable [QGVAR(turretSources),createHashMap];
private _gunEnd = _cache getOrDefault [_turret,""];

if (_gunEnd isEqualto "") then {
	private _cfg = [_vehicle,_turret] call CBA_fnc_getTurret;
	private _gunBeg = _vehicle selectionPosition getText (_cfg >> "gunBeg");
	_gunEnd = _vehicle selectionPosition getText (_cfg >> "gunEnd");

	if (_gunEnd isEqualTo _gunBeg) then {
		//if (getNumber (_cfg >> "primaryObserver") == 1) exitWith {
		//	_gunBeg = _gunEnd vectorAdd (_vehicle vectorWorldToModelVisual eyeDirection _vehicle);
		//};
		
		private _vehicleConfig = configOf _vehicle;
		
		if (((getNumber (_vehicleConfig >> "isUAV")) == 1) && {_turret isEqualto [0]}) then {
			//_gunBeg = _vehicle selectionPosition getText (_vehicleConfig >> "uavCameraGunnerDir");
			_gunEnd = _vehicle selectionPosition getText (_vehicleConfig >> "uavCameraGunnerPos");

			_cache set [_turret,getText (_cfg >> "gunEnd")];
			_vehicle setVariable [QGVAR(turretSources),_cache];
		} else {
			WARNING_2("Vehicle %1 has invalid gun configs on turret %2",configName _vehicleConfig,_turret);
		};
	} else {
		_cache set [_turret,getText (_cfg >> "gunEnd")];
		_vehicle setVariable [QGVAR(turretSources),_cache];
	};
} else {
	_gunEnd = _vehicle selectionPosition _gunEnd;
};

if (_returnWorld) then {
	_vehicle modelToWorldVisualWorld _gunEnd
} else {
	_gunEnd
};
