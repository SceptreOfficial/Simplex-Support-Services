#include "script_component.hpp"

params ["_entity","_order","_target",["_time",0]];

private _msg = {
	params ["_order","_target","_time"];

	if (_target isEqualType objNull) then {
		_target = getText (configOf _target >> "displayName");
	};

	if (_target isEqualType []) then {
		_target = _target call EFUNC(common,formatGrid);
	};

	if (_time > 0) then {
		format [localize (LSTRING(notifyTime) + _order),_target,_time call EFUNC(common,formatTime)]
	} else {
		format [localize (LSTRING(notify) + _order),_target]
	};
};

NOTIFY_3(_entity,_msg,_order,_target,_time);
