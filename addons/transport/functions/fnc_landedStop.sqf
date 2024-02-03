#include "..\script_component.hpp"

params ["_vehicle"];

if (isTouchingGround _vehicle || {getPos _vehicle # 2 < 1}) then {
	doStop _vehicle;
	[QEGVAR(common,enableAIFeature),[_vehicle,["PATH",false]],_vehicle] call CBA_fnc_targetEvent;
};
