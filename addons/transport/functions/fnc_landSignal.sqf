#include "..\script_component.hpp"

params ["_entity","_vehicle","_group","_uid","_wpScript","_signalType","_searchRadius","_searchTimeout"];

_vehicle setVariable [QGVAR(signalType),_signalType,true];
_vehicle setVariable [QGVAR(searchRadius),_searchRadius,true];
_vehicle setVariable [QGVAR(signal),nil,true];
_vehicle setVariable [QGVAR(searching),true,true];

[{
	params ["_entity","_vehicle","_group","_uid","_wpScript"];
	
	if (_uid != waypointDescription [_group,currentWaypoint _group]) exitWith {
		DEBUG_2("WP UID Mismatch: %1: %2",_group,"LANDSIGNAL");
		true
	};

	!alive _vehicle || !isNil {_vehicle getVariable QGVAR(signal)}
},{
	params ["_entity","_vehicle","_group","_uid","_wpScript"];

	if (!alive _vehicle || _uid != waypointDescription [_group,currentWaypoint _group]) exitWith {};

	_vehicle getVariable [QGVAR(signal),[objNull,[0,0,0]]] params ["_signalObj","_signalPos"];
	_vehicle setVariable [QGVAR(signal),nil,true];

	if (!isNull _signalObj) then {
		_signalPos = getPos _signalObj;
	};

	private _wp = _group addWaypoint [_signalPos,0];
	_wp setWaypointType "SCRIPTED";
	_wp setWaypointScript _wpScript;
	_wp setWaypointDescription "LAND";

	_group setCurrentWaypoint _wp;

	_entity call FUNC(addPostponedTasks);
},[_entity,_vehicle,_group,_uid,_wpScript],_searchTimeout,{
	params ["_entity","_vehicle","_group","_uid","_wpScript"];

	_vehicle setVariable [QGVAR(signal),nil,true];
	_vehicle setVariable [QGVAR(searching),nil,true];

	if (!alive _vehicle || _uid != waypointDescription [_group,currentWaypoint _group]) exitWith {};

	_entity call FUNC(addPostponedTasks);
	
	if (currentWaypoint _group >= count waypoints _group - 1) then {
		[_group,true] call EFUNC(common,clearWaypoints);
	} else {
		_group setCurrentWaypoint [_group,currentWaypoint _group + 1];
	};
}] call CBA_fnc_waitUntilAndExecute;

//_vehicle setVariable [QGVAR(signalClass),nil,true];
//_vehicle setVariable [QGVAR(signalPos),nil,true];
//_vehicle setVariable [QGVAR(signalApproved),nil,true];
//_vehicle setVariable [QGVAR(deniedSignals),[],true];
//[{
//	params ["_entity","_vehicle","_signalType","_searchRadius","_group","_uid","_searchTick"];
//	
//	if (_uid != waypointDescription [_group,currentWaypoint _group]) exitWith {
//		DEBUG_2("WP UID Mismatch: %1: %2",_group,"LANDSIGNAL");
//		true
//	};
//
//	private _signal = _vehicle getVariable [QGVAR(signal),objNull];
//	
//	if (isNull _signal && _searchTick < CBA_missionTime && isNil {_vehicle getVariable QGVAR(signalPos)}) then {
//		_signal = [
//			_signalType,
//			waypointPosition [_group,currentWaypoint _group],
//			_searchRadius,
//			_vehicle getVariable QGVAR(deniedSignals)
//		] call EFUNC(common,signalSearch);
//		
//		_this set [6,CBA_missionTime + 5];
//
//		if (!isNull _signal) then {
//			_vehicle setVariable [QGVAR(signal),_signal,true];
//			_vehicle setVariable [QGVAR(signalClass),typeOf _signal,true];
//			_vehicle setVariable [QGVAR(signalPos),getPos _signal,true];
//
//			[_signal,"Deleted",{
//				params ["_signal"];
//				if (_thisArgs getVariable QPVAR(signal) isNotEqualTo _signal) exitWith {};
//				_thisArgs setVariable [QGVAR(signalPos),getPos _signal,true];
//			},_vehicle] call CBA_fnc_addBISEventHandler;
//
//			private _msg = {
//				format [LLSTRING(notifyLandSignalFound),_this call EFUNC(common,signalDescription)]
//			};
//
//			NOTIFY_1(_entity,_msg,typeOf _signal);
//		};
//	};
//
//	!alive _vehicle || _vehicle getVariable [QGVAR(signalApproved),false]
//},{
//	params ["_entity","_vehicle","_signalType","_searchRadius","_group","_uid","","_wpScript","_wpArgs"];
//
//	if (!alive _vehicle || _uid != waypointDescription [_group,currentWaypoint _group]) exitWith {};
//
//	private _signal = _vehicle getVariable [QGVAR(signal),objNull];
//	private _pos = getPos _signal;
//
//	if (isNull _signal) then {
//		_pos = _vehicle getVariable [QGVAR(signalPos),[0,0,0]];
//	};
//
//	_vehicle setVariable [QGVAR(signalPos),nil,true];
//
//	private _wp = _group addWaypoint [_pos,0];
//	_wp setWaypointType "SCRIPTED";
//	_wp setWaypointScript format ["%1 %2",_wpScript,_wpArgs];
//	_group setCurrentWaypoint _wp;
//
//	_entity call FUNC(addPostponedTasks);
//},_this,_searchTimeout,{
//	params ["_entity","_vehicle","_signalType","_searchRadius","_group","_uid"];
//
//	_vehicle setVariable [QGVAR(signal),nil,true];
//
//	if (!alive _vehicle || _uid != waypointDescription [_group,currentWaypoint _group]) exitWith {};
//
//	_entity call FUNC(addPostponedTasks);
//	
//	if (currentWaypoint _group >= count waypoints _group - 1) then {
//		[_group,true] call EFUNC(common,clearWaypoints);
//	} else {
//		_group setCurrentWaypoint [_group,currentWaypoint _group + 1];
//	};
//}] call CBA_fnc_waitUntilAndExecute;