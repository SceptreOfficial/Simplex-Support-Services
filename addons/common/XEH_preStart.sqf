#include "script_component.hpp"
#include "XEH_PREP.hpp"

uiNamespace setVariable [
	QGVAR(supportModules),
	(configProperties [configFile >> "CfgVehicles",QUOTE(isClass _x && isNumber (_x >> QQPVAR(entity)))]) apply {configName _x}
];

// Smoke and flare color references
private _cfgAmmo = configfile >> "CfgAmmo";
private _smokeColors = [[[1,1,1],"WHITE"],[[0,0,0],"BLACK"]];
private _flareColors = [
	[[0.5,0.5,0.5],"WHITE"],
	[[0,0,0],"BLACK"],
	[[0.6697,0.2275,0.10053],"ORANGE"],
	[[0.25,0.25,0.5],"BLUE"],
	[[0.5,0.25,0.5],"PURPLE"]
];

{
	private _color = getArray (_cfgAmmo >> _x # 0 >> "smokeColor");
	_color deleteAt 3;
	_smokeColors pushBack [_color,_x # 1];
} forEach [
	["SmokeShellRed","RED"],
	["SmokeShellOrange","ORANGE"],
	["SmokeShellYellow","YELLOW"],
	["SmokeShellGreen","GREEN"],
	["SmokeShellBlue","BLUE"],
	["SmokeShellPurple","PURPLE"]
];

{
	private _color = getArray (_cfgAmmo >> _x # 0 >> "lightColor");
	_color deleteAt 3;
	_flareColors pushBack [_color,_x # 1];
} forEach [
	["F_20mm_Red","RED"],
	["F_20mm_Yellow","YELLOW"],
	["F_20mm_Green","GREEN"]
];

uiNamespace setVariable [QGVAR(smokeColors),_smokeColors];
uiNamespace setVariable [QGVAR(flareColors),_flareColors];
