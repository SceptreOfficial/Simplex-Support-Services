#include "script_component.hpp"

params ["_vDir","_vUp"];

private _yaw = (_vDir # 0) atan2 (_vDir # 1);
_vDir = [_vDir,_yaw] call FUNC(rotateVector2D);
_vUp = [_vUp,_yaw] call FUNC(rotateVector2D);

[_yaw call CBA_fnc_simplifyAngle,(_vDir # 2) atan2 (_vDir # 1),(_vUp # 0) atan2 (_vUp # 2)]
