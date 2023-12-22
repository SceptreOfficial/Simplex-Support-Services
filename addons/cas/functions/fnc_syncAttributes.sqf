#include "script_component.hpp"

params ["_logic"];

if !(typeOf _logic in [QGVAR(moduleAddBombing),QGVAR(moduleAddLoiter),QGVAR(moduleAddStrafe)]) exitWith {};

private _class = _logic get3DENAttribute QGVAR(AircraftClass);
private _pylons = _logic get3DENAttribute QGVAR(Pylons);
//private _filter = [{},{
//	getNumber (_cfgMagazines >> _this # 1 >> "initSpeed") == 0
//}] select (_logic isKindOf QGVAR(moduleAddBombing));

{
	_x params ["_connection","_vehicle"];
	
	if (_connection != "Sync" || {!(_vehicle isKindOf "Air")}) then {continue};
	
	_class = typeOf	_vehicle;
	_pylons = str (_vehicle call EFUNC(common,getPylons));

	if (_vehicle getVariable [QGVAR(edenEH),false]) exitWith {};
	_vehicle setVariable [QGVAR(edenEH),true];

	_vehicle addEventHandler ["AttributesChanged3DEN",{
		params ["_vehicle"];
		{
			if !(_x isEqualType []) then {continue};
			_x params ["_connection","_object"];
			_object call FUNC(syncAttributes);
		} forEach get3DENConnections _vehicle;
	}];

	break;
} forEach get3DENConnections _logic;

_logic set3DENAttribute [QGVAR(AircraftClass),_class];
_logic set3DENAttribute [QGVAR(Pylons),_pylons];
