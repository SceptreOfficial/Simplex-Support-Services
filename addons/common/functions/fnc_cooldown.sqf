#include "script_component.hpp"

params ["_entity","_time","_readyMessage"];

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(cooldown),2];
};

_entity setVariable ["SSS_cooldown",_time,true];

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
			NOTIFY(_entity,_readyMessage);
			[_PFHID] call CBA_fnc_removePerFrameHandler;
		};
	},1,[_entity,_readyMessage]] call CBA_fnc_addPerFrameHandler;
} else {
	// Physical
	[{
		params ["_args","_PFHID"];
		_args params ["_entity","_readyMessage"];
		private _cooldown = _entity getVariable "SSS_cooldown";
		private _vehicle = _entity getVariable "SSS_vehicle";

		if (alive _vehicle && {_cooldown > 0}) then {
			_entity setVariable ["SSS_cooldown",_cooldown - 1,true];
		};

		if (!alive _vehicle || {_cooldown <= 0}) then {
			if (alive _vehicle) then {
				NOTIFY(_entity,_readyMessage);
			};

			[_PFHID] call CBA_fnc_removePerFrameHandler;
		};
	},1,[_entity,_readyMessage]] call CBA_fnc_addPerFrameHandler;
};
