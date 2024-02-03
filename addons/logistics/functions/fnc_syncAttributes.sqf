#include "..\script_component.hpp"

params ["_logic"];

if (typeOf _logic != QGVAR(moduleAddAirdrop) && typeOf _logic != QGVAR(moduleAddSlingload)) exitWith {};

private _class = _logic get3DENAttribute QGVAR(AircraftClass);

{
	_x params ["_connection","_vehicle"];
	
	if (_connection != "Sync" || {!(_vehicle isKindOf "Air")}) then {continue};
	
	_class = typeOf	_vehicle;

	if (_vehicle getVariable [QGVAR(edenEH),false]) exitWith {};
	_vehicle setVariable [QGVAR(edenEH),true];

	_vehicle addEventHandler ["AttributesChanged3DEN",{
		params ["_vehicle"];

		private _class = typeOf _vehicle;

		{
			if !(_x isEqualType []) then {continue};
			_x params ["_connection","_object"];
			if (_connection != "Sync") then {continue};
			_object set3DENAttribute [QGVAR(AircraftClass),_class];

		} forEach get3DENConnections _vehicle;
	}];

	break;
} forEach get3DENConnections _logic;

_logic set3DENAttribute [QGVAR(AircraftClass),_class];
