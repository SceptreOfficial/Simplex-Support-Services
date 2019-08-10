#include "script_component.hpp"

params ["_target","_player","_vehicle"];

[
	[["SSS_vehicleDropAir","Air Drop","\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\plane_ca.paa",{
		SSS_vehicleDropRequestType = 0;
		true call VVS_fnc_openVVS;
	},{true},{}] call ace_interact_menu_fnc_createAction,[],_target]
]
