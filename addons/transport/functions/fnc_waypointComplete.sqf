#include "script_component.hpp"

params ["_group","_wpIndex"];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (_wpIndex >= count waypoints _group - 1) then {
	if (waypointDescription _this == "RTB" || waypointDescription _this == "RELOCATE") then {
		_vehicle call FUNC(landedStop);
		[_entity,false,"",[ELSTRING(common,statusIdleAtBase),[1,1,1,1]]] call EFUNC(common,setStatus);
	} else {
		if (waypointDescription _this == "LAND") then {
			_vehicle call FUNC(landedStop);
		};

		[_entity,false,"",[ELSTRING(common,statusIdleAwayFromBase),[1,1,1,1]]] call EFUNC(common,setStatus);
	};

	[_entity,[0,0,0]] call EFUNC(common,updateMarker);

	_entity setVariable [QPVAR(request),[],true];
	_entity setVariable [QPVAR(postponeIndex),nil,true];

	NOTIFY(_entity,LSTRING(notifyWaypointsComplete));
	[QPVAR(requestCompleted),[_entity getVariable [QPVAR(requester),objNull],_entity]] call CBA_fnc_globalEvent;
};

[QGVAR(waypointComplete),[_entity,[_group,_wpIndex]]] call CBA_fnc_localEvent;
