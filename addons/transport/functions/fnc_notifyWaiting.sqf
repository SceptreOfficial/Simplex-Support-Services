#include "script_component.hpp"

params ["_entity","_order","_time"];

private _msg = {format [LLSTRING(notifyWaiting),(_this # 1) call EFUNC(common,properTime)]};

NOTIFY_2(_entity,_msg,_order,_time);
