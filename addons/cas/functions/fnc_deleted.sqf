#include "script_component.hpp"

params ["_vehicle"];

private _entity = _vehicle getVariable [QPVAR(entity),objNull];

[_entity,false] call EFUNC(common,cooldown);
