#include "script_component.hpp"

params ["_entity","_readyMessage"];

if (isNil {_entity getVariable "SSS_base"}) then {
	// Virtual
	[{
		params ["_args","_PFHID"];
		_args params ["_entity","_readyMessage"];
		private _cooldown = _entity getVariable "SSS_cooldown";

		if (_cooldown > 0) then {
			_entity setVariable ["SSS_cooldown",_cooldown - 1,true];
		};
		if (_cooldown <= 0) then {
			NOTIFY(_entity,_readyMessage)
			[_PFHID] call CBA_fnc_removePerFrameHandler;
		};
	},1,_this] call CBA_fnc_addPerFrameHandler;
} else {
	// Physical
	[{
		params ["_args","_PFHID"];
		_args params ["_vehicle","_readyMessage"];
		private _cooldown = _vehicle getVariable "SSS_cooldown";

		if (alive _vehicle && {_cooldown > 0}) then {
			_vehicle setVariable ["SSS_cooldown",_cooldown - 1,true];
		};
		if (!alive _vehicle || {_cooldown <= 0}) then {
			if (alive _vehicle) then {
				NOTIFY(_vehicle,_readyMessage)
			};
			[_PFHID] call CBA_fnc_removePerFrameHandler;
		};
	},1,_this] call CBA_fnc_addPerFrameHandler;
};
