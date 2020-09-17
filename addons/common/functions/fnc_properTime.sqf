#include "script_component.hpp"
/*
	Authors: Sceptre
	Returns a proper time description from supplied time in seconds

	Parameters:
	0: Seconds <SCALAR>
	1: Generalized rounding <BOOL>

	Returns:
	Time description <STRING>
*/
params [["_time",0,[0]],["_round",false,[false]]];

private _description = [];
private _seconds = round _time;
private _minutes = 0;
private _hours = 0;
private _days = 0;

if (_seconds >= 60) then {
	_minutes = floor (_seconds / 60);
	_seconds = _seconds - (_minutes * 60);
};

if (_round) then {
	private _distances = [abs (0 - _seconds),abs (15 - _seconds),abs (30 - _seconds),abs (45 - _seconds),abs (60 - _seconds)];
	_seconds = [0,15,30,45,60] select (_distances find selectMin _distances);

	if (_seconds isEqualTo 60) then {
		_seconds = 0;
		_minutes = _minutes + 1;
	};

	if (_minutes isEqualTo 0 && _seconds isEqualTo 0) then {
		_seconds = round _time;
	};
};

if (_minutes >= 60) then {
	_hours = floor (_minutes / 60);
	_minutes = _minutes - (_hours * 60);
};

if (_hours >= 24) then {
	_days = floor (_hours / 24);
	_hours = _hours - (_days * 24);
};

{
	_x params ["_amount","_name"];
	if (_amount != 0) then {
		if (_amount isEqualTo 1) then {
			// Trim "s"
			_name = toArray _name;
			_name deleteAt (count _name - 1);
			_name = toString _name;
		};

		_description pushBack format ["%1 %2",_amount,_name];
	};
} forEach [[_days,LLSTRING(TimeDays)],[_hours,LLSTRING(TimeHours)],[_minutes,LLSTRING(TimeMinutes)],[_seconds,LLSTRING(TimeSeconds)]];

_description joinString ", "
