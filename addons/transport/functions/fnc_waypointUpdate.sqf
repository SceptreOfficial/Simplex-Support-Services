#include "script_component.hpp"

params ["_waypoint","_entity","_vehicle","_behaviors","_order","_target","_time"];

//DEBUG_2("Waypoint update: ""%1"" - %2",_entity getVariable QPVAR(callsign),_order);

[_entity,true,_order,[LSTRING(status) + _order,RGBA_YELLOW]] call EFUNC(common,setStatus);
[_entity,_order,_target,_time] call FUNC(notifyUpdate);

if (GVAR(taskMarkers)) then {
	if (_target isEqualType objNull) then {
		_target = getPos _target;
	};

	[_entity,_target,[(_entity getVariable QPVAR(callsign)) + ": %1",[LSTRING(status) + _order]]] call EFUNC(common,updateMarker);
};

[_entity,_behaviors] call FUNC(changeBehavior);

_vehicle engineOn true;
_vehicle doFollow _vehicle;
_vehicle land "NONE";

[{
	params ["_vehicle"];
	_vehicle getVariable [QGVAR(updateReady),true]
},{
	params ["_vehicle"];
	[QEGVAR(common,enableAIFeature),[_vehicle,["PATH",true]],_vehicle] call CBA_fnc_targetEvent;
	_vehicle call FUNC(abortControlScripts);
},_vehicle] call CBA_fnc_waitUntilAndExecute;

_vehicle setVariable [QGVAR(endHold),nil,true];
_vehicle setVariable [QGVAR(hold),nil,true];

if (_order == "RTB") then {
	//[QEGVAR(common,setCombatMode),[_vehicle,"BLUE"],_vehicle] call CBA_fnc_targetEvent;
	[QEGVAR(common,enableAttack),[group _vehicle,false],group _vehicle] call CBA_fnc_targetEvent;
	[QEGVAR(common,enableAIFeature),[_vehicle,["TARGET",false]],_vehicle] call CBA_fnc_targetEvent;
	[QEGVAR(common,enableAIFeature),[_vehicle,["AUTOTARGET",false]],_vehicle] call CBA_fnc_targetEvent;
};

if (_order == "SAD") then {
	[QEGVAR(common,setBehaviour),[_vehicle,"COMBAT"],_vehicle] call CBA_fnc_targetEvent;
	[QEGVAR(common,setCombatMode),[_vehicle,"RED"],_vehicle] call CBA_fnc_targetEvent;
	[QEGVAR(common,enableAttack),[group _vehicle,true],group _vehicle] call CBA_fnc_targetEvent;
	[QEGVAR(common,enableAIFeature),[_vehicle,["TARGET",true]],_vehicle] call CBA_fnc_targetEvent;
	[QEGVAR(common,enableAIFeature),[_vehicle,["AUTOTARGET",true]],_vehicle] call CBA_fnc_targetEvent;
};

[QGVAR(waypointUpdate),[_entity,_waypoint]] call CBA_fnc_localEvent;
