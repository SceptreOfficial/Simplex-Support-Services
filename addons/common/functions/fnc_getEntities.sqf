#include "..\script_component.hpp"

params ["_unit","_service",["_terminalAccess",false,[false,objNull]]];

private _entities = [];

if (_terminalAccess isEqualType objNull) then {
	{
		if (_x == _terminalAccess && {[_unit,_x,true] call FUNC(isAuthorized)}) then {
			_entities pushBack [_x getVariable QPVAR(callsign),_x];
			continue
		};

		if ([_unit,_x] call FUNC(isAuthorized)) then {
			_entities pushBack [_x getVariable QPVAR(callsign),_x];
		};
	} forEach (GVAR(services) getOrDefault [toUpper _service,[]]);	
} else {
	{
		if ([_unit,_x,_terminalAccess] call FUNC(isAuthorized)) then {
			_entities pushBack [_x getVariable QPVAR(callsign),_x];
		};
	} forEach (GVAR(services) getOrDefault [toUpper _service,[]]);	
};

_entities sort true;
_entities apply {_x # 1}
