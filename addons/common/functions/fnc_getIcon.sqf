#include "script_component.hpp"

params [["_cfg","",[configNull,objNull,""]],["_fill",false]];

if (_cfg isEqualType objNull) then {
	_cfg = configOf _cfg;
};

if (_cfg isEqualType "") then {
	_cfg = configFile >> "CfgVehicles" >> _cfg;
};

private _icon = getText (_cfg >> "icon");

if (isText (configFile >> "CfgVehicleIcons" >> _icon)) then {
	_icon = getText (configFile >> "CfgVehicleIcons" >> _icon)
};

if (!fileExists _icon) then {
	_icon = getText (_cfg >> "picture");

	if (!fileExists _icon) then {
		_icon = ["","#(argb,1,1,1)color(0,0,0,1)"] select _fill
	};
};

_icon
