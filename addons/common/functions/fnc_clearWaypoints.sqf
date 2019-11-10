#include "script_component.hpp"

params ["_entity","_vehicle"];

private _group = group _vehicle;
{deleteWaypoint [_group,0]} forEach (waypoints _group);

_group setSpeedMode (["LIMITED","NORMAL","FULL"] # (_entity getVariable "SSS_speedMode"));
_vehicle doFollow _vehicle;
