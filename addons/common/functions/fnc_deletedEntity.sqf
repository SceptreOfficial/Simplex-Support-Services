#include "script_component.hpp"

params [["_entity",objNull,[objNull]]];

if (!isNil {_entity getVariable "SSS_parentEntity"}) then {
	_entity = _entity getVariable "SSS_parentEntity";
};

private _service = _entity getVariable "SSS_service";
if (isNil "_service") exitWith {};

[_entity getVariable "SSS_requesters",[_entity]] call FUNC(unassignRequesters);
SSS_entities deleteAt (SSS_entities find _entity);
publicVariable "SSS_entities";

deleteMarker (_entity getVariable "SSS_marker");
_entity setVariable ["SSS_respawnTime",-1,true];

private _base = _entity getVariable "SSS_base";

if (!isNil "_base") then {
	if (_base isEqualType objNull) then {
		deleteVehicle _base;
	};

	private _vehicle = _entity getVariable "SSS_vehicle";

	if (SSS_setting_deleteVehicleOnEntityRemoval) then {
		deleteVehicle _vehicle;
	} else {
		_vehicle call FUNC(decommission);
	};
};
