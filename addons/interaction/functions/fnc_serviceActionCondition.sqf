#include "script_component.hpp"

params ["_service","_actionParams"];
_actionParams params ["_target","_player"];

if (ADMIN_ACCESS_CONDITION) exitWith {true};

(switch (_service) do {
	case "artillery" : {
		[SSS_showArtillery,(_player getVariable ['SSS_assignedEntities',[]]) select {
			(_x getVariable "SSS_service") == "artillery" && {!isNull _x}
		}]
	};
	case "CAS" : {
		[SSS_showCAS,(_player getVariable ['SSS_assignedEntities',[]]) select {
			(_x getVariable "SSS_service") == "CAS" && {!isNull _x}
		}]
	};
	case "transport" : {
		[SSS_showTransport,(_player getVariable ['SSS_assignedEntities',[]]) select {
			(_x getVariable "SSS_service") == "transport" && {!isNull _x}
		}]
	};
}) params ["_showService","_assignedServices"];

_showService && {!(_assignedServices isEqualTo [])}
