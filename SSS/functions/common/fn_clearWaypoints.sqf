#include "script_component.hpp"

params ["_vehicle"];

private _group = group _vehicle;
{deleteWaypoint [_group,0]; false} count (waypoints _group);

_group setSpeedMode (["LIMITED","NORMAL","FULL"] # (_vehicle getVariable "SSS_speedMode"));
_vehicle flyInHeight (_vehicle getVariable "SSS_flyingHeight");
_vehicle doFollow _vehicle;
