#include "..\script_component.hpp"

params [
	["_target",grpNull,[grpNull,objNull]],
	["_position",[],[[]]],
	["_radius",0,[0]],
	["_type","MOVE",[""]],
	["_behaviour","UNCHANGED",[""]],
	["_combatMode","NO CHANGE",[""]],
	["_speed","UNCHANGED",[""]],
	["_formation","NO CHANGE",[""]],
	["_statements",["true",""],[[]],2],
	["_timeout",[0,0,0],[[]],3],
	["_completionRadius",0,[0]]
];

if (_position isEqualTo []) exitWith {};
if (_target isEqualType objNull) then {_target = group _target};
if (_behaviour isEqualTo "") then {_behaviour = "UNCHANGED"};
if (_combatMode isEqualTo "") then {_combatMode = "NO CHANGE"};
if (_speed isEqualTo "") then {_speed = "UNCHANGED"};
if (_formation isEqualTo "") then {_formation = "NO CHANGE"};

private _WP = _target addWaypoint [_position,_radius];
_WP setWaypointType _type;
_WP setWaypointStatements _statements;
_WP setWaypointTimeout _timeout;
_WP setWaypointCompletionRadius _completionRadius;

[QGVAR(addWaypointServer),[_WP,_behaviour,_combatMode,_speed,_formation]] call CBA_fnc_serverEvent;

//[{(_this # 0) setWaypointPosition [_this # 1,0]},[_WP,_position],1] call CBA_fnc_waitAndExecute;

_WP
