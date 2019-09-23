#include "script_component.hpp"

/*
	Authors: Sceptre
	Returns a proper time description from supplied time in seconds

	Parameters:
	0: Seconds <SCALAR>

	Returns:
	Time description <STRING>
*/

params [["_time",0,[0]]];
[[],_time,0,0,0] params ["_description","_seconds","_minutes","_hours","_days"];

if (_seconds >= 60) then {
	_minutes = floor (_seconds / 60);
	_seconds = _seconds - (_minutes * 60);
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
	if (_amount != 0) then {_description pushBack format ["%1 %2",_amount,_name];};
} forEach [[_days,"days"],[_hours,"hours"],[_minutes,"minutes"],[_seconds,"seconds"]];

_description joinString ", "
