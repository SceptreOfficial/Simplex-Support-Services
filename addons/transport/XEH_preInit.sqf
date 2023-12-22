#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

GVAR(taskNames) = createHashMapFromArray [
	["RTB",LLSTRING(RTB)],
	["MOVE",LLSTRING(Move)],
	["PATH",LLSTRING(Path)],
	["FOLLOW",LLSTRING(Follow)],
	["HOLD",LLSTRING(Hold)],
	["LAND",LLSTRING(Land)],
	["LANDSIGNAL",LLSTRING(LandSignal)],
	["HOVER",LLSTRING(Hover)],
	["FASTROPE",LLSTRING(Fastrope)],
	["HELOCAST",LLSTRING(Helocast)],
	["LOITER",LLSTRING(Loiter)],
	["SLINGLOADPICKUP",LLSTRING(SlingloadPickup)],
	["SLINGLOADDROPOFF",LLSTRING(SlingloadDropoff)],
	["UNLOAD",LLSTRING(Unload)],
	["PARADROP",LLSTRING(Paradrop)],
	["SAD",LLSTRING(SAD)],
	["STRAFE",LLSTRING(Strafe)],
	["FIRE",LLSTRING(Fire)],
	["RELOCATE",LLSTRING(Relocate)]
];

GVAR(taskIcons) = createHashMapFromArray [
	["RTB",ICON_HOME],
	["MOVE",ICON_MOVE],
	["PATH",ICON_SITREP],
	["FOLLOW",ICON_FOLLOW],
	["HOLD",ICON_WAIT],
	["LAND",ICON_LAND],
	["LANDSIGNAL",ICON_SMOKE_GRENADE],
	["HOVER",ICON_HOVER],
	["FASTROPE",ICON_ROPE],
	["HELOCAST",ICON_HELOCAST],
	["LOITER",ICON_COUNTER_CLOCKWISE],
	["SLINGLOADPICKUP",ICON_SLINGLOAD_PICKUP],
	["SLINGLOADDROPOFF",ICON_SLINGLOAD_DROPOFF],
	["UNLOAD",ICON_GET_OUT],
	["PARADROP",ICON_PARACHUTE],
	["SAD",ICON_TARGET_EYE],
	["STRAFE",ICON_CAS],
	["FIRE",ICON_TARGET],
	["RELOCATE",ICON_MAP]
];

if (isServer) then {
	[QGVAR(request),{
		params ["_player","_entity","_plan","_logic"];

		_entity setVariable [QPVAR(requester),_player,true];

		[_entity,+_plan,_logic] call FUNC(addTasks);

		[QPVAR(requestSubmitted),[_player,_entity,[_plan,_logic]]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(abort),{
		params ["_player","_entity"];

		private _vehicle = _entity getVariable QPVAR(vehicle);
		private _group = _entity getVariable QPVAR(group);
		
		[_group,true] call EFUNC(common,clearWaypoints);

		[_vehicle,true] call FUNC(abortControlScripts);

		NOTIFY(_entity,LSTRING(notifyAbort));

		[QPVAR(requestAborted),[_player,_entity,_entity getVariable QPVAR(request)]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;
};

[QEGVAR(common,remoteControlEnd),{
	params ["_player","_unit"];
	
	if (!local _unit) exitWith {};

	private _vehicle = vehicle _unit;
	private _entity = _vehicle getVariable [QPVAR(entity),objNull];

	if (isNull _entity ||
		{_entity getVariable [QPVAR(service),""] != QSERVICE} ||
		{_entity getVariable [QPVAR(supportType),""] != "HELICOPTER"}
	) exitWith {};

	private _group = _entity getVariable [QPVAR(group),grpNull];

	if (currentWaypoint _group >= count waypoints _group - 1) then {
		_vehicle call FUNC(landedStop);
	};
}] call CBA_fnc_addEventHandler;

[QPVAR(guiConfirm),FUNC(gui_confirm)] call CBA_fnc_addEventHandler;

[QPVAR(guiAbort),FUNC(gui_abort)] call CBA_fnc_addEventHandler;

[QPVAR(guiUnload),{
	params ["_service","_entity"];
	if (_service != QSERVICE) exitWith {};
	_entity setVariable [QGVAR(cache),+GVAR(plan)];
}] call CBA_fnc_addEventHandler;

[QPVAR(entityChanged),{
	params ["_entity","_oldEntity"];
	if (_oldEntity getVariable QPVAR(service) != QSERVICE) exitWith {};
	_oldEntity setVariable [QGVAR(cache),+GVAR(plan)];
}] call CBA_fnc_addEventHandler;

[QGVAR(guiPosUpdated),{
	params ["_display","_posASL"];
	
	if (GVAR(plan) # GVAR(planIndex) get "task" == "FOLLOW") then {
		_display getVariable [QGVAR(followListUpdate),[]] params ["_ctrlList","_fnc"];
		_ctrlList call _fnc;
	};
}] call CBA_fnc_addEventHandler;

ADDON = true;
