#include "script_component.hpp"

params ["_unit"];

!isNull remoteControlled _unit || !isNull (_unit getVariable ["bis_fnc_moduleRemoteControl_owner",objNull])
