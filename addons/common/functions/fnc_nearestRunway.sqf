#include "..\script_component.hpp"

if (canSuspend) exitWith {[FUNC(nearestRunway),_this] call CBA_fnc_directCall};

params [["_source",objNull,[objNull,[]]]];

if (_source isEqualType objNull) then {
	_source = getPosASL _source;
};

private _worldCfg = configfile >> "CfgWorlds" >> worldName;
private _airportData = [[getArray (_worldCfg >> "ilsPosition"),getArray (_worldCfg >> "ilsTaxiIn"),getArray (_worldCfg >> "ilsDirection")]];
private _secondaryData = "true" configClasses (_worldCfg >> "SecondaryAirports");

if !(_secondaryData isEqualTo []) then {
	{
		private _cfg = _worldCfg >> "SecondaryAirports" >> configName _x;
		_airportData pushBack [getArray (_cfg >> "ilsPosition"),getArray (_cfg >> "ilsTaxiIn"),getArray (_cfg >> "ilsDirection")];
	} forEach _secondaryData;
};

_airportData = _airportData apply {[(_x # 0) distance2D _source,_x]};
_airportData sort true;
(_airportData # 0 # 1) params ["_position","_ilsTaxiIn","_ilsDirection"];

if !(_ilsTaxiIn isEqualTo []) then {
	_position = [_ilsTaxiIn # -2,_ilsTaxiIn # -1];
};

_position set [2,0];

[AGLtoASL _position,((_ilsDirection # 0) atan2 (_ilsDirection # 2)) - 180,asin (_ilsDirection # 1)]
