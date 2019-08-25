#include "script_component.hpp"

params [["_entity",objNull,[objNull]]];

if (isNull _entity || {!local _entity}) exitWith {};

private _serviceString = format ["SSS_%1_%2",_entity getVariable "SSS_service",_entity getVariable "SSS_side"];
private _serviceArray = missionNamespace getVariable [_serviceString,[]];
_serviceArray deleteAt (_serviceArray find _entity);
missionNamespace setVariable [_serviceString,_serviceArray,true];

private _base = _entity getVariable "SSS_base";

if (isNil "_base") exitWith {};

if (_base isEqualType objNull) then {deleteVehicle _base;};
[_entity getVariable "SSS_addedJIPID"] call CBA_fnc_removeGlobalEventJIP;
deleteMarker (_entity getVariable "SSS_marker");
