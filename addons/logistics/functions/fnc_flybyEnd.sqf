#include "script_component.hpp"

params ["_vehicle"];

if (isNil {_vehicle getVariable QGVAR(flybyData)}) exitWith {};
	
_vehicle getVariable QGVAR(flybyData) params ["_player","_entity","_request","_startPosASL"];

_vehicle setVariable [QGVAR(end),true,true];

switch (_entity getVariable QPVAR(supportType)) do {
	case "AIRDROP" : {
		if (GVAR(cooldownTrigger) == "END") then {
			[_entity,false] call EFUNC(common,cooldown);
		};	
	};
	case "SLINGLOAD" : {
		private _vehicles = _entity getVariable [QPVAR(vehicles),[]];

		if (GVAR(cooldownTrigger) == "END" && {{alive _x && !(_x getVariable [QGVAR(end),false])} count _vehicles == 0}) then {
			[_entity,false] call EFUNC(common,cooldown);
		};
		
	};
	default {};
};

if (!alive _vehicle || {isTouchingGround _vehicle && !canMove _vehicle}) then {
	NOTIFY(_entity,LSTRING(notifyAirdropKilled))
};
