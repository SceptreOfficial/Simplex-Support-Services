#include "script_component.hpp"

params ["_entity","_vehicle"];

private _group = group _vehicle;
{deleteWaypoint [_group,0]} forEach (waypoints _group);

if (_vehicle isKindOf "Helicopter" || _vehicle isKindOf "VTOL_Base_F") then {
	_vehicle flyInHeight (_entity getVariable "SSS_flyingHeight");
};

_group setSpeedMode (["LIMITED","NORMAL","FULL"] # (_entity getVariable "SSS_speedMode"));
_vehicle doFollow _vehicle;
