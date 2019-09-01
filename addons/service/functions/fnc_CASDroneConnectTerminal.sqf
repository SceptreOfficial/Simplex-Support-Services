#include "script_component.hpp"

params ["_vehicle","_enable"];

if (!alive _vehicle) exitWith {};

if (_enable) then {
	player enableUAVConnectability [_vehicle,true];
} else {
	player disableUAVConnectability [_vehicle,true];
};
