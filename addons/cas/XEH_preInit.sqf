#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "\a3\3den\ui\resincl.inc"
#include "cba_settings.sqf"

if (isServer && is3DEN) then {
	//[QEGVAR(common,ConnectionChanged3DEN),FUNC(syncAttributes)] call CBA_fnc_addEventHandler;

	if !(uiNamespace getVariable [QGVAR(edenEH),false]) then {
		private _edenDisplay = findDisplay IDD_DISPLAY3DEN;

		// Mark Eden display as cleared if it unloads. 
		_edenDisplay displayAddEventHandler ["Unload",{
			uiNamespace setVariable [QGVAR(edenEH),false];
			false
		}];

		add3DENEventHandler ["OnConnectingEnd",{
			params ["_class","_from","_to"];
			if (_class != "Sync" || isNil "_to") exitWith {};
			{_x call FUNC(syncAttributes)} forEach _from;
			_to call FUNC(syncAttributes);
		}];

		uiNamespace setVariable [QGVAR(edenEH),true];
	};

	[QGVAR(reinitialize)] collect3DENHistory {
		{if (_x isKindOf "Module_F") then {_x call FUNC(syncAttributes)}} forEach (all3DENEntities # 3);
	};
};

if (isServer) then {
	[QGVAR(request),{
		params ["_player","_entity","_request"];

		_entity setVariable [QPVAR(requester),_player,true];
		_entity setVariable [QPVAR(request),+_request];

		switch (_entity getVariable QPVAR(supportType)) do {
			//case "BOMBING" : FUNC(bombingRequest);
			case "LOITER" : FUNC(loiterRequest);
			case "STRAFE" : FUNC(strafeRequest);
		};

		[QPVAR(requestSubmitted),[_player,_entity,_request]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(abort),{
		params ["_player","_entity"];

		switch (_entity getVariable QPVAR(supportType)) do {
			//case "BOMBING" : FUNC(bombingAbort);
			case "LOITER" : FUNC(loiterAbort);
			case "STRAFE" : FUNC(strafeAbort);
		};

		[QPVAR(requestAborted),[_player,_entity,_entity getVariable QPVAR(request)]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;

	[QEGVAR(common,strafeSim),{
		params ["_vehicle"];
		private _entity = _vehicle getVariable [QPVAR(entity),objNull];
		if (_entity getVariable [QPVAR(service),""] != QSERVICE) exitWith {};
		[_entity,true,"STRAFE",[LSTRING(statusStrafe),RGBA_YELLOW]] call EFUNC(common,setStatus);
	}] call CBA_fnc_addEventHandler;

	[QEGVAR(common,strafeCleanup),{
		params ["_vehicle","_completed"];
		
		if (!alive _vehicle) exitWith {};

		private _entity = _vehicle getVariable [QPVAR(entity),objNull];
		if (_entity getVariable [QPVAR(service),""] != QSERVICE) exitWith {};

		if (_completed) then {
			[_entity,true,"EGRESS",[LSTRING(statusStrafeEgress),RGBA_YELLOW]] call EFUNC(common,setStatus);
			NOTIFY(_entity,LSTRING(notifyStrafeComplete));
			
			_vehicle getVariable [QGVAR(strafeData),[]] params ["","","","","_egressPosASL"];

			private _group = group _vehicle;
			private _wpIndex = currentWaypoint _group;
			private _pos = ASLtoAGL _egressPosASL;

			[_group,_wpIndex] setWaypointPosition [_pos,0];
			[_group,_wpIndex + 1] setWaypointPosition [_pos,0];

			_vehicle doMove _pos;
		} else {
			[_entity,true,"ABORT",[LSTRING(statusStrafeAbort),RGBA_YELLOW]] call EFUNC(common,setStatus);
			NOTIFY(_entity,LSTRING(notifyStrafeAbort));
		};
	}] call CBA_fnc_addEventHandler;
};

[QPVAR(guiConfirm),FUNC(gui_confirm)] call CBA_fnc_addEventHandler;

[QPVAR(guiAbort),FUNC(gui_abort)] call CBA_fnc_addEventHandler;

[QPVAR(guiUnload),{
	params ["_service","_entity"];
	if (_service != QSERVICE) exitWith {};
	_entity setVariable [QGVAR(cache),+GVAR(request)];
}] call CBA_fnc_addEventHandler;

[QPVAR(entityChanged),{
	params ["_entity","_oldEntity"];
	if (_oldEntity getVariable QPVAR(service) != QSERVICE) exitWith {};
	_oldEntity setVariable [QGVAR(cache),+GVAR(request)];
}] call CBA_fnc_addEventHandler;

ADDON = true;
