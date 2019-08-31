#include "script_component.hpp"

params [["_add",false,[false]],["_serviceString","",[""]],["_entity",objNull,[objNull]]];

private _serviceArray = missionNamespace getVariable [_serviceString,[]];

if (_add) then {
	_serviceArray pushBackUnique _entity;
	_serviceArray = [_serviceArray,true,{_this getVariable "SSS_displayName"}] call FUNC(sortBy);
	SSS_LOG_1("Support vehicle added: %1",_entity)
} else {
	_serviceArray deleteAt (_serviceArray find _entity);
	SSS_LOG_1("Support vehicle removed: %1",_entity)
};

missionNamespace setVariable [_serviceString,_serviceArray,true];