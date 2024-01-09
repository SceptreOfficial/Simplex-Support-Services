#include "script_component.hpp"

params [
	["_player",objNull,[objNull]],
	["_entity",objNull,[objNull]],
	["_task","",[""]],
	["_request",[]]
];

if (isNull _entity) exitWith {};

switch _task do {
	case "RELOCATE" : {
		_request params [
			["_posASL",[],[[]]]
		];

		if !(_posASL isEqualTypeParams [0,0,0]) exitWith {
			LOG_ERROR("INVALID POSITION");
		};

		[QGVAR(relocate),[_player,_entity,_posASL]] call CBA_fnc_serverEvent;
	};
	case "FIRE MISSION" : {
		_request params [
			["_plan",[],[[]]],
			["_loops",0,[0]],
			["_loopDelay",0,[0]],
			["_coordinated",[],[[]]]
		];

		if (_plan isEqualTo [] ||
			{_plan findIf {!(_x isEqualTypeParams [[[0,0,0],0,0,0,true],"",[],1,0,0])} > -1}
		) exitWith {
			LOG_ERROR("INVALID PLAN");
		};

		[QGVAR(fireMission),[_player,_entity,_plan,_loops,_loopDelay,_coordinated]] call CBA_fnc_serverEvent;
	};
};
