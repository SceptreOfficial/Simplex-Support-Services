#include "..\script_component.hpp"

params ["_entity",["_busy",false,[false]],["_task","",[""]],["_status",[LSTRING(statusIdle),[1,1,1,1]],[[]],2]];

_entity = _entity getVariable [QPVAR(entity),_entity];

_entity setVariable [QPVAR(busy),_busy,true];
_entity setVariable [QPVAR(task),_task,true];
_entity setVariable [QPVAR(status),_status,true];

//DEBUG_2("%1: Task update: %2",_entity getVariable QPVAR(callsign),_task);
