#include "script_component.hpp"

params ["_unit","_AIOpeningHeight"];

_unit setVariable ["SAA_paradropLoadout",getUnitLoadout _unit];
removeBackpack _unit;
_unit addBackpack "B_Parachute";

if (isPlayer _unit) then {
	[{
		!alive _this || {!(vehicle _this isKindOf "ParachuteBase") && (getPos _this # 2) < 2}
	},{
		_this setUnitLoadout (_this getVariable "SAA_paradropLoadout");
		_this setVariable ["SAA_paradropLoadout",nil];
	},_unit] call CBA_fnc_waitUntilAndExecute;
} else {
	[{
		params ["_unit","_AIOpeningHeight"];
		!alive _unit || {((getPos _unit) # 2) <= _AIOpeningHeight}
	},{
		params ["_unit"];

		_unit action ["OpenParachute",_unit];

		[{
			!alive _this || {!(vehicle _this isKindOf "ParachuteBase") && (getPos _this # 2) < 2}
		},{
			_this setUnitLoadout (_this getVariable "SAA_paradropLoadout");
			_this setVariable ["SAA_paradropLoadout",nil];
		},_unit] call CBA_fnc_waitUntilAndExecute;
	},[_unit,_AIOpeningHeight]] call CBA_fnc_waitUntilAndExecute;
};
