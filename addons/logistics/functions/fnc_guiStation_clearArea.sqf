#include "script_component.hpp"

[
	PVAR(guiEntity) getVariable QPVAR(base),
	PVAR(guiEntity) getVariable QPVAR(clearingRadius),
	[nil,{!isNil {_x getVariable QPVAR(requester)}}] select GVAR(clearAreaRestriction)
] call EFUNC(common,clearObstructions);

NOTIFY_LOCAL(PVAR(guiEntity),LLSTRING(areaCleared));

[QGVAR(areaCleared),[PVAR(guiEntity)]] call CBA_fnc_localEvent;

