#include "script_component.hpp"

params ["_vehicle"];

if (!local _vehicle || {_vehicle getVariable [QGVAR(killed),false]}) exitWith {};
_vehicle setVariable [QGVAR(killed),true,true];

private _entity = _vehicle getVariable [QPVAR(entity),objNull];

if (_entity getVariable [QPVAR(supportType),""] == "STRAFE") then {
	NOTIFY(_entity,LSTRING(notifyStrafeKilled));
} else {
	NOTIFY(_entity,LSTRING(notifyLoiterKilled));
};	

[_entity,false] call EFUNC(common,cooldown);
