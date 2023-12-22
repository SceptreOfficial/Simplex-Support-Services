#include "script_component.hpp"

params ["_signal",["_returnColor",false]];

if (_signal isEqualType objNull) then {
	_signal = typeOf _signal;
};

switch true do {
	case (_signal isKindOf "FlareBase") : {
		private _color = getArray (configfile >> "CfgAmmo" >> _signal >> "lightColor");
		_color deleteAt 3;

		private _distances = (uiNamespace getVariable QGVAR(flareColors)) apply {[_color distance _x # 0,_x # 1,_x # 0]};
		_distances sort true;
		
		if (_returnColor) then {
			_distances # 0 # 2 + [1]
		} else {
			_distances # 0 # 1
		};
	};
	case (_signal isKindOf "ACE_G_Handflare_White") : {
		private _color = getArray (configfile >> "CfgAmmo" >> _signal >> "ace_grenades_color");
		_color deleteAt 3;

		private _distances = (uiNamespace getVariable QGVAR(flareColors)) apply {[_color distance _x # 0,_x # 1,_x # 0]};
		_distances sort true;
		
		if (_returnColor) then {
			_distances # 0 # 2 + [1]
		} else {
			_distances # 0 # 1
		};
	};
	case (_signal isKindOf "SmokeShell") : {
		private _color = getArray (configfile >> "CfgAmmo" >> _signal >> "smokeColor");
		_color deleteAt 3;

		private _distances = (uiNamespace getVariable QGVAR(smokeColors)) apply {[_color distance _x # 0,_x # 1,_x # 0]};
		_distances sort true;

		if (_returnColor) then {
			_distances # 0 # 2 + [1]
		} else {
			_distances # 0 # 1
		};
	};
	default {
		if (_returnColor) then {
			[1,1,1,1]
		} else {
			"WHITE"
		};
	};
};

// FLARE
//private _distances = [
//	[[0.5,0.5,0.5],"WHITE"],
//	[[0,0,0],"BLACK"],
//	[[0.5,0.25,0.25],"RED"],
//	[[0.6697,0.2275,0.10053],"ORANGE"],
//	[[0.5,0.5,0.25],"YELLOW"],
//	[[0.25,0.5,0.25],"GREEN"],
//	[[0.25,0.25,0.5],"BLUE"],
//	[[0.5,0.25,0.5],"PURPLE"]
//] apply {[_color distance _x # 0,_x # 1,_x # 0]};

// SMOKE
//private _distances = [
//	[[1,1,1],"WHITE"],
//	[[0,0,0],"BLACK"],
//	[[0.8438,0.1383,0.1353],"RED"],
//	[[0.6697,0.2275,0.10053],"ORANGE"],
//	[[0.9883,0.8606,0.0719],"YELLOW"],
//	[[0.2125,0.6258,0.4891],"GREEN"],
//	[[0.1183,0.1867,1],"BLUE"],
//	[[0.4341,0.1388,0.4144],"PURPLE"]
//] apply {[_color distance _x # 0,_x # 1,_x # 0]};