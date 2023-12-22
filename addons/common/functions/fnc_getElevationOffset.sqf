#include "script_component.hpp"

params ["_vehicle","_weapon"];

_weapon = toLower _weapon;
private _offset = 0;
private _compat = false;

{
	if (_vehicle isKindOf _x) then {
		_y params ["_default","_weaponHash"];

		if (_weaponHash isEqualType []) then {
			_weaponHash = createHashMapFromArray _weaponHash;
			GVAR(strafeElevationOffsets) set [_x,[_default,_weaponHash]];
		};

		_offset = _weaponHash getOrDefault [_weapon,_default];
		_compat = true;

		DEBUG_3("%1:%2 elevation offset: %3",_x,_weapon,_offset);
		
		continue;
	};
} forEach +GVAR(strafeElevationOffsets);

// Try to automatically get the offset
//if (!_compat) then {
//	_compat = -(([[_vehicle,_weapon] call BIS_fnc_weaponDirectionRelative,[0,0,1]] call FUNC(yawPitchBank)) # 1);
//	if (abs _compat > 0.5) then {_offset = _compat}
//};

_offset
