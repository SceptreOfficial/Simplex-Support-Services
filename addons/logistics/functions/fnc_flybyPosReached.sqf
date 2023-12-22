#include "script_component.hpp"

params ["_vehicle"];

if (isNil {_vehicle getVariable QGVAR(flybyData)}) exitWith {};
	
_vehicle getVariable QGVAR(flybyData) params ["_player","_entity","_request","_startPosASL"];

switch (_entity getVariable QPVAR(supportType)) do {
	case "AIRDROP" : FUNC(airdropUnload);
};
