#include "..\script_component.hpp"

params [
	["_unit",objNull,[objNull]],
	["_openAltitude",150,[0]],
	["_parachuteClass","",[""]]
];

if (!local _unit) exitWith {
	[QGVAR(execute),[_this,QFUNC(paradropUnit)],_unit] call CBA_fnc_targetEvent;
};

if (_parachuteClass isEqualTo "") then {
	_parachuteClass = "B_Parachute";
};

if (_openAltitude <= 0) then {
	_openAltitude = getPos _unit # 2 + 999;
};

_unit setVariable [QGVAR(paradropLoadout),getUnitLoadout _unit];
removeBackpack _unit;

if (isPlayer _unit) then {
	_unit addBackpack _parachuteClass;

	if (OPTION(autoParachute)) then {
		[{
			params ["_unit","_openAltitude"];
			isNull _unit || getPos _unit # 2 <= _openAltitude
		},{
			params ["_unit"];
			_unit action ["OpenParachute",_unit];
		},[_unit,_openAltitude]] call CBA_fnc_waitUntilAndExecute;
	};
} else {
	[{
		params ["_unit","_openAltitude"];
		isNull _unit || getPos _unit # 2 <= _openAltitude
	},{
		params ["_unit","","_parachuteClass"];
		_unit addBackpack _parachuteClass;
		_unit action ["OpenParachute",_unit];
	},[_unit,_openAltitude,_parachuteClass]] call CBA_fnc_waitUntilAndExecute;
};

[{
	isNull _this || {!(vehicle _this isKindOf "ParachuteBase") && getPos _this # 2 < 2}
},{
	_this setUnitLoadout (_this getVariable QGVAR(paradropLoadout));
	_this setVariable [QGVAR(paradropLoadout),nil];
	[QGVAR(paradropUnitEnd),[_this]] call CBA_fnc_globalEvent;
},_unit] call CBA_fnc_waitUntilAndExecute;

[QGVAR(paradropUnitStart),[_unit]] call CBA_fnc_globalEvent;
