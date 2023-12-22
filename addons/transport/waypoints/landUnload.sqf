#include "script_component.hpp"
#define ORDER "UNLOAD"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_ejectTypes",[]],
	["_ejectionsID",""]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

private _moveTick = 0;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;
		_vehicle setDestination [_wpPos,"LEADER PLANNED",true];
		_vehicle doMove _wpPos;
	};

	sleep 0.2;

	unitReady _vehicle
};

_ejectTypes params [["_allPlayers",true,[true]],["_allAI",true,[true]],["_allCargo",true,[true]]];

private _ejections = _group getVariable [_ejectionsID,[]];
_ejections append ([[],getVehicleCargo _vehicle] select _allCargo);
_ejections append (SECONDARY_CREW(_vehicle) select {(_allPlayers && isPlayer _x) || (_allAI && !isPlayer _x)});

_vehicle setVariable [QGVAR(unloadEnd),false,true];

[{
	params ["_args","_PFHID"];
	_args params ["_entity","_vehicle","_ejections"];

	if (!alive _vehicle || _ejections isEqualTo []) exitWith {
		_vehicle setVariable [QGVAR(unloadEnd),true,true];
		_PFHID call CBA_fnc_removePerFrameHandler;
	};

	private _item = _ejections deleteAt 0;

	[QEGVAR(common,execute),[[_item,_vehicle],{
		params ["_item","_vehicle"];

		if (_item isKindOf "CAManBase") then {
			[QEGVAR(common,orderGetIn),[[_item],false],_item] call CBA_fnc_targetEvent;
			[QEGVAR(common,unassignVehicle),_item,_item] call CBA_fnc_targetEvent;
			moveOut _item;
		} else {
			objNull setVehicleCargo _item;
		};
	}],_item] call CBA_fnc_targetEvent;
},UNLOAD_DELAY,[_entity,_vehicle,_ejections]] call CBA_fnc_addPerFrameHandler;

waitUntil {
	sleep 0.2;
	_vehicle getVariable [QGVAR(unloadEnd),false]
};

_group setVariable [_ejectionsID,nil,true];

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
