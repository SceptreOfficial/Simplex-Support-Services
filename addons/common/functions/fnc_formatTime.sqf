#include "script_component.hpp"
/*
	Authors: Sceptre
	Formats time in seconds to a clock string

	Parameters:
	0: Seconds <SCALAR>
	1: Generalized rounding, true for 15s <BOOL | SCALAR>

	Returns:
	Time description <STRING>
*/
params [["_time",0,[0]],["_round",false,[false,0]]];

_round = if (_round isEqualType 0) then {
	0 max _round
} else {
	[1,15] select _round	
};

_time = round (0 max round _time / _round) * _round;

private _hours = 0 max floor (_time / 3600);
if (_hours < 10) then {_hours = "0" + str _hours};

private _minutes = 0 max floor (_time % 3600 / 60);
if (_minutes < 10) then {_minutes = "0" + str _minutes};

private _seconds = 0 max floor (_time % 60);
if (_seconds < 10) then {_seconds = "0" + str _seconds};

if (_hours isEqualTo "00") then {
	format ["%1:%2",_minutes,_seconds];
} else {
	format ["%1:%2:%3",_hours,_minutes,_seconds];
};

